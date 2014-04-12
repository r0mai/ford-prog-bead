// Generated by Bisonc++ V4.01.00 on Tue, 18 Mar 2014 19:13:24 +0100

#ifndef Parser_h_included
#define Parser_h_included

#include <iostream>
#include <sstream>

#include "semantics.h"
#include "Parserbase.h"
#include "FlexLexer.h"

#undef Parser
class Parser : public ParserBase {
public:
 	Parser(std::istream& in) : lexer(&in, &std::cerr) {}
	int parse();

private:

	typedef std::map<std::string, VariableData> SymbolTable;
	SymbolTable symbolTable;

	void checkBoolOperator(VariableData::Type type);
	void checkBoolBoolOperator(VariableData::Type type1, VariableData::Type type2);
	void checkBoolUnsignedOperator(VariableData::Type type1, VariableData::Type type2);
	void checkUnsignedUnsignedOperator(VariableData::Type type1, VariableData::Type type2);

	yyFlexLexer lexer;
	void error(char const *msg);	// called on (syntax) errors
	int lex();					  // returns the next token from the
									// lexical scanner.
	void print();				   // use, e.g., d_token, d_loc

	// support functions for parse():
	void executeAction(int ruleNr);
	void errorRecovery();
	int lookup(bool recovery);
	void nextToken();
	void print__();
};


#endif
