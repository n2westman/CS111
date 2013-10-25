// UCLA CS 111 Lab 1 command reading

#include "command-internals.h"
#include "command.h"
#include "alloc.h"

#include <error.h>
#include <error.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

struct command_stream
{
	command_node_t head, tail;
};
   
////////////////////////////////////////////////////////////
// CHAR_STREAM
////////////////////////////////////////////////////////////
char
char_stream_current (char_stream_t cst)
{
	return cst->c;
}


void
char_stream_init (char_stream_t cst)
{
	cst->last = '\0';
	if (cst->c == '\0') // If it's not looking at anything...
		cst->c = cst->get_next_byte(cst->get_next_byte_argument);
}

char
char_stream_read (char_stream_t cst)
{
	if (cst->c == '\0') // If it's not looking at anything...
		cst->c = cst->get_next_byte(cst->get_next_byte_argument);
		
	cst->last = cst->c;
	cst->c = cst->get_next_byte(cst->get_next_byte_argument);
	
	return cst->c;
}

////////////////////////////////////////////////////////////
// TOKENS
////////////////////////////////////////////////////////////
void
token_stream_add (token_stream_t tst, token_t token)
{
	// Allocate memory for the token and set it up
	token_node_t temp_node = checked_malloc(sizeof(struct token_node));
	temp_node->next = NULL;
	temp_node->token = token;
	
	// Add it to the stream
	if (!tst->head)
		tst->head = temp_node;
	else
		tst->tail->next = temp_node;
	tst->tail = temp_node;
}

token_t
token_stream_read (token_stream_t tst)
{
	token_t temp_token = NULL;
	if (tst->head)
	{
		token_node_t temp_node = tst->head;
		temp_token = temp_node->token;
		tst->head = tst->head->next;
		free(temp_node);
	}
	return temp_token;
}

token_t
token_stream_current (token_stream_t tst)
{
	if (!tst->head)
		return NULL;
	return tst->head->token;
}

//like read, without the return
void
token_stream_free_head (token_stream_t tst)
{
	if (tst->head)
	{
		token_node_t temp_node = tst->head;
		tst->head = tst->head->next;
		free_token(temp_node->token);
		free(temp_node);
	}
}

void
free_token (token_t token)
{
	if (token->string)
		free(token->string);
	free(token);
}

////////////////////////////////////////////////////////////
// LEXER
////////////////////////////////////////////////////////////
bool
is_regular_char (char c)
{
	bool isReg = false;
	switch (c)
	{
		case '!':
		case '@':
		case '%':
		case '^':
		case '-':
		case '_':
		case '+':
		case ':':
		case ',':
		case '.':
		case '/':
			isReg = true;
			break;		
	}
	if (isalpha(c) || isdigit(c))
		isReg = true;
	return isReg;
}

