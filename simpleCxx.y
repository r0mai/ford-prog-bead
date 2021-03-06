%baseclass-preinclude "semantics.h"
%lsp-needed

%token <text> NUMBER
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
%token OP_COLON

%left OP_AND OP_OR
%left OP_EQ
%left OP_LT OP_GT
%left OP_NOT
%left OP_PLUS OP_MINUS
%left OP_TIMES OP_DIVIDE OP_MOD

%type <code> body
%type <code> if_statement
%type <code> else_part
%type <code> print_statement
%type <code> read_statement
%type <code> while_statement
%type <code> assignment
%type <code> statement
%type <code> statements
%type <code> declaration
%type <code> declarations
%type <expressionData> expression

%union
{
	std::string *text;
	ExpressionData *expressionData;
	std::string *code;
}

%%

start: signature OP_OPEN_BRACE declarations body OP_CLOSE_BRACE
		{
			std::cout <<
            "extern ki_egesz\n"
            "extern ki_logikai\n"
            "extern be_egesz\n"
            "extern be_logikai\n"
            "global main\n"
			"section .bss\n"
			<< *$3 <<
            "section .text\n"
            "main:\n"
			<< *$4 <<
            "ret\n";
			delete $3;
			delete $4;
		}
	;

signature: KW_INT KW_MAIN OP_OPEN_PAREN OP_CLOSE_PAREN
	;

declarations: /*nothing*/ { $$ = new std::string(""); }
	| declaration declarations { $$ = new std::string(*$1 + *$2 + "\n"); delete $1; delete $2; }
	;

declaration: KW_BOOL VARIABLE OP_COLON
		{
			declareVariable(*$2, BOOL, d_loc__.first_line);
			$$ = new std::string(*$2 + " : resb 1\n");
			delete $2;
		}
	| KW_UNSIGNED VARIABLE OP_COLON
		{
			declareVariable(*$2, UNSIGNED, d_loc__.first_line);
			$$ = new std::string(*$2 + " : resb 4\n");
			delete $2;
		}
	;

/*we need at least one statement in a body*/
body: statement statements { $$ = new std::string(*$1 + *$2 + "\n"); delete $1; delete $2; }
	;

statements: /*nothing*/ { $$ = new std::string(""); }
	| statement statements { $$ = new std::string(*$1 + *$2 + "\n"); delete $1; delete $2; }
	;

statement: while_statement { $$ = new std::string(*$1); delete $1; }
	| if_statement { $$ = new std::string(*$1); delete $1; }
	| assignment { $$ = new std::string(*$1); delete $1; }
	| read_statement { $$ = new std::string(*$1); delete $1; }
	| print_statement { $$ = new std::string(*$1); delete $1; }
	;

while_statement:
	KW_WHILE OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE
		{
			if ( $3->type != BOOL ) {
				error("Non-bool expression in while");
			}
			std::string flag = getNextFlag();
			std::string endFlag = getNextFlag();
			$$ = new std::string();
			*$$ += flag + ":\n";
			*$$ += $3->code;
			*$$ += "pop eax\n";
			*$$ += "cmp eax, 0\n";
			*$$ += "je " + endFlag + "\n";
			*$$ += *$6;
			*$$ += "jmp " + flag + "\n";
			*$$ += endFlag + ":\n";
			delete $3; delete $6;
		}
	;

if_statement:
	KW_IF OP_OPEN_PAREN expression OP_CLOSE_PAREN OP_OPEN_BRACE body OP_CLOSE_BRACE else_part
		{
			if ( $3->type != BOOL ) {
				error("Non-bool expression in if");
			}
			std::string endFlag = getNextFlag();
			std::string elseEndFlag = getNextFlag();
			$$ = new std::string();
			*$$ += $3->code;
			*$$ += "pop eax\n";
			*$$ += "cmp eax, 0\n";
			*$$ += "je " + endFlag + "\n";
			*$$ += *$6;
			*$$ += "jmp " + elseEndFlag + "\n";
			*$$ += endFlag + ":\n";
			*$$ += *$8;
			*$$ += elseEndFlag + ":\n";
			delete $3; delete $6; delete $8;
		}
	;

