
#ifndef SEMANTICS_HPP_
#define SEMANTICS_HPP_

#include <iostream>
#include <map>
#include <string>
#include <sstream>

template<class T>
std::string toString(T t) {
	std::stringstream ss;
	ss << t;
	return ss.str();
}

enum VariableType {
	UNSIGNED,
	BOOL
};

struct VariableData {
	VariableData() {}
	VariableData(int row, VariableType type) : row(row), type(type) {}
	int row;
	VariableType type;
};

struct ExpressionData {
	ExpressionData() {}
	ExpressionData(const std::string& code, VariableType type) : code(code), type(type) {}
	std::string code;
	VariableType type;
};

#endif
