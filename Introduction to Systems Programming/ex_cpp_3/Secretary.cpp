/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Secretary.h"

int Secretary::get_salary() {
	return Worker::get_basis() + num_of_childs * 200;
}
bool Secretary::is_outstanding() {
	if (Worker::get_managerial_years() > 10) return true;
	return false;
}

void Secretary::print_details() {
	Worker::print_details();
	cout << "Office number: " << this->get_office_num() << endl;
	cout << "Salary: " << this->get_salary() << endl;
	cout << "Outstanding: ";
	if (this->is_outstanding()) cout << "yes";
	else cout << "no";
	cout << endl;
}


