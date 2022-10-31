/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Worker.h"
#include "Teacher.h"

int Teacher::get_salary() {
	int x = num_of_courses;
	int y = this->get_teaching_years();
	int basis = this->get_basis();
	return  basis * (1 + float(x) / 10) + 300 * y;
}

bool Teacher::is_outstanding() {
	if (num_of_courses >= 5) return true;
	return false;
}

void Teacher::print_courses() {
	cout << "Courses: ";
	for (int i = 0; i < courses.size() - 1; i++)
		cout << courses[i] << ", ";
	cout << courses[courses.size() - 1] << endl;
}

void Teacher::print_details() {
	Worker::print_details();
	cout << "Number of courses: " << this->num_of_courses << endl;
	this->print_courses();
	cout << "Salary: " << this->get_salary() << endl;
}