token_stream_t
char_stream_to_token_stream (char_stream_t cst)
{
	// Initialize the new token_stream, allocating memory and setting variables
	token_stream_t stream = checked_malloc(sizeof(struct token_stream));
	stream->head = NULL;
	stream->tail = NULL;
	
	// Prev_token will keep track of the previous token for syntax purposes
	// Initializing prev_token here
	token_t prev_token = checked_malloc(sizeof(struct token));
	prev_token->type = NEWLINE; 		// Makes it easy for the first real line
	prev_token->string = NULL;
	
	// Start the character stream
	char_stream_init(cst);

	char ch;
	bool in_andorpipe_command = false;
	int paren_count = 0;
	int line_num = 1; 				// For error reporting
	
	// Loop through all the characters, tokenizing them and checking syntax
	while ((ch = char_stream_current(cst)) != EOF)
	{
		if (ch == '#') 			// COMMENT
		{
			if(cst->last != '\0' && cst->last != '\n' &&
			   cst->last != '\t' && cst->last != ' ')
			{
				error(1,0,"Comment Error");
			}
			while (ch != '\n') 	// until you find a new line...
			{
				ch = char_stream_read(cst); // iterate through characters
			}
		}
		else if (ch == '\n') 		// NEWLINE
		{
			line_num++;
			switch (prev_token->type) 					// check if it's valid syntax
			{
				case IN:
				case OUT:
					error (1, 0, "%d: Invalid newline after previous token\n",line_num);
					break;
				case AND:
				case OR:
				case PIPE:
				case NEWLINE:
					ch = char_stream_read(cst);				// keep going...
					break;
				default:
				{
					// Create the new token and add it to the token stream
					token_t new_token = checked_malloc(sizeof(struct token));
					new_token->type = NEWLINE;
					new_token->string = NULL;
					token_stream_add(stream, new_token);
					
					// set the prev_token for syntax-checking
					prev_token->type = NEWLINE;
					prev_token->string = NULL;
					ch = char_stream_read(cst);
				}
			}
		}
		else if (isspace(ch))			// BLANK SPACE (not \n)
		{
			ch = char_stream_read(cst);
		}
		else if (ch == ')')		// CLOSED PAREN
		{
			switch (prev_token->type)
			{
				case AND:
				case OR:
				case PIPE:
				case IN:
				case OUT:
				case OPEN_PAREN:
					error (1, 0, "%d: Invalid ')' after previous token\n", line_num);
					break;
				default:
				{
					// Create the new token and add it to the token stream
					token_t new_token = checked_malloc(sizeof(struct token));
					new_token->type = CLOSE_PAREN;
					new_token->string = NULL;
					token_stream_add(stream, new_token);
					
					// set the prev_token for syntax-checking
					prev_token->type = CLOSE_PAREN;
					prev_token->string = NULL;
					ch = char_stream_read(cst);
					
					paren_count--;
				}
			}
		}
		else if (ch == '(')		// OPEN PAREN
		{
			switch (prev_token->type)
			{
				case WORD:
				case IN:
				case OUT:
				case CLOSE_PAREN:
					error (1, 0, "%d: Invalid '(' after previous token\n", line_num);
					break;
				default:
				{
					// Create the new token and add it to the token stream
					token_t new_token = checked_malloc(sizeof(struct token));
					new_token->type = OPEN_PAREN;
					new_token->string = NULL;
					token_stream_add(stream, new_token);
					
					// set the prev_token for syntax-checking
					prev_token->type = OPEN_PAREN;
					prev_token->string = NULL;
					ch = char_stream_read(cst);
					
					paren_count++;
					in_andorpipe_command = false;
					// printf("%i: in_andorpipe_command set to FALSE\n", line_num);
				}
			}
		}
		else if (ch == '&')			// AND
		{
			ch = char_stream_read(cst); 					// Check to see if & or &&
			if (ch == '&')
			{
				switch (prev_token->type)
				{
					case WORD:
					case CLOSE_PAREN:
					{
						// Create the new token and add it to the token stream
						token_t new_token = checked_malloc(sizeof(struct token));
						new_token->type = AND;
						new_token->string = NULL;
						token_stream_add(stream, new_token);
					
						// set the prev_token for syntax-checking
						prev_token->type = AND;
						prev_token->string = NULL;
						ch = char_stream_read(cst);
						
						in_andorpipe_command = true;
						// printf("%i: in_andorpipe_command set to TRUE\n", line_num);
						
						break;
					}
					default:
						error (1, 0, "%d: Invalid '&&' after previous token\n", line_num);
				}
			}
			else
			{
				error (1, 0, "%d: Invalid token: & must be followed by &\n", line_num);
			}
		}
		else if (ch == '|')
		{
			ch = char_stream_read(cst);
        	switch (prev_token->type)
            {
            	case WORD:
            	case CLOSE_PAREN:
            		if (ch == '|')
                	{
                		// Create the new token and add it to the token stream
                  		token_t new_token = checked_malloc (sizeof (struct token));
                  		new_token->type = OR;
                  		new_token->string = NULL;
                  		token_stream_add(stream, new_token);
                  		
                  		// set the prev_token for syntax-checking
						prev_token->type = OR;
                  		prev_token->string = NULL;
                  		ch = char_stream_read(cst);
						
						in_andorpipe_command = true;
						// printf("%i: in_andorpipe_command set to TRUE\n", line_num);
						
                	}
             		else
                	{
                		// Create the new token and add it to the token stream
                  		token_t new_token = checked_malloc (sizeof(struct token));
                  		new_token->type = PIPE;
                  		new_token->string = NULL;
                  		
                  		// set the prev_token for syntax-checking
                  		token_stream_add(stream, new_token);
                  		prev_token->type = PIPE;
                  		prev_token->string = NULL;
						
						in_andorpipe_command = true;
						// printf("%i: in_andorpipe_command set to TRUE\n", line_num);
                	}
              		break;
				default:
            	error (1, 0, "%d: Invalid '|' or '||' after previous token\n", line_num);
            }
		}
		else if (ch == ';')
		{
			switch (prev_token->type)
			{
				case WORD:
				case CLOSE_PAREN:
				{
					// Create the new token and add it to the token stream
              		token_t new_token = checked_malloc (sizeof (struct token));
            		new_token->type = SEQ;
             		new_token->string = NULL;
             		token_stream_add(stream, new_token);
                 		
             		// set the prev_token for syntax-checking
					prev_token->type = SEQ;
             		prev_token->string = NULL;
            		ch = char_stream_read(cst);
             		break;
				}
				default:
					error (1, 0, "%d: Invalid ';' after previous token\n", line_num);                  		
			}
		}
		else if (ch == '<')
		{
			switch (prev_token->type)
			{
				case WORD:
				case CLOSE_PAREN:
				{
					// Create the new token and add it to the token stream
              		token_t new_token = checked_malloc (sizeof (struct token));
            		new_token->type = IN;
             		new_token->string = NULL;
             		token_stream_add(stream, new_token);
                 		
             		// set the prev_token for syntax-checking
					prev_token->type = IN;
             		prev_token->string = NULL;
            		ch = char_stream_read(cst);
             		break;
				}
				default:
					error (1, 0, "%d: Invalid '<' after previous token\n", line_num);
			}
		}
		else if (ch == '>')
		{
			switch (prev_token->type)
			{
				case WORD:
				case CLOSE_PAREN:
				{
					// Create the new token and add it to the token stream
              		token_t new_token = checked_malloc (sizeof (struct token));
            		new_token->type = OUT;
             		new_token->string = NULL;
             		token_stream_add(stream, new_token);
                 		
             		// set the prev_token for syntax-checking
					prev_token->type = OUT;
             		prev_token->string = NULL;
            		ch = char_stream_read(cst);
             		break;
             	}
             	default:
             		error (1, 0, "%d: Invalid '>' after previous token\n", line_num);
			}
		}
		else
		{
			if (prev_token->type == CLOSE_PAREN)
            	error (1, 0, "%d: Invalid string after ')'\n", line_num);
            if (!is_regular_char(ch))
			{
            	error (1, 0, "%d: Invalid character '%c'\n", line_num, ch);
            }
            size_t count = 0;
            size_t max = 8;
            
            token_t new_token = checked_malloc(sizeof(struct token));
            new_token->type = WORD;
            new_token->string = checked_malloc(max * sizeof(char));
            
            while (is_regular_char(char_stream_current(cst)))
            {
            	if (count + 1 >= max)
            		checked_grow_alloc(new_token->string, &max);
            	new_token->string[count++] = char_stream_current(cst);
            	ch = char_stream_read(cst);
            }
            
            new_token->string[count] = '\0'; // end the string
            token_stream_add(stream, new_token);
            prev_token->type = WORD;
            prev_token->string = NULL;
			
			in_andorpipe_command = false;
			// printf("%i: in_andorpipe_command set to FALSE\n", line_num);
		}
		
	}
	if (in_andorpipe_command)
		error (1, 0, "EOF: Reached end of file without correct number of commands (and, or, pipe)\n");
	if (paren_count)
		error (1, 0, "EOF: Incorrect number of parentheses\n");
	//print_tokens(stream);
	return stream;
}

