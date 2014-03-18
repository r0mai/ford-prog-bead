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
%token OP_AND
%token OP_OR
%token OP_EQ
%token OP_LS
%token OP_RS
%token OP_LT
%token OP_GT
%token OP_PLUS
%token OP_MINUS
%token OP_TIMES
%token OP_DIVIDE
%token OP_MOD
%token OP_OPEN_PAREN
%token OP_CLOSE_PAREN
%token OP_OPEN_BRACE
%token OP_CLOSE_BRACE
%token OP_AS
%token OP_NOT
%token OP_COLON

%%

start:	 OP_NOT
;
%%

