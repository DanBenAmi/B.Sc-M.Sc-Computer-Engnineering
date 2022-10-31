/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Tutor.h"
Tutor::Tutor(string first_name, string last_name, int teaching_years,
	vector<string> courses, int num_of_courses) : Worker(first_name, last_name, 0, teaching_years),
	Teacher(first_name, last_name, teaching_years, courses, num_of_courses){}

int Tutor::get_salary() {
	return Teacher::get_salary() + 1000;
}

bool Tutor::is_outstanding() {
	int counter = 0;
	for (int i = 0; i < this->my_class->get_num_of_pupils(); i++)
		if (my_class->get_pupil_by_index(i)->is_outstanding()) counter++;
	if (counter > my_class->get_num_of_pupils() / 2) return true;
	return false;
}

void Tutor::print_details() {
	Teacher::print_details();
	my_class->print_details();

}

