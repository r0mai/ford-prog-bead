%baseclass-preinclude "semantics.hpp"
%lsp-needed

%token NUMBER
%token <text> VARIABLE
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

%union
{
	std::string *text;
}

%%

start: signature OP_OPEN_BRACE declarations body OP_CLOSE_BRACE
	;

signature: KW_INT KW_MAIN OP_OPEN_PAREN OP_CLOSE_PAREN
	;

declarations: /*nothing*/
	| declaration declarations
	;

declaration: KW_BOOL VARIABLE OP_COLON
		{
			if ( symbolTable.count(*$2) > 0 ) {
				std::stringstream ss;
				ss << "Variable " << *$2 << " redeclared. Previous declaration: " << symbolTable[*$2].row << '\n';
				error(ss.str().c_str());
			} else {
				symbolTable[*$2] = VariableData(d_loc__.first_line, VariableData::BOOL);
			}
		}
	| KW_UNSIGNED VARIABLE OP_COLON
		{
			if ( symbolTable.count(*$2) > 0 ) {
				std::stringstream ss;
				ss << "Variable " << *$2 << " redeclared. Previous declaration: " << symbolTable[*$2].row << '\n';
				error(ss.str().c_str());
			} else {
				symbolTable[*$2] = VariableData(d_loc__.first_line, VariableData::UNSIGNED);
			}
		}
	;

/*we need at least one statement in a body*/
body: statement statements
	;

statements: /*nothing*/
	| statement statements
	;

statement: while_statement
	| if_statement
	| assignment
	| read_statement
	| print_statement
	;

while_statement:
	KW_WHILE OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE

	;

if_statement:
	KW_IF OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE else_part

	;

else_part: /*nothing*/
	| KW_ELSE OP_OPEN_BRACE body OP_CLOSE_BRACE

	;

assignment: VARIABLE OP_AS expression OP_COLON
	;

read_statement: KW_CIN OP_RS expression OP_COLON
	;

print_statement: KW_COUT OP_LS expression OP_COLON
	;

expression:
	  VARIABLE
	| KW_TRUE
	| KW_FALSE
	| NUMBER
	| expression OP_AND expression
	| expression OP_OR expression
	| expression OP_EQ expression
	| expression OP_LT expression
	| expression OP_GT expression
	| expression OP_PLUS expression
	| expression OP_MINUS expression
	| expression OP_TIMES expression
	| expression OP_DIVIDE expression
	| expression OP_MOD expression
	| OP_NOT expression
	;



