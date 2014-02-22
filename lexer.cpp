
#include <iostream>
#include <fstream>
#include <FlexLexer.h>

int main(int argc, char **argv) {
	std::ifstream in(argv[1]);
	yyFlexLexer fl(&in, &std::cout);
 	fl.yylex();
	return 0;
}