else_part: { $$ = new std::string(""); }
	| KW_ELSE OP_OPEN_BRACE body OP_CLOSE_BRACE
	{
		$$ = new std::string(*$3);
		delete $3;
	}
	;

assignment: VARIABLE OP_AS expression OP_COLON
		{
			if (symbolTable[*$1].type != $3->type) {
				error("Type error in assignment");
			}
			$$ = new std::string($3->code);
			if (symbolTable[*$1].type == BOOL) {
				*$$ += "pop eax\n";
				*$$ += "mov byte [" + *$1 + "], al\n";
			} else {
				*$$ += "pop dword [" + *$1 + "]\n";
			}
			delete $3;
		}
	;

read_statement: KW_CIN OP_RS VARIABLE OP_COLON
		{
			if (symbolTable[*$3].type == BOOL) {
				$$ = new std::string("call be_logikai\n");
				*$$ += "mov eax, 0\n";
				*$$ += "mov [" + *$3 + "], al\n";
			} else {
				$$ = new std::string("call be_egesz\n");
				*$$ += "mov [" + *$3 + "], eax\n";
			}
			delete $3;
		}
	;

print_statement: KW_COUT OP_LS expression OP_COLON
		{
			$$ = new std::string($3->code + "\n");
				if ($3->type == BOOL) {
					*$$ += "call ki_logikai\n";
				} else {
					*$$ += "call ki_egesz\n";
				}
			*$$ += "add esp, 4\n";
			delete $3;
		}
	;

