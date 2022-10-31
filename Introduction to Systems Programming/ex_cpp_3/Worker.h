/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Pupil.h"
#pragma once
class Worker : public Person
{
private:
	int managerial_years;
	int teaching_years;
	static const int basis = 25;
public:
	Worker() : managerial_years(0), teaching_years(0){}
	Worker(string first_name, string last_name, int managerial_years, int teaching_years) : Person(first_name, last_name), managerial_years(managerial_years), teaching_years(teaching_years){}
	virtual ~Worker(){}
	int get_managerial_years() const { return managerial_years; }
	int get_teaching_years() const { return teaching_years; }
	void set_managerial_years(const int years) { this->managerial_years = years; }
	void set_teaching_years(const int years) { this->teaching_years = years; }
	virtual int get_salary() = 0;
	virtual void print_details();
	int get_basis() { return basis; }
};

