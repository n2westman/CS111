// UCLA CS 111 Lab 1 command execution

#define _GNU_SOURCE //It made error warnings go away

#include "command.h"
#include "command-internals.h"
#include "alloc.h"

#include <error.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>


/* Declarations */
void exec_command (command_t c); //Bread and butter

typedef struct map		*map_t;
typedef struct thread_node 	*thread_node_t;
typedef struct map_node 	*map_node_t;
typedef struct file_node 	*file_node_t;

/* Globals :/ */
map_t d_map;
int num_threads = 0;
pthread_mutex_t ntlock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t runlock = PTHREAD_MUTEX_INITIALIZER;

/* Structures */

struct map {
	map_node_t top, bot;
};

enum dependency_type {
	D_READ,
	D_WRITE
};

struct thread_node
{
	pthread_t thread_id;
	enum dependency_type d_type;
	thread_node_t next;
};

struct map_node
{
	char *file_name;
	thread_node_t thread_queue;
	map_node_t next;
};

struct file_node
{
	char *file_name;
	enum dependency_type d_type;
	file_node_t next, prev;
};

///////////////////////////////////////////////
//// File Dependency Queue
///////////////////////////////////////////////

// The structure itself
typedef struct fd_queue
{
	file_node_t head, tail;
} *fd_queue_t;

void
fd_queue_init(fd_queue_t q)
{
	q->head = NULL;
	q->tail = NULL;
}

void
fd_queue_push (fd_queue_t q, file_node_t file)
{
	if (!q->head)		// The queue is empty
	{
		q->head = file;
		q->tail = file;
	}
	else
	{
		file_node_t old_tail = q->tail;
		old_tail->next = file;
		q->tail = file;
		q->tail->prev = old_tail;
	}
}

file_node_t
fd_queue_pop (fd_queue_t q)
{
	file_node_t to_return = NULL;
	
	if (q->head)
	{
		file_node_t old_head = q->head;
		q->head = old_head->next; // NULL if no more
		if (q->head)		// That is, the NEW head
			q->head->prev = NULL;
		else				// If the queue is now empty
		{
			q->tail = NULL;
		}
		to_return = old_head;
	}
	return to_return;
}

///////////////////////////////////////////////
//// Other functions
///////////////////////////////////////////////


command_t
merge_commands(command_t cmd_a, command_t cmd_b)
{
	command_t to_return = checked_malloc(sizeof(struct command));
	
	to_return->type = SEQUENCE_COMMAND;
	to_return->u.command[0] = cmd_a;
	to_return->u.command[1] = cmd_b;
	
	return to_return;
	
}

/*	INTEGRATE_COMMAND_STREAM
 *	This function takes a command stream and concatenates
 * 	it into (essentially) one large command.
 *
 * 	i.e. multiple command nodes --> one command node
 */
command_t
build_full_tree (command_stream_t cst)
{
	command_t temp = NULL;
	command_t to_return = read_command_stream(cst);
	
	if (to_return)
		temp = read_command_stream(cst);
	
	while(temp)
	{
		to_return = merge_commands(to_return, temp);
		temp = read_command_stream(cst);
	}
	
	return to_return;
}

///////////////////////////////////////////////
//// Making the Queue
///////////////////////////////////////////////

void
fd_queue_add_redirects (fd_queue_t q, command_t cmd)
{
	if (cmd->input) // Has '<' redirect
	{
		file_node_t temp = checked_malloc(sizeof(struct file_node));
		temp->file_name = cmd->input;
		temp->d_type = D_READ;
		fd_queue_push(q, temp);
	}
	if (cmd->output) // Has '>' redirect
	{
		file_node_t temp = checked_malloc(sizeof(struct file_node));
		temp->file_name = cmd->output;
		temp->d_type = D_WRITE;
		fd_queue_push(q, temp);
	}
}

/*TRAVERSE AND BUILD
 *
 * Recursive function that performs an in-order traversal
 * of the command to find all the files and their respective
 * dependancies and add them to the queue.
 */
void
traverse_and_build (fd_queue_t q, command_t cmd)
{
	if (!cmd)
		return;
		
	switch (cmd->type)
	{
		case AND_COMMAND:
		case OR_COMMAND:
		case SEQUENCE_COMMAND:
		case PIPE_COMMAND:
		{
			// In Order: left child then right child
			traverse_and_build(q, cmd->u.command[0]);
			traverse_and_build(q, cmd->u.command[1]);
			break;
		}
		case SUBSHELL_COMMAND:
		{
			traverse_and_build(q, cmd->u.subshell_command);
			fd_queue_add_redirects(q, cmd);
			break;
		}
		case SIMPLE_COMMAND:
		{
			fd_queue_add_redirects(q, cmd);
			
			// Add file arguments (w/ READ dependency):
			int index = 1;
			while (cmd->u.word[index])
			{
				file_node_t temp = checked_malloc(sizeof(struct file_node));
				temp->file_name = cmd->u.word[index];
				temp->d_type = D_READ;
				fd_queue_push(q, temp);
				index++;
			}
			
			break;
		}
		default:
			error(1, 0, "Invalid command type");
	}
}