expression:
	VARIABLE {
		$$ = new ExpressionData("", symbolTable[*$1].type);
		if (symbolTable[*$1].type == BOOL) {
			$$->code += "mov eax, 0\n";
			$$->code += "mov al, byte[" + *$1 + "]\n";
			$$->code += "push eax\n";
		} else {
			$$->code += "push dword [" + *$1 + "]\n";
		}
		delete $1;
	}
	| KW_TRUE {
		$$ = new ExpressionData("", BOOL);
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 1\n";
		$$->code += "push eax\n";
	}
	| KW_FALSE {
		$$ = new ExpressionData("", BOOL);
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 0\n";
		$$->code += "push eax\n";
	}
	| NUMBER {
		$$ = new ExpressionData("", UNSIGNED);
		$$->code += "push dword " + *$1 + "\n";
		delete $1;
	}
	| expression OP_AND expression {
		checkBoolBoolOperator($1->type, $3->type);
		$$ = new ExpressionData("", BOOL);
		$$->code += $1->code + $3->code;
		$$->code += "pop edx\n";
		$$->code += "pop eax\n";
		$$->code += "and eax, edx\n";
		$$->code += "push eax\n";
		delete $1; delete $3;
	}
	| expression OP_OR expression {
		checkBoolBoolOperator($1->type, $3->type);
		$$ = new ExpressionData("", BOOL);
		$$->code += $1->code + $3->code;
		$$->code += "pop edx\n";
		$$->code += "pop eax\n";
		$$->code += "or eax, edx\n";
		$$->code += "push eax\n";
		delete $1; delete $3;
	}
	| expression OP_EQ expression {
		checkBoolUnsignedOperator($1->type, $3->type);
		std::string flag = getNextFlag();
		std::string endFlag = getNextFlag();
		$$ = new ExpressionData("", BOOL);
		$$->code += $1->code + $3->code;
		$$->code += "pop edx\n";
		$$->code += "pop eax\n";
		$$->code += "cmp eax, edx\n";
		$$->code += "je " + flag + "\n";
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 0\n";
		$$->code += "push eax\n";
		$$->code += "jmp " + endFlag + "\n";
		$$->code += flag + ":\n";
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 1\n";
		$$->code += "push eax\n";
		$$->code += endFlag + ":\n";
		delete $1; delete $3;
	}
	| expression OP_LT expression {
		checkUnsignedUnsignedOperator($1->type, $3->type);
		std::string flag = getNextFlag();
		std::string endFlag = getNextFlag();
		$$ = new ExpressionData("", BOOL);
		$$ = new ExpressionData("", BOOL);
		$$->code += $1->code + $3->code;
		$$->code += "pop edx\n";
		$$->code += "pop eax\n";
		$$->code += "cmp eax, edx\n";
		$$->code += "jb " + flag + "\n";
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 0\n";
		$$->code += "push eax\n";
		$$->code += "jmp " + endFlag + "\n";
		$$->code += flag + ":\n";
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 1\n";
		$$->code += "push eax\n";
		$$->code += endFlag + ":\n";
		delete $1; delete $3;
	}
	| expression OP_GT expression {
		checkUnsignedUnsignedOperator($1->type, $3->type);
		std::string flag = getNextFlag();
		std::string endFlag = getNextFlag();
		$$ = new ExpressionData("", BOOL);
		$$ = new ExpressionData("", BOOL);
		$$->code += $1->code + $3->code;
		$$->code += "pop edx\n";
		$$->code += "pop eax\n";
		$$->code += "cmp eax, edx\n";
		$$->code += "ja " + flag + "\n";
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 0\n";
		$$->code += "push eax\n";
		$$->code += "jmp " + endFlag + "\n";
		$$->code += flag + ":\n";
		$$->code += "mov eax, 0\n";
		$$->code += "mov al, 1\n";
		$$->code += "push eax\n";
		$$->code += endFlag + ":\n";
		delete $1; delete $3;
	}
	| expression OP_PLUS expression {
		checkUnsignedUnsignedOperator($1->type, $3->type);
		$$ = new ExpressionData("", UNSIGNED);
		$$->code += $1->code + $3->code;
		$$->code += "pop edx\n";
		$$->code += "pop eax\n";
		$$->code += "add eax, edx\n";
		$$->code += "push eax\n";
		delete $1; delete $3;
	}
	| expression OP_MINUS expression {
		checkUnsignedUnsignedOperator($1->type, $3->type);
		$$ = new ExpressionData("", UNSIGNED);
		$$->code += $1->code + $3->code;
		$$->code += "pop edx\n";
		$$->code += "pop eax\n";
		$$->code += "sub eax, edx\n";
		$$->code += "push eax\n";
		delete $1; delete $3;
	}
	| expression OP_TIMES expression {
		checkUnsignedUnsignedOperator($1->type, $3->type);
		$$ = new ExpressionData("", UNSIGNED);
		$$->code += $1->code + $3->code;
		$$->code += "pop ebx\n";
		$$->code += "pop eax\n";
		$$->code += "mul ebx\n";
		$$->code += "push eax\n";
		delete $1; delete $3;
	}
	| expression OP_DIVIDE expression {
		checkUnsignedUnsignedOperator($1->type, $3->type);
		$$ = new ExpressionData("", UNSIGNED);
		$$->code += $1->code + $3->code;
		$$->code += "pop ebx\n";
		$$->code += "pop eax\n";
		$$->code += "mov edx, 0\n";
		$$->code += "div ebx\n";
		$$->code += "push eax\n";
		delete $1; delete $3;
	}
	| expression OP_MOD expression {
		checkUnsignedUnsignedOperator($1->type, $3->type);
		$$ = new ExpressionData("", UNSIGNED);
		$$->code += $1->code + $3->code;
		$$->code += "pop ebx\n";
		$$->code += "pop eax\n";
		$$->code += "mov edx, 0\n";
		$$->code += "div ebx\n";
		$$->code += "push edx\n";
		delete $1; delete $3;
	}
	| OP_NOT expression {
		checkBoolOperator($2->type);
		std::string flag = getNextFlag();
		std::string endFlag = getNextFlag();
		$$ = new ExpressionData("", BOOL);
		$$->code += $2->code;
		$$->code += "pop eax\n";
		$$->code += "cmp eax, 0\n";
		$$->code += "sete al\n";
		$$->code += "push eax\n";
		delete $2;
	}
	;



