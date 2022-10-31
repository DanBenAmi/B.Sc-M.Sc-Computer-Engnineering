/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "School.h"
#include <iostream>
#include <string>

School* School::p_school = NULL;



School* School::school(){
	if (p_school != NULL) cout << "This program designed for only one school. there is already a school registered." << endl;
	else {
		static School bgu;
		p_school = &bgu;
	}
	return p_school;
}

void School::menu() {
	int option = 0;
	while (option != 10) {
		while (option < 1 || option > 10) {                //displaying main menu
			cout << endl << "Please choose one of the following options:\n";
			cout << "=============================================== \n";
			cout << "1) Add pupil.\n";
			cout << "2) Add teacher.\n";
			cout << "3) Add Tutor.\n";
			cout << "4) Add manager.\n";
			cout << "5) Add Secretary.\n";
			cout << "6) Print person details.\n";
			cout << "7) Print outstanding people.\n";
			cout << "8) Print tutor’s class.\n";
			cout << "9) Highest paid worker.\n";
			cout << "10) Exit.\n";
			cout << "==========================================================\n";
			cin >> option;
		}

		if (option == 1) Add_pupil();
		if (option == 2) Add_teacher_tutor("teacher");
		if (option == 3) Add_teacher_tutor("tutor");
		if (option == 4) Add_manager();
		if (option == 5) Add_Secretary();
		if (option == 6) Print_person_details();
		if (option == 7) Print_outstanding_people();
		if (option == 8) Print_tutors_class();
		if (option == 9) Highest_paid_worker();
		if (option != 10) option = 0;				//returning to main menu if 4 wasn't pressed
	}
}

int School::is_layer(char layer) {
	for (int i = 0; i < Layers.size(); i++) {
		if (Layers[i]->get_layer() == layer) return i;
	}
	return -1;
}

bool School::is_class_num(char layer, int class_num) {
	for (int i = 0; i < Layers.size(); i++) {
		if (Layers[i]->get_layer() == layer) {
			vector<Class*> classes = Layers[i]->get_classes();
			for (int j = 0; j < classes.size(); j++) {
				if (classes[j]->get_class_num() == class_num)
					return true;
			}
		}
	}
	return false;
}

int School::Add_layer_ret_idx(char layer) {			//return the index of the layer in vector.
	int i = this->is_layer(layer);
	if ( i < 0) {
		vector<Class*> classes;
		Layers.push_back(new Layer(layer, classes));
		i = Layers.size()-1;
	}
	return i;
}

Class* School::Add_class_ret_ptrclass(char layer, int class_num) {
	if (!this->is_class_num(layer, class_num)) {
		for (int i = 0; i < Layers.size(); i++) {
			if (Layers[i]->get_layer() == layer) {
				return Layers[i]->set_class(class_num);
			}
		}
	}
	for (int i = 0; i < Layers.size(); i++) {
		if (Layers[i]->get_layer() == layer) {
			int x = Layers[i]->get_classes().size();
			for (int j = 0; j < x; j++) {
				if (Layers[i]->get_classes()[j]->get_class_num() == class_num)
					return Layers[i]->get_classes()[j];
			}

		}
	}
	return NULL;
}

void School::Add_pupil() {
	string first_name, last_name;
	vector<int> grades;
	char layer;
	int class_num, tmp; 
	cout << "Please enter the folowing details:\nFirst name:\n";
	cin.ignore(1,'\n');
	getline(cin, first_name);
	cout << "Last name:\n";
	getline(cin, last_name);
	cout << "Please enter your grades(if you finish type -1):\n";
	cout << "Grade number 1:\n";
	cin >> tmp;
	int i = 2;
	while (tmp != -1) {
		if (tmp >= 0 && tmp <= 100) {
			grades.push_back(tmp);
			cout << "Grade number " << i << ":\n"; 
			i++;
		}
		else {
			cout << "The grades range is only from 0 to 100\n";
			cout << "Grade number " << i-1 << ":\n";
		}
		cin >> tmp;
	}
	cout << "Layer:\n";
	cin >> layer;
	while (layer < 'a' || layer>'f') {
		cout << "The layer range is from a to f (in small letters).\nPlease enter a new layer:\n";
		cin >> layer;
	}
	cout << "Class number:\n";
	cin >> class_num;
	while (class_num < 0 || class_num>=3) {
		cout << "The class number range is from 1 to 3.\nPlease enter a new class number:\n";
		cin >> class_num;
	}
	int layer_idx = this->Add_layer_ret_idx(layer);
	Class* pup_class = Add_class_ret_ptrclass(layer, class_num);
	pupils.push_back(new Pupil(first_name, last_name, grades, layer, class_num));
	pup_class->add_pupil(pupils[pupils.size() - 1]);
}

