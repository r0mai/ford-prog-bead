%baseclass-preinclude <iostream>
%lsp-needed

%token NUMBER
%token VARIABLE
%token KW_INT
%token KW_MAIN
%token KW_UNSIGNED
%token KW_BOOL
%token KW_TRUE
%token KW_FALSE
%token KW_IF
%token KW_ELSE
%token KW_WHILE
%token KW_COUT
%token KW_CIN
%token OP_RS
%token OP_LS
%token OP_OPEN_BRACE
%token OP_CLOSE_BRACE
%token OP_OPEN_PAREN
%token OP_CLOSE_PAREN
%token OP_AS
%token OP_NOT
%token OP_COLON

%left OP_AND OP_OR
%left OP_EQ
%left OP_LT OP_GT
%left OP_PLUS OP_MINUS
%left OP_TIMES OP_DIVIDE OP_MOD

%%

start: signature OP_OPEN_BRACE declarations body OP_CLOSE_BRACE { std::cout << "start -> signature OP_OPEN_PAREN declarations body OP_CLOSE_BRACE" << std::endl; }
	;

signature: KW_INT KW_MAIN OP_OPEN_PAREN OP_CLOSE_PAREN { std::cout << "signature -> KW_INT KW_MAIN OP_OPEN_PAREN OP_CLOSE_PAREN" << std::endl; }
	;

declarations: /*nothing*/ { std::cout << "declarations -> eps" << std::endl; }
	| declaration declarations { std::cout << "declarations -> declaration declarations" << std::endl; }
	;

declaration: type VARIABLE OP_COLON { std::cout << "declaration -> type VARIABLE OP_COLON" << std::endl; }
	;

type: KW_BOOL { std::cout << "type -> KW_BOOL" << std::endl; }
	| KW_UNSIGNED { std::cout << "type -> KW_UNSIGNED" << std::endl; }
	;

/*we need at least one statement in a body*/
body: statement statements { std::cout << "body -> statement statements" << std::endl; }
	;

statements: /*nothing*/ { std::cout << "statements -> eps" << std::endl; }
	| statement statements { std::cout << "statements -> statement statements" << std::endl; }
	;

statement: while_statement { std::cout << "statement -> while_statement" << std::endl; }
	| if_statement { std::cout << "statement -> if_statement" << std::endl; }
	| assignment { std::cout << "statement -> assignment" << std::endl; }
	| read_statement { std::cout << "statement -> read_statement" << std::endl; }
	| print_statement { std::cout << "statement -> print_statement" << std::endl; }
	;

while_statement:
	KW_WHILE OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE
   { std::cout << "while_statement -> KW_WHILE OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE" << std::endl; }
	;

if_statement:
	KW_IF OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE else_part
	{ std::cout << "if_statement -> KW_IF OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE else_part" << std::endl; }
	;

else_part: /*nothing*/ { std::cout << "else_part -> eps" << std::endl; }
	| KW_ELSE OP_OPEN_BRACE body OP_CLOSE_BRACE
	{ std::cout << "else_part -> KW_ELSE OP_OPEN_BRACE body OP_CLOSE_BRACE" << std::endl; }
	;

assignment: VARIABLE OP_AS expression OP_COLON { std::cout << "assignment -> VARIABLE OP_AS expression OP_COLON" << std::endl; }
	;

read_statement: KW_CIN OP_RS expression OP_COLON { std::cout << "read_statement -> KW_CIN OP_RS VARIABLE OP_COLON" << std::endl; }
	;

print_statement: KW_COUT OP_LS expression OP_COLON { std::cout << "print_statement -> KW_COUT OP_LS VARIABLE OP_COLON" << std::endl; }
	;

expression:
	  VARIABLE { std::cout << "expression -> VARIABLE" << std::endl; }
	| KW_TRUE { std::cout << "expression -> KW_TRUE" << std::endl; }
	| KW_FALSE { std::cout << "expression -> KW_FALSE" << std::endl; }
	| NUMBER { std::cout << "expression -> NUMBER" << std::endl; }
	| expression OP_AND expression { std::cout << "expression -> expression OP_AND expression" << std::endl; }
	| expression OP_OR expression { std::cout << "expression -> expression OP_OR expression" << std::endl; }
	| expression OP_EQ expression { std::cout << "expression -> expression OP_EQ expression" << std::endl; }
	| expression OP_LT expression { std::cout << "expression -> expression OP_LT expression" << std::endl; }
	| expression OP_GT expression { std::cout << "expression -> expression OP_GT expression" << std::endl; }
	| expression OP_PLUS expression { std::cout << "expression -> expression OP_PLUS expression" << std::endl; }
	| expression OP_MINUS expression { std::cout << "expression -> expression OP_MINUS expression" << std::endl; }
	| expression OP_TIMES expression { std::cout << "expression -> expression OP_TIMES expression" << std::endl; }
	| expression OP_DIVIDE expression { std::cout << "expression -> expression OP_DIVIDE expression" << std::endl; }
	| expression OP_MOD expression { std::cout << "expression -> expression OP_MOD expression" << std::endl; }
	| OP_NOT expression { std::cout << "expression -> OP_NOT expression" << std::endl; }
	;



