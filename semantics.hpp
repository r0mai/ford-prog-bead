
#ifndef SEMANTICS_HPP_
#define SEMANTICS_HPP_

#include <iostream>
#include <map>
#include <string>


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
