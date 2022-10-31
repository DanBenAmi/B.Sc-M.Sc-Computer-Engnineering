/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Worker.h"
#pragma once

class Teacher : virtual public Worker
{
private:
	vector<string> courses;
	int num_of_courses;
public:
	Teacher() { num_of_courses = 0; }
	Teacher(string first_name, string last_name, int teaching_years,
		vector<string> courses, int num_of_courses): Worker(first_name,last_name,0, teaching_years), courses(courses), num_of_courses(num_of_courses){}
	virtual ~Teacher(){}
	vector<string> get_courses() const { return courses; }
	int get_num_of_courses() const { return num_of_courses; }
	void set_courses(const vector<string> courses) { Teacher::courses = courses; }
	void set_num_of_courses(const int num) { Teacher::num_of_courses = num; }
	virtual int get_salary();
	virtual bool is_outstanding();
	void print_courses();
	virtual void print_details();
};

