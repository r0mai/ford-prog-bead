
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

struct VariableData {
	enum Type {
		UNSIGNED,
		BOOL
	};
	VariableData();
	VariableData(int row, Type type);
	int row;
	Type type;
};

#endif
