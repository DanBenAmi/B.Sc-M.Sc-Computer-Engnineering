/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "AdministrationPersonal.h"
#include "Teacher.h"

#pragma once
class Manager : public AdministrationPersonal, public Teacher
{
private:
	static Manager* p_manager;
	Manager() {}
	Manager(string first_name, string last_name, int managerial_years, string office_number);
public:
	virtual ~Manager() {}
	void make_manager_teacher(vector<string> courses, int num_of_courses, int teaching_years);
	void change_manager(string first_name, string last_name, int managerial_years, string office_number);
	virtual void print_details();
	static Manager* manager(string first_name, string last_name, int managerial_years, string office_number);
	//static Manager& who_is_the_boss() { return *p_manager; }
	virtual int get_salary();
	virtual bool is_outstanding();
	Manager& operator=(const Manager& ob2);
	//Manager(const Manager& ob2);
};