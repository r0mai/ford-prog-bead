%option noyywrap c++ yylineno

%{
#include <iostream>
#include "Parserbase.h"
%}

DIGIT [0-9]
WS [ \t\n]
VARIABLE [a-zA-z][a-zA-Z0-9_]*
COMMENT "//".*$

%%

{COMMENT}	//no-op
{DIGIT}+	return Parser::NUMBER;
"int"		return Parser::KW_INT;
"main"		return Parser::KW_MAIN;
"unsigned"	return Parser::KW_UNSIGNED;
"bool"		return Parser::KW_BOOL;
"true"		return Parser::KW_TRUE;
"false"		return Parser::KW_FALSE;
"if"		return Parser::KW_IF;
"else"		return Parser::KW_ELSE;
"while"		return Parser::KW_WHILE;
"cout"		return Parser::KW_COUT;
"cin"		return Parser::KW_CIN;
"&&"		return Parser::OP_AND;
"||"		return Parser::OP_OR;
"=="		return Parser::OP_EQ;
"<<"		return Parser::OP_LS;
">>"		return Parser::OP_RS;
"<"			return Parser::OP_LT;
">"			return Parser::OP_GT;
"+"			return Parser::OP_PLUS;
"-"			return Parser::OP_MINUS;
"*"			return Parser::OP_TIMES;
"/"			return Parser::OP_DIVIDE;
"%"			return Parser::OP_MOD;
"("			return Parser::OP_OPEN_PAREN;
")"			return Parser::OP_CLOSE_PAREN;
"{"			return Parser::OP_OPEN_BRACE;
"}"			return Parser::OP_CLOSE_BRACE;
"="			return Parser::OP_AS;
"!"			return Parser::OP_NOT;
";"			return Parser::OP_COLON;
{VARIABLE}	return Parser::VARIABLE;

{WS}+		//no-op

.			{
				std::cerr << lineno() << ": Lexikalis hiba." << std::endl;
				exit(1);
			}

%%
