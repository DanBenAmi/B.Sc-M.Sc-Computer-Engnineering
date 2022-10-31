/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Manager.h"

Manager* Manager::p_manager = NULL;


Manager::Manager(string first_name, string last_name, int managerial_years, string office_number) :
	Worker(first_name, last_name, managerial_years,0), AdministrationPersonal(first_name, last_name, managerial_years, office_number) {
	p_manager = this;
}

void Manager::make_manager_teacher(vector<string> courses, int num_of_courses, int teaching_years) {
	this->set_courses(courses);
	this->set_num_of_courses(num_of_courses);
	Teacher::set_teaching_years(teaching_years);
}

Manager* Manager::manager(string first_name, string last_name, int managerial_years, string office_number) {
	if (p_manager != NULL) cout << "Sorry, there is already a manager for "
		<< "this school.\nthere is only room for one manager." << endl;
	else {
		static Manager boss(first_name, last_name, managerial_years, office_number);
		p_manager = &boss;
	}
	return p_manager;
}

int Manager::get_salary() {
	int salary = Worker::get_basis() * 2 + 500 * AdministrationPersonal::get_managerial_years();
	if (this->get_num_of_courses()) salary += Teacher::get_salary();
	return salary;
}

bool Manager::is_outstanding() {
	if (AdministrationPersonal::get_managerial_years() > 3) return true;
	return false;
}

void Manager::print_details() {
	Person::print_details();
	cout << "Salary: " << this->get_salary() << endl;
	cout << "Managerial seniority years: " << AdministrationPersonal::get_managerial_years() << endl;
	if (Teacher::get_num_of_courses()) {
		cout << "Number of courses: " << Teacher::get_num_of_courses() << endl;
		this->print_courses();
	}
	cout << "Teaching seniority years: " << Teacher::get_teaching_years() << endl;
}

void Manager::change_manager(string first_name, string last_name, int years, string office_number) {
	this->set_first_name(first_name);
	this->set_last_name(last_name);
	AdministrationPersonal::Worker::set_managerial_years(years);
	AdministrationPersonal::set_office_num(office_number);
	vector<string> nada;
	Teacher::set_courses(nada);
	Teacher::set_num_of_courses(0);
	Teacher::Worker::set_teaching_years(0);
}

Manager & Manager::operator=(const Manager&  ob2) {
	this->set_first_name(ob2.get_first_name());
	this->set_last_name(ob2.get_last_name());
	AdministrationPersonal::set_managerial_years(ob2.get_managerial_years());
	this->set_office_num(ob2.get_office_num());
	if (ob2.get_num_of_courses())
		this->make_manager_teacher(ob2.get_courses(), ob2.get_num_of_courses(), ob2.get_teaching_years());
	
	else {
		vector<string> klum;
		this->make_manager_teacher(klum, 0, 0);
	}
	return *this;
}

/*Manager::Manager(const Manager& ob2) {
	this->set_first_name(ob2.get_first_name());
	this->set_last_name(ob2.get_last_name());
	AdministrationPersonal::set_senyiority_years(ob2.get_Managerial_years());
	this->set_office_num(ob2.get_office_num());
	if (ob2.get_num_of_courses())
		this->make_manager_teacher(ob2.get_courses(), ob2.get_num_of_courses(), ob2.get_teaching_years());

	else {
		vector<string> klum;
		this->make_manager_teacher(klum, 0, 0);
	}
	delete p_manager;
	p_manager = this;
}*/









