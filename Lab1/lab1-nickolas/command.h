// UCLA CS 111 Lab 1 command interface

#include <stdbool.h>
//#include "command-internals.h"

typedef struct command *command_t;
typedef struct command_stream *command_stream_t;

/* Create a command stream from GETBYTE and ARG.  A reader of
   the command stream will invoke GETBYTE (ARG) to get the next byte.
   GETBYTE will return the next input byte, or a negative number
   (setting errno) on failure.  */
command_stream_t make_command_stream (int (*getbyte) (void *), void *arg);

/* Read a command from STREAM; return it, or NULL on EOF.  If there is
   an error, report the error and exit instead of returning.  */
command_t read_command_stream (command_stream_t stream);

/* Print a command to stdout, for debugging.  */
void print_command (command_t);

/* Execute a command.  Use "time travel" if the flag is set.  */
void execute_command (command_t, bool);
void execute_command_stream (command_stream_t, bool);

/* Return the exit status of a command, which must have previously
   been executed.  Wait for the command, if it is not already finished.  */
int command_status (command_t);

////////////////////////////////////////////////////////////
// CHAR_STREAM
////////////////////////////////////////////////////////////
typedef struct char_stream
{
	char c, last;
	int (*get_next_byte) (void *);
	void *get_next_byte_argument;
} *char_stream_t;

// Returns the character currently looked at by a char_stream_t
char char_stream_current(char_stream_t cst);

// Initializes the stream by setting the initial char
void char_stream_init (char_stream_t cst);

// set the stream's char to the next character
char char_stream_read(char_stream_t cst);

////////////////////////////////////////////////////////////
// TOKENS
////////////////////////////////////////////////////////////
typedef enum token_type
{
	AND, OR, SEQ, PIPE, WORD, IN, OUT, OPEN_PAREN, CLOSE_PAREN, NEWLINE
//  &&   ||  ;    |     "  "  <    >   (           )            \n
} token_type_t;

typedef struct token
{
	enum token_type	type;
	char *string;
	struct token *next;
} *token_t;

typedef struct token_node
{
	token_t token;
	struct token_node *next;
} *token_node_t;

typedef struct token_stream
{
	token_node_t head, tail;
} *token_stream_t;

// Add a token to the token stream by making it the new tail
void token_stream_add (token_stream_t, token_t);

// Read a token from the stream and pop it from the head
token_t token_stream_read (token_stream_t);

// Read the head token without popping it
token_t token_stream_current (token_stream_t);

// Remove the head token and free it
void token_stream_free_head (token_stream_t);

// Free the memory of an arbitrary token
void free_token (token_t);


////////////////////////////////////////////////////////////
// LEXER
////////////////////////////////////////////////////////////

// Check to see if a character is regular (non-special)
bool is_regular_char(char);

//Convert a char_stream into a stream of tokens
token_stream_t char_stream_to_token_stream (char_stream_t);

// Print out the tokens for testing
void print_tokens(token_stream_t);
////////////////////////////////////////////////////////////
// PARSER
////////////////////////////////////////////////////////////

typedef struct command_node
{
	command_t com;
	struct command_node *next;
} *command_node_t;

int precedence(token_type_t);
command_t restructure(command_t);

//Parsing helper functions:

command_t parse_sequence_command(token_stream_t);
command_t parse_andor_command(token_stream_t);
command_t parse_pipe_command(token_stream_t);
command_t parse_subshell_command(token_stream_t);
command_t parse_simple_command(token_stream_t);
void parse_file_redirection(token_stream_t, command_t);

//NEED TO ADD STUFF HERE