fd_queue_t
generate_fd_queue (command_t cmd)
{
	fd_queue_t queue = checked_malloc(sizeof(struct fd_queue));
	
	fd_queue_init(queue);
	traverse_and_build(queue, cmd);
	
	return queue;
}

void //Debugging
print_queue (fd_queue_t q)
{
	file_node_t node = q->head;
	int num = 0;
	
	while (node)
	{
		char *type = (node->d_type == D_READ) ? "D_READ" : "D_WRITE";
		printf("File # = '%i'; Name = '%s'; Type = '%s'\n", num, node->file_name, type);
		
		num++;
		node = node->next;
	}
}

/* Building the map */

void
add_map_node (file_node_t toAdd, pthread_t t)
{
	map_node_t cur = checked_malloc(sizeof(struct map_node));
	cur->next = 0;
	cur->file_name = toAdd->file_name;
	cur->thread_queue = 
		checked_malloc(sizeof(struct thread_node));
	cur->thread_queue->d_type = toAdd->d_type;
	cur->thread_queue->thread_id = t;

	if(!d_map->top)
		d_map->top = d_map->bot = cur;
	else
	{
		d_map->bot->next = cur;
		d_map->bot = cur;
	}
}

void
add_thread_node(map_node_t node, enum dependency_type type, pthread_t t)
{
	thread_node_t temp;
	thread_node_t cur = checked_malloc(sizeof(struct thread_node));
	cur->d_type = type;
	cur->thread_id = t;
	cur->next = 0;

	temp = node->thread_queue;
	if(temp->thread_id == t)
		return;

	while(temp->next)
	{
		if(temp->next->thread_id == t)
			return;
		temp = temp->next;
	}
	temp->next = cur;	
}


void 
add_dependencies(command_t c, pthread_t t)
{
	fd_queue_t q = generate_fd_queue (c);
	file_node_t toAdd;
	map_node_t cur;
	bool added;
	while((toAdd = fd_queue_pop(q)))
	{
		cur = d_map->top;
		added = false;
		if(!cur && toAdd)
		{
			add_map_node(toAdd, t);
			//printf("Added it!\n");
			continue;
		}
		while(cur)
		{
			if(strcmp(cur->file_name, toAdd->file_name) == 0)
			{
				add_thread_node(cur, toAdd->d_type, t);	
				added = true;
			}
			cur = cur->next;
		}
		if(!added)
		{
			add_map_node(toAdd, t);	
		}
	}

//	printf("Added thread %u's dependencies\n", (unsigned int)t);
}

/* Taking apart the map */

void
remove_dependencies(pthread_t t)
{
	map_node_t cur = d_map->top;
	thread_node_t prev, temp;

	while(cur)
	{
		temp = cur->thread_queue;
		while(temp)
		{
			if(temp->thread_id != t)
			{
				prev = temp;
				temp = temp->next;
			}
			else if (temp == cur->thread_queue)
			{
				cur->thread_queue = temp->next;
				free(temp);
			}
			else
			{
				prev->next = temp->next;
				free(temp);	
			}
		}
		cur = cur->next;
	}

//	printf("Removing thread %u's dependencies\n", (unsigned int)t);
}

/* Execution time!! */

bool
can_run(command_t c, pthread_t t)
{
//	if(!t)	printf("Thread %u can run!\n", (unsigned int)t);
	
	fd_queue_t q = generate_fd_queue (c);
	file_node_t toCheck;

	map_node_t cur;
	thread_node_t thread;

	
	while((toCheck = fd_queue_pop(q)))
	{
	cur = d_map->top;
	while(cur) //Does a simple dependency check. Not the MOST efficient.
	{
		if(strcmp(cur->file_name, toCheck->file_name) == 0)
		{	
		thread = cur->thread_queue;
		while(thread)
		{
			if(thread->thread_id == t)
				break;
			if(thread->d_type == D_WRITE)	
				return false;
			
			thread = thread->next;
		}
		}
		cur = cur->next;
	}
	}
	 

	return true;
}

//Why is this here?
int
command_status (command_t c)
{
	return c->status;
}

void
redirect (command_t c)
{
	int fd;
	if(c->input)
	{
		fd = open (c->input, O_RDONLY);
		if (fd < 0)
			error(1, 0, "Can't open input: %s\n", c->input);
		else
			dup2 (fd, 0);
	}
	if(c->output)
	{
		fd = open (c->output, O_WRONLY|O_CREAT|O_TRUNC, 0666);
		if (fd < 0)
			error(1, 0, "Can't open output: %s\n", c->output);
		else
			dup2 (fd, 1);
	}
}

void
exec_sequence (command_t c)
{
	exec_command(c->u.command[0]);
	exec_command(c->u.command[1]);
	c->status = c->u.command[1]->status;
}

void 
exec_and (command_t c)
{
	exec_command(c->u.command[0]);
	c->status = c->u.command[0]->status;

	if(c->status == 0)
	{
		exec_command(c->u.command[1]);
		c->status = c->u.command[1]->status;
	}
}

