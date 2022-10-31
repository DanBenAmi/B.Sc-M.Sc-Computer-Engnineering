/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Worker.h"
#pragma once
class AdministrationPersonal:virtual public Worker
{
private:
	string office_num;
public:
	AdministrationPersonal() {}
	AdministrationPersonal(string first_name, string last_name, int managerial_years, string office_number);
	virtual ~AdministrationPersonal(){}
	string get_office_num() const { return office_num; }
	void set_office_num(const string office_number) { office_num = office_number; }
	virtual int get_salary() = 0;
	virtual bool is_outstanding() = 0;
	virtual void print_details() = 0;

};