void School::Add_teacher_tutor(const string who) {
	string first_name, last_name;
	int teaching_years, num_of_courses;
	vector<string> courses;
	cout << "Please enter the folowing details:\nFirst name:\n";
	cin.ignore(1, '\n');
	getline(cin, first_name);
	cout << "Last name:\n";
	getline(cin, last_name);
	cout << "Teaching years:\n";
	cin >> teaching_years;
	while (teaching_years < 0) {
		cout << "The teaching years range is from 0 and above.\nPlease enter a new teaching years:\n";
		cin >> teaching_years;
	}
	cout << "Number of courses:\n";
	cin >> num_of_courses;
	while (num_of_courses <= 0) {
		cout << "The number of courses range is from 1 and above.\nPlease enter a new number of courses:\n";
		cin >> num_of_courses;
	}

	cout << "Please enter your courses:\n";
	string tmp;
	for(int i =0; i<num_of_courses;i++){
		cout << "Course number " << i+1 << ":\n";
		cin >> tmp;
		courses.push_back(tmp);		
	}
	if (who=="teacher")
	workers.push_back(new Teacher(first_name, last_name, teaching_years, courses, num_of_courses));
	else {
		cout << "Layer(from 'a' to 'f')\n";
		int class_num;
		char layer;
		cin >> layer;
		while (layer < 'a' || layer>'f') {
			cout << "The layer range is from a to f (in small letters).\nPlease enter a new layer:\n";
			cin >> layer;
		}
		cout << "Class number:\n";
		cin >> class_num;
		while (class_num < 0 || class_num>=3) {
			cout << "The class number range is from 1 to 3.\nPlease enter a new class number:\n";
			cin >> class_num;
		}
		int layer_idx = this->Add_layer_ret_idx(layer);
		Class* tut_class = Add_class_ret_ptrclass(layer,class_num);
		Tutor* p_tut = new Tutor(first_name, last_name, teaching_years, courses, num_of_courses);
		p_tut->set_my_class(tut_class);
		if (tut_class->get_class_tutor() != NULL)
			tut_class->get_class_tutor()->set_my_class(NULL);
		tut_class->set_class_tutor(p_tut);
		workers.push_back(p_tut);
	}
}

void School::Add_Secretary() {
	string first_name, last_name, office_number;
	int managerial_years, num_of_childs;
	vector<string> courses;
	cout << "Please enter the folowing details:\nFirst name:\n";
	cin.ignore(1, '\n');
	getline(cin, first_name);
	cout << "Last name:\n";
	getline(cin, last_name);
	cout << "managerial years:\n";
	cin >> managerial_years;
	while (managerial_years < 0) {
		cout << "The managerial years range is from 0 and above.\nPlease enter a new managerial years:\n";
		cin >> managerial_years;
	}
	cout << "office number:\n";
	cin.ignore(1, '\n');
	getline(cin, office_number);
	cout << "Number of childs:\n";
	cin >> num_of_childs;
	while (num_of_childs < 0) {
		cout << "The number of childs range is from 0 and above.\nPlease enter a new number of childs:\n";
		cin >> num_of_childs;
	}
	workers.push_back(new Secretary(first_name, last_name, managerial_years, 
		office_number, num_of_childs));
}

void School::Print_person_details() {
	if (workers.empty()) cout << "There are no workers in this school\n";
	else {
		cout << "The workers of the school are:\n===============================================\n";
		for (int i = 0; i < workers.size(); i++) {
			cout << "Worker number " << i + 1 << ":\n";
			workers[i]->print_details();
			cout << endl;
		}
	}
	if (pupils.size() == 0) cout << "And there are no pupils in this school\n";
	else {
		cout << "The pupils of the school are:\n===============================================\n";
		for (int i = 0; i < pupils.size(); i++) {
			cout << "Pupil number " << i + 1 << ":\n";
			pupils[i]->print_details();
			cout << endl;
		}
	}
}

void School::Print_outstanding_people() {
	cout << "The outstanding workers of the school are:\n===============================================\n";
	bool no_os = false;
	for (int i = 0; i < workers.size(); i++) {
		if (workers[i]->is_outstanding()) {
			cout << "Worker number " << i + 1 << ":\n";
			no_os = true;
			workers[i]->print_details();
			cout << endl;
		}
	}
	if (!no_os)cout << "None. maybe next year.\n";
	no_os = false;
	cout << "The outstanding pupils of the school are:\n===============================================\n";
	for (int i = 0; i < pupils.size(); i++) {
		if (pupils[i]->is_outstanding()) {
			cout << "Pupil number " << i + 1 << ":\n";
			no_os = true;
			pupils[i]->print_details();
			cout << endl;
		}
	}
	if (!no_os)cout << "None. maybe next year.\n";
}

void School::Print_tutors_class() {
	string first_name, last_name;
	cout << "Please enter the tutor name (please type the exact same names as it's in the database):\nFirst name:\n";
	cin.ignore(1, '\n');
	getline(cin, first_name);
	cout << "Last name:\n";
	getline(cin, last_name);
	bool no_tut = true;
	for (int i = 0; i < Layers.size(); i++) {
		int x = this->Layers[i]->get_classes().size();
		for (int j = 0; j < x; j++) {
			Tutor* ptut = Layers[i]->get_classes()[j]->get_class_tutor();
			if (ptut) {
				if (ptut->get_first_name() == first_name && ptut->get_last_name() == last_name) {
					cout << "The tutor class is:\n==================================\n";
					Layers[i]->get_classes()[j]->print_details();
					no_tut = false;
				}
			}
		}
	}
	if (no_tut) cout << "There is no tutor in the data base with this name\n";
}

void School::Highest_paid_worker() {
	int higest_idx = 0;
	if (workers.size() == 0) cout << "There are no workers in this school\n";
	else {
		cout << "The highest paid worker of the school is:\n===============================================\n";
		for (int i = 0; i < workers.size(); i++) {
			if (workers[i]->get_salary() > workers[higest_idx]->get_salary()) higest_idx = i;
		}
		workers[higest_idx]->print_details();
	}
}

void School::Add_manager() {
	if (manager_idx == -1) {
		string first_name, last_name, office_number;
		int managerial_years, num_of_childs;
		vector<string> courses;
		cout << "Please enter the folowing details:\nFirst name:\n";
		cin.ignore(1, '\n');
		getline(cin, first_name);
		cout << "Last name:\n";
		getline(cin, last_name);
		cout << "managerial years:\n";
		cin >> managerial_years;
		while (managerial_years < 0) {
			cout << "The managerial years range is from 0 and above.\nPlease enter a new managerial years:\n";
			cin >> managerial_years;
		}
		cout << "office number:\n";
		cin.ignore(1, '\n');
		getline(cin, office_number);
		Manager* p_man = Manager::manager(first_name, last_name, managerial_years, office_number);
		workers.push_back(p_man);
		manager_idx = workers.size() - 1;
		cout << "Is the Manager also a teacher[yes/no]\n";
		string is_teach;
		getline(cin, is_teach);
		while (is_teach != "yes" && is_teach != "no") {
			cout << "Please enter only the words 'yes' or 'no'\n";
			getline(cin, is_teach);
		}
		if (is_teach == "yes") {
			int teaching_years, num_of_courses;
			vector<string> courses;
			cout << "Teaching years:\n";
			cin >> teaching_years;
			while (teaching_years < 0) {
				cout << "The teaching years range is from 0 and above.\nPlease enter a new teaching years:\n";
				cin >> teaching_years;
			}
			cout << "Number of courses:\n";
			cin >> num_of_courses;
			while (num_of_courses <= 0) {
				cout << "The number of courses range is from 1 and above.\nPlease enter a new number of courses:\n";
				cin >> num_of_courses;
			}

			cout << "Please enter your courses:\n";
			string tmp1;
			for (int i = 0; i < num_of_courses; i++) {
				cout << "Course number " << i + 1 << ":\n";
				cin >> tmp1;
				courses.push_back(tmp1);
			}
			p_man->make_manager_teacher(courses, num_of_courses, teaching_years);
		}
	}
	else cout << "Sorry, there is already a manager for this school.there is only room for one manager." << endl;
	
	
}

School::~School() {
	for (int i = 0; i < Layers.size(); i++) {
		for (int j = 0; j < Layers[i]->get_classes().size(); j++) {
			delete Layers[i]->get_classes()[j];
		}
		delete Layers[i];

	}
	for (int i = 0; i < workers.size(); i++) {
		if(i != manager_idx) delete workers[i];
	}
	for (int i = 0; i < pupils.size(); i++) {
		delete pupils[i];
	}
	

}





