/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include <iostream>
#include <vector>
using namespace std;
#include "Person.h"
#pragma once
class Pupil : public Person
{
private:
	vector<int> grades;
	char layer;
	int class_num;
public:
	Pupil() { layer = '\0'; class_num = 0; }
	Pupil(string first_name, string last_name,vector<int> grades, char layer, int class_num);
	~Pupil(){}
	vector<int> get_grades() { return grades; }
	char get_layer() { return layer; }
	int get_class_num() { return class_num; }
	void set_grades(vector<int> grades) { Pupil::grades = grades; }
	void set_layer(char layer) { Pupil::layer = layer; }
	void set_class_num(int class_num) { Pupil::class_num = class_num; }
	int average();
	bool is_outstanding();
	void print_details();










};

