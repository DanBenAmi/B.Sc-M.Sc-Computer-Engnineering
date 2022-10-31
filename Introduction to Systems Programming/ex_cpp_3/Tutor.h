/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Teacher.h"
#include "Class.h"
#pragma once
class Tutor: public Teacher
{
private:
	Class* my_class;
public:
	Tutor() {}
	Tutor(string first_name, string last_name, int teaching_years,
		vector<string> courses, int num_of_courses);
	virtual ~Tutor() {}
	Class* get_my_class() { return my_class; }
	void set_my_class(Class* new_class) { my_class = new_class; }
	virtual int get_salary();
	virtual bool is_outstanding();
	virtual void print_details();

};

