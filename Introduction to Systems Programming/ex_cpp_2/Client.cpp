/* Assignment C++: 2
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "String.h"
#include <iostream>
#include <string.h>
#include "Client.h"
using namespace std;

Client::Client(const String id, const String name, const char gender,			//constructor.
	const double age, const int num_hobbies, char** hobbies_lst) {
	this->id = id;
	this->name = name;
	this->gender = gender;
	this->age = age;
	this->num_hobbies = num_hobbies;
	this->hobbies_lst = new char* [num_hobbies];
	for (int i = 0; i < num_hobbies; i++) {									//allocating dynamic memory.
		this->hobbies_lst[i] = new char[strlen(hobbies_lst[i]) + 1];
		strcpy(this->hobbies_lst[i], hobbies_lst[i]);
	}	
}

Client::Client(const Client& obj) {											//copy constructor.
	this->id = obj.id ;
	this->name = obj.name;
	this->gender = obj.gender;
	this->age = obj.age;
	this->num_hobbies = obj.num_hobbies;
	this->hobbies_lst = new char* [obj.num_hobbies];
	for (int i = 0; i < obj.num_hobbies; i++) {
		this->hobbies_lst[i] = new char[strlen(obj.hobbies_lst[i]) + 1];
		strcpy(this->hobbies_lst[i], obj.hobbies_lst[i]);
	}	
}

Client::~Client() {
	for (int i = 0; i < num_hobbies; i++)
		delete this->hobbies_lst[i];									//freeing memory
	delete this->hobbies_lst;
}

Client &Client:: operator=(const Client obj) {
	this->id = obj.id;
	this->name = obj.name;
	this->gender = obj.gender;
	this->age = obj.age;
	this->num_hobbies = obj.num_hobbies;
	this->hobbies_lst = new char* [obj.num_hobbies];
	for (int i = 0; i < obj.num_hobbies; i++) {
		this->hobbies_lst[i] = new char[strlen(obj.hobbies_lst[i]) + 1];
		strcpy(this->hobbies_lst[i], obj.hobbies_lst[i]);
	}
	return *this;
}

bool Client::operator==(const Client obj2) {
	if (this->gender == obj2.gender) return false;
	double diff = abs(this->age - obj2.age);					//checking age difference
	if (diff > 5) return false;
	for (int i = 0; i < this->num_hobbies; i++) {				//checking if they have 1 hobby in commant.
		for (int j = 0; j < obj2.num_hobbies; j++) {
			if (strlen(this->hobbies_lst[i]) != strlen(obj2.hobbies_lst[j])) continue;
			int p = 0;
			while (this->hobbies_lst[i][p] == obj2.hobbies_lst[j][p]) {
				if ( p == strlen(this->hobbies_lst[i])) return true;
				p++;
			}
		}
	}
	return false;
}