/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include <iostream>
#include <cstring>
using namespace std;
#include "Person.h"

Person::Person(string first_name, string last_name) {
	this->first_name =  first_name;
	this->last_name = last_name;
}

Person::~Person() {}

void Person::set_first_name(const string first_name) {
	this->first_name = first_name;
}

void Person::set_last_name(const string last_name) {
	this->last_name = last_name;
}

void Person::print_details() {
	cout << "First name: " << this->first_name << endl <<
		"Last name: " << this->last_name << endl;
}