void
print_tokens(token_stream_t t)
{
	token_node_t tok = t->head;
	if(!t || !t->head || !t->head->token)
		return;
	
	while(tok && tok->token)
	{
		switch (tok->token->type)
		{
		case AND:
			printf("$$\n");
			break;
		case OR:
			printf("||\n");
			break;
		case SEQ:
			printf(";\n");
			break;
		case PIPE:
			printf("|\n");
			break;
		case WORD:
			printf("WORD: %s\n", tok->token->string);
			break;
		case IN:
			printf("<\n");
			break;
		case OUT:
			printf(">\n");
			break;
		case OPEN_PAREN:
			printf("(\n");
			break;
		case CLOSE_PAREN:
			printf(")\n");
			break;
		case NEWLINE:
			printf("\\n\n");
			break;
		}
		tok = tok->next;
	}
}


////////////////////////////////////////////////////////////
// PARSER
////////////////////////////////////////////////////////////

void
command_init(command_t c)
{
	c->status = 0;
	c->input = 0;
	c->output = 0;
}

int
precedence (token_type_t type)
{
	//int min = 0;
	switch (type)
	{
		case SEQUENCE_COMMAND:
			return 0;
		case AND_COMMAND:
		case OR_COMMAND:
			return 1;
		case PIPE_COMMAND:
			return 2;
		default:
			return -1;
	}
}

