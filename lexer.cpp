
#include <iostream>
#include <fstream>
#include <string>
#include <FlexLexer.h>
#include <cstdlib>

int main(int argc, char **argv) {
    ifstream in(argv[1]);
    yyFlexLexer fl(&in, &cout);
    fl.yylex();
    return 0;
}
