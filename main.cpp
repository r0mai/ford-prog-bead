
#include <iostream>
#include <fstream>
#include "Parser.h"

int main(int argc, char **argv) {
	std::ifstream in(argv[1]);

	Parser parser(in);
	parser.parse();

	return 0;
}
