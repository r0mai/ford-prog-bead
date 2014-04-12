%baseclass-preinclude "semantics.h"
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

%type <type> expression

%union
{
	std::string *text;
	VariableData::Type *type;
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
				error((std::string("Variable ") + *$2 + " redeclared. Previous declaration: " + toString(symbolTable[*$2].row) + '\n').c_str());
			} else {
				symbolTable[*$2] = VariableData(d_loc__.first_line, VariableData::BOOL);
			}
		}
	| KW_UNSIGNED VARIABLE OP_COLON
		{
			if ( symbolTable.count(*$2) > 0 ) {
				error((std::string("Variable ") + *$2 + " redeclared. Previous declaration: " + toString(symbolTable[*$2].row) + '\n').c_str());
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
		{
			if ( *$3 != VariableData::BOOL ) {
				error("Non-bool expression in while");
			}
		}
	;

if_statement:
	KW_IF OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE else_part
		{
			if ( *$3 != VariableData::BOOL ) {
				error("Non-bool expression in if");
			}
		}
	;

else_part: /*nothing*/
	| KW_ELSE OP_OPEN_BRACE body OP_CLOSE_BRACE

	;

assignment: VARIABLE OP_AS expression OP_COLON
		{
			if ( symbolTable[*$1].type != *$3 ) {
				error("Type error in assignment");
			}
		}
	;

read_statement: KW_CIN OP_RS expression OP_COLON
	;

print_statement: KW_COUT OP_LS expression OP_COLON
	;

expression:
	  VARIABLE { $$ = new VariableData::Type(symbolTable[*$1].type); }
	| KW_TRUE { $$ = new VariableData::Type(VariableData::BOOL); }
	| KW_FALSE { $$ = new VariableData::Type(VariableData::BOOL); }
	| NUMBER { $$ = new VariableData::Type(VariableData::UNSIGNED); }
	| expression OP_AND expression { checkBoolBoolOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::BOOL); }
	| expression OP_OR expression { checkBoolBoolOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::BOOL); }
	| expression OP_EQ expression { checkBoolUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::BOOL); }
	| expression OP_LT expression { checkUnsignedUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::BOOL); }
	| expression OP_GT expression { checkUnsignedUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::BOOL); }
	| expression OP_PLUS expression { checkUnsignedUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::UNSIGNED); }
	| expression OP_MINUS expression { checkUnsignedUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::UNSIGNED); }
	| expression OP_TIMES expression { checkUnsignedUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::UNSIGNED); }
	| expression OP_DIVIDE expression { checkUnsignedUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::UNSIGNED); }
	| expression OP_MOD expression { checkUnsignedUnsignedOperator(*$1, *$3); $$ = new VariableData::Type(VariableData::UNSIGNED); }
	| OP_NOT expression { checkBoolOperator(*$2); $$ = new VariableData::Type(VariableData::BOOL); }
	;



