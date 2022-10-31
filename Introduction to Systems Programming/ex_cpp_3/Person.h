/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include <vector>
#include <iostream>
#include <string>
using namespace std;
#pragma once
class Person
{
private:
	string first_name, last_name;
public:
	Person() {};
	Person(string first_name, string last_name);
	~Person();
	string get_first_name() const { return first_name; }
	string get_last_name() const { return last_name; }
	void set_first_name(const string first_name);
	void set_last_name(const string last_name);
	virtual void print_details() = 0;
	virtual bool is_outstanding() = 0;
};

