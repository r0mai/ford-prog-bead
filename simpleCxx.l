%option noyywrap c++ yylineno

%{
#include <iostream>
%}

DIGIT [0-9]
WS [ \t\n]
VARIABLE [a-zA-z][a-zA-Z0-9_]*
COMMENT "//".*$

%%

{COMMENT}	//do nothing
{DIGIT}+	std::cout << "szam: " << yytext << std::endl;
"int"		std::cout << "kulcsszo: int" << std::endl;
"main"		std::cout << "kulcsszo: main" << std::endl;
"unsigned"	std::cout << "kulcsszo: unsigned" << std::endl;
"bool"		std::cout << "kulcsszo: bool" << std::endl;
"true"		std::cout << "kulcsszo: true" << std::endl;
"false"		std::cout << "kulcsszo: false" << std::endl;
"if"		std::cout << "kulcsszo: if" << std::endl;
"else"		std::cout << "kulcsszo: else" << std::endl;
"while"		std::cout << "kulcsszo: while" << std::endl;
"cout"		std::cout << "kulcsszo: cout" << std::endl;
"cin"		std::cout << "kulcsszo: cin" << std::endl;
"&&"		std::cout << "operator: &&" << std::endl;
"||"		std::cout << "operator: ||" << std::endl;
"=="		std::cout << "operator: ==" << std::endl;
"<<"		std::cout << "operator: <<" << std::endl;
">>"		std::cout << "operator: >>" << std::endl;
"<"			std::cout << "operator: <" << std::endl;
">"			std::cout << "operator: >" << std::endl;
"+"			std::cout << "operator: +" << std::endl;
"-"			std::cout << "operator: -" << std::endl;
"*"			std::cout << "operator: *" << std::endl;
"/"			std::cout << "operator: /" << std::endl;
"%"			std::cout << "operator: %" << std::endl;
"("			std::cout << "operator: (" << std::endl;
")"			std::cout << "operator: )" << std::endl;
"{"			std::cout << "operator: {" << std::endl;
"}"			std::cout << "operator: }" << std::endl;
"="			std::cout << "operator: =" << std::endl;
"!"			std::cout << "operator: !" << std::endl;
";"			std::cout << "operator: ;" << std::endl;
{VARIABLE}	std::cout << "valtozo: " << yytext << std::endl;

{WS}+       // feher szokozok: semmi teendo

.           {
                std::cerr << lineno() << ": Lexikalis hiba." << std::endl;
                exit(1);
            }

%%