int
precedence_command (command_t t)
{
	int min = 0;
	if (t == NULL)
		return -1;
	switch (t->type)
	{
		case SEQUENCE_COMMAND:
			return min;
		case AND_COMMAND:
		case OR_COMMAND: 
			return min + 1;
		case PIPE_COMMAND:
			return min + 2;
		case SIMPLE_COMMAND: // accounts for redirects...
			return min + 3;
		case SUBSHELL_COMMAND:
			return min + 4;
		default:
			return -1;	
	}
}

void
print_command_type(command_t c)
{
	char *type = "\0";
	switch (c->type)
	{
		case AND_COMMAND:
			type = "AND";
			break;
		case OR_COMMAND:
			type = "OR";
			break;
		case PIPE_COMMAND:
			type = "PIPE";
			break;
		case SIMPLE_COMMAND:
			type = "SIMPLE";
			break;
		case SUBSHELL_COMMAND:
			type = "SUBSHELL";
			break;
		case SEQUENCE_COMMAND:
			type = "SEQUENCE";
			break;
		default:
			type = "ERROR";
	}
	printf("Command's type = '%s'\n", type);
}

void
parse_file_redirection (token_stream_t input, command_t command)
{
	token_t next_token;
	
	next_token = token_stream_current(input);
	if (next_token && next_token->type == IN)
	{
		token_stream_free_head(input);
		next_token = token_stream_read(input);
		command->input = next_token->string;
		free(next_token);
		next_token = token_stream_current(input);
	}
	if (next_token && next_token->type == OUT)
	{
		token_stream_free_head(input);
		next_token = token_stream_read(input);
		command->output = next_token->string;
		free(next_token);
	}
}

void
command_stream_write (command_stream_t stream, command_t command)
{
	command_node_t node = checked_malloc(sizeof(struct command_node));
	node->com= command;
	node->next = NULL;
	if (!stream->head)
		stream->head = node;
	else
		stream->tail->next = node;
	stream->tail = node;
}

