/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Pupil.h"

Pupil::Pupil(string first_name, string last_name,
	vector<int> grades, char layer, int class_num) : Person(first_name,last_name) {
	this->grades = grades;
	this->layer = layer;
	this->class_num = class_num;
}

int Pupil::average() {
	if (grades.empty())return 0;
	int sum = 0;
	for (int i = 0; i < grades.size(); i++) {
		sum += grades[i];
	}
	return sum / grades.size();
}

bool Pupil::is_outstanding() {
	if (this->average() <= 85) return false;
	for (int i = 0; i < grades.size(); i++)
		if (grades[i] < 65) return false;
	return true;
}

void Pupil::print_details() {
	Person::print_details();
	cout << "Grades: ";
	if (grades.empty()) cout << "The student have no grades.\n";
	else {
		for (int i = 0; i < grades.size() - 1; i++)
			cout << grades[i] << ", ";
		cout << grades[grades.size() - 1] << endl;
	}
	cout << "Avarge: " << this->average() << endl;
	cout << "Outstanding: ";
	is_outstanding() ? cout << "Yes" : cout << "No";
	cout << endl;
}











