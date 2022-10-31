/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "AdministrationPersonal.h"
#pragma once
class Secretary : public AdministrationPersonal
{
private:
	int num_of_childs;
public:
	Secretary(){}
	Secretary(string first_name, string last_name, int managerial_years,
		string office_number, int num_of_childs):Worker(first_name, last_name, managerial_years,0),
		AdministrationPersonal(first_name, last_name, managerial_years, office_number), num_of_childs(num_of_childs){}
	~Secretary(){}
	virtual int get_salary();
	virtual bool is_outstanding();
	virtual void print_details();




};