command_t
parse_token_to_command(token_stream_t tst)
{
	token_t next_token = token_stream_current(tst);
	if (!next_token)
		return NULL;
		
	command_t head;
	command_t cur = NULL;
	command_t prev;
	
	while (next_token)
	{
		char *current_token_char = next_token->string;
		int current_token_type = next_token->type;
	
		int num_words = 1;
		int phrase_index = 0;
		int status = -1;
		char **phrase = checked_malloc((num_words + 1) * sizeof(char*));
		char *input = NULL, *output= NULL;
		
		command_t temp = checked_malloc(sizeof(struct command));
		command_t temp_sub;
		
		
		phrase[phrase_index + 1] = NULL;
		switch (next_token->type)
		{
			case WORD:
			{
				phrase[phrase_index] = next_token->string;
				phrase_index++;
				
				token_stream_read(tst);
				free(next_token);
				next_token = token_stream_current(tst);
				
				while (next_token && next_token->type == WORD)
				{
					num_words++;
					phrase = checked_realloc(phrase, (num_words + 1) * sizeof(char*));
					phrase[phrase_index + 1] = NULL;
					
					phrase[phrase_index] = next_token->string;
					phrase_index++;
					
					token_stream_read(tst);
					free(next_token);
					next_token = token_stream_current(tst);
				}
				
				if (next_token && next_token->type == IN)
				{
					token_stream_read(tst);
					free_token(next_token);
					next_token = token_stream_current(tst);
					
					input = next_token->string;
					
					token_stream_read(tst);
					free(next_token);
					next_token = token_stream_current(tst);
				}
				
				if (next_token && next_token->type == OUT)
				{
					token_stream_read(tst);
					free_token(next_token);
					next_token = token_stream_current(tst);
					
					output = next_token->string;
					
					token_stream_read(tst);
					free(next_token);
					next_token = token_stream_current(tst);
				}
				
				temp->type = SIMPLE_COMMAND;
				temp->status = status;
				temp->input = input;
				temp->output = output;
				temp->u.word = phrase;
				break;
			}
			case OPEN_PAREN:
			{
				token_stream_read(tst);
				free_token(next_token);
				next_token = token_stream_current(tst);
				
				temp_sub = parse_token_to_command(tst);
				next_token = token_stream_current(tst);
				
				current_token_char = next_token->string;
				current_token_type = next_token->type;
				
				if (next_token && next_token->type == IN)
				{
					token_stream_read(tst);
					free_token(next_token);
					next_token = token_stream_current(tst);
					
					input = next_token->string;
					
					token_stream_read(tst);
					free(next_token);
					next_token = token_stream_current(tst);
				}
				
				if (next_token && next_token->type == OUT)
				{
					token_stream_read(tst);
					free_token(next_token);
					next_token = token_stream_current(tst);
					
					output = next_token->string;
					
					token_stream_read(tst);
					free(next_token);
					next_token = token_stream_current(tst);
				}
				
				temp->type = SUBSHELL_COMMAND;
				temp->status = status;
				temp->input = input;
				temp->output = output;
				temp->u.subshell_command = temp_sub;
				break;
			}
			case CLOSE_PAREN:
			{
				token_stream_read(tst);
				free_token(next_token);
				next_token = token_stream_current(tst);
				
				return head;
			}
			case PIPE:
			{
				temp->type = PIPE_COMMAND;
				temp->status = status;
				
				token_stream_read(tst);
				free_token(next_token);
				next_token = token_stream_current(tst);
				break;
			}
			case OR:
			{
				temp->type = OR_COMMAND;
				temp->status = status;
				
				token_stream_read(tst);
				free_token(next_token);
				next_token = token_stream_current(tst);
				break;
			}
			case AND:
			{
				temp->type = AND_COMMAND;
				temp->status = status;
				
				token_stream_read(tst);
				free_token(next_token);
				next_token = token_stream_current(tst);
				break;
			}
			case SEQ:
			{
				temp->type = SEQUENCE_COMMAND;
				temp->status = status;
				
				token_stream_read(tst);
				free_token(next_token);
				next_token = token_stream_current(tst);
				
				if (!next_token || next_token->type == NEWLINE || next_token->type == CLOSE_PAREN)
				{
					token_stream_read(tst);
					free_token(next_token);
					next_token = token_stream_current(tst);
					return head;
				}
				
				break;
			}
			case NEWLINE:
			{
				token_stream_read(tst);
				free_token(next_token);
				next_token = token_stream_current(tst);
				return head;
				break;
			}
		}
		
		if (!cur)
		{
			cur = temp;
			head = cur;
		}
		else if (precedence_command(temp) <= precedence_command(cur))
		{
			if (head != cur)
				cur = head;
			prev = cur;
			cur = temp;
			head = cur;
			cur->u.command[0] = prev;
		}
		else if (precedence_command(temp) > precedence_command(cur))
		{
			if (!cur->u.command[1])
				cur->u.command[1] = temp;
			else
			{
				temp->u.command[0] = cur->u.command[1];
				cur->u.command[1] = temp;
				prev = cur;
				cur = temp;
			}
		}
	}
	return head;
}

command_stream_t
token_to_command_stream (token_stream_t input)
{
	command_stream_t output = checked_malloc(sizeof(struct command_stream));

	//command_t next = parse_sequence_command(input);
	command_t next = parse_token_to_command(input);
	while(next) // changed this a little
	{
		command_stream_write(output, next);
		//next = parse_sequence_command(input);
		next = parse_token_to_command(input);
		
		
	}
	return output;
}

command_stream_t
make_command_stream (int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{ 
  char_stream_t c_stream = checked_malloc(sizeof(struct char_stream));
  c_stream->get_next_byte = get_next_byte;
  c_stream->get_next_byte_argument = get_next_byte_argument;
  
  token_stream_t t_stream = char_stream_to_token_stream(c_stream);
  
  // print_tokens(t_stream);
  
  command_stream_t com_stream = token_to_command_stream(t_stream);
  
  return com_stream;
}

command_t
read_command_stream (command_stream_t s)
{
	command_t temp = NULL;
	if (s->head)
	{
		command_node_t old_head = s->head;
		temp = old_head->com;
		s->head = s->head->next;
		free(old_head);
	}
	return temp;
}
