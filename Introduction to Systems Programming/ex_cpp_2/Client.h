/* Assignment C++: 2
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "String.h"
#include <iostream>
#include <string.h>
using namespace std;
#pragma once
class Client
{private:
	String id;
	String name;
	char gender;
	double age;
	int num_hobbies;
	char** hobbies_lst;
public:
	Client() { gender = '\0'; age = 0; num_hobbies = 0; hobbies_lst = NULL;}
	Client( const String id, const String name, const char gender,
		const double age, const int num_hobbies, char** hobbies_lst);
	Client(const Client& obj);
	~Client();
	Client& operator=(const Client obj);
	bool operator==(const Client obj2);
	String get_id() const { return id; }
	String get_name()const { return name; }
	char get_gender()const { return gender; }
	double get_age()const { return age; }
	int get_num_hobbies()const { return num_hobbies; }
	char** get_hobbies_lst() const{ return hobbies_lst; }
};