void
exec_or (command_t c)
{
	exec_command(c->u.command[0]);
	c->status = c->u.command[0]->status;

	if(c->status != 0)
	{
		exec_command(c->u.command[1]);
		c->status = c->u.command[1]->status;
	}
}

void
exec_pipe (command_t c)
{
	int fd[2];
	pipe(fd);
	pid_t p = fork();
	if(p<0) error(1, 0, "Fork messed UP!");
	else if(!p) //It's the first command in pipe
	{
		close (fd[0]); //We don't need to assign input
		dup2  (fd[1], 1); //Assign stdout to pipe
		close (fd[1]); 
		exec_command(c->u.command[0]);
		exit(c->u.command[0]->status);
	}
	else //It's the second command in pipe
	{
		close (fd[1]);
		dup2  (fd[0], 0);
		close (fd[0]);
		exec_command(c->u.command[1]);
	}
}

void
exec_simple (command_t c)
{
	int status;
	pid_t p = fork();
	if(p<0) error(1,0, "Fork Error");
	else if (!p) //Child executes the command, parent retains control.
	{
		redirect(c);
		execvp(c->u.word[0], c->u.word);
		error (1, 0, "execvp failed");
	}
	else //Parent keeps track of the child
	{
		if(waitpid(p, &status, 0) < 0)
			error(1,0,"Couldn't wait");
		c->status = WEXITSTATUS(status);
	}
}

void
exec_subshell (command_t c)
{
	int status;
	pid_t p = fork();
	if(p<0) error(1,0, "Fork Error");
	else if (!p) //Child executes the command, parent retains control.
	{
		redirect(c);
		exec_command(c->u.subshell_command);
		exit(c->u.subshell_command->status);	
	}
	else //Parent keeps track of the child
	{
		if(waitpid(p, &status, 0) < 0)
			error(1,0,"Couldn't wait");
		c->status = WEXITSTATUS(status);
	}
}

void
exec_command (command_t c)
{
	switch (c->type)
	{
		case SEQUENCE_COMMAND:
			exec_sequence(c);
			break;
		case AND_COMMAND:
			exec_and(c);	
			break;
		case OR_COMMAND:
			exec_or(c);
			break;
		case PIPE_COMMAND:
			exec_pipe(c);
			break;
		case SUBSHELL_COMMAND:
			exec_subshell(c);
			break;
		case SIMPLE_COMMAND:
			exec_simple(c);
			break;
	}
}

void 
exec_thread(void* command)
{
	command_t c = (command_t) command;
	pthread_t t = pthread_self();
	
	if(!c)	
		exit(0);	
	
	pthread_mutex_lock(&runlock);
	while(!can_run(c, t))
	{
		pthread_mutex_unlock(&runlock);
		pthread_yield();
		pthread_mutex_lock(&runlock);	
	}
	pthread_mutex_unlock(&runlock);

	exec_command(c);

	pthread_mutex_lock(&runlock);
	pthread_mutex_lock(&ntlock);

	remove_dependencies(t);
	num_threads--;

	pthread_mutex_unlock(&ntlock);
	pthread_mutex_unlock(&runlock);
	
	pthread_exit(0);	
}

void
init_thread (command_t toExecute)
{
	if(!toExecute)
		error(1, 0, "Trying to start a thread of an empty command");
	
	pthread_mutex_lock(&ntlock);
	pthread_mutex_lock(&runlock);

	pthread_t tid;
	int status = pthread_create(&tid, 0, (void*)&exec_thread, toExecute);

	if(status != 0)
		error(1,0,"Bad thread creation");

	num_threads++;
	add_dependencies(toExecute, tid);
//	printf("Made Thread!\n");

	pthread_mutex_unlock(&runlock);
	pthread_mutex_unlock(&ntlock);	
}

/* Recursively starts our pthreads, keep it simple here */
void
start_threads (command_t root)
{
	if(!root || root->type != SEQUENCE_COMMAND)
		init_thread(root);
	else
	{
		start_threads(root->u.command[0]);
		start_threads(root->u.command[1]);
	}
}

void
wait_for_threads()
{
	pthread_mutex_lock(&ntlock); //Grab hold of the lock.
	while(num_threads > 0)
	{
		if(num_threads < 0)
			error(1, 0, "Neg Threads?");
		pthread_mutex_unlock(&ntlock);
		if(pthread_yield())
			error(1, 0, "Couldn't yield");
		pthread_mutex_lock(&ntlock);
	}
}

void
execute_command_stream (command_stream_t cst, bool time_travel)
{
	if(!cst) 
		error(1, 0, "SOMETHING IS WRONG");
	if(!time_travel) 
		error(1, 0, "SOMETHING IS WRONG");
	
	command_t root = build_full_tree(cst);

	d_map = checked_malloc(sizeof(struct map));
	d_map->top = d_map->bot = 0;

	start_threads(root);	
	wait_for_threads();
//	print_dependency();
}

void
execute_command (command_t c, bool time_travel)
{
	if(!c)
		error(1,0, "Null Command, error!");
	if(time_travel)
		error(1,0, "Time Travel Not yet implemented");	
	exec_command(c);
}
