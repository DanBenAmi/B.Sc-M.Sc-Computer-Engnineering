/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#pragma once
#include "Class.h"

class Layer
{
private:
	char layer;
	vector<Class*> classes;
public:
	Layer(){}
	Layer(char layer, vector<Class*> classes) : layer(layer), classes(classes){}
	~Layer(){}
	Class get_class_by_idx(int idx);
	char get_layer() { return layer; }
	vector<Class*> get_classes() { return classes; }
	Class* set_class(int class_num);




};

