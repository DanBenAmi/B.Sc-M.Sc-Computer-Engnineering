/* Assignment C++: 2
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "String.h"
#include <iostream>
#include <string.h>
#include "Client.h"
#include <vector>
#include "MatchMakingAgency.h"
using namespace std;
#include "Menu.h"

char* Menu::get_input() {					//Allocating memory for input string 
	vector<char> tmp;						//and return the string pointer.
	char tmp_ch;
	tmp_ch = getchar();
	while (tmp_ch != '\n') {
		tmp.push_back(tmp_ch);
		tmp_ch = getchar();
	}
	char* str = new char[tmp.size()+1];
	for (int i = 0; i < tmp.size(); i++) {
		str[i] = tmp[i];
	}
	str[tmp.size()] = '\0';
	return str;
}

void Menu::Add_new_client() {
	while ((getchar()) != '\n');				//clear the buffer;
	cout << "Please enter the following details:\n";
	cout << "ID: " << endl;
	char *tmp = get_input();					//tmp hold a string of the id;
	String id(tmp);								
	delete[] tmp;

	cout << "Name: "<<endl;
	tmp = get_input();
	String name(tmp);
	delete[] tmp;

	cout << "Gender F/M: " << endl;
	char gender = getchar();
	while (gender != 'F' && gender != 'M') {
		while ((getchar()) != '\n');				//clear the buffer;
		cout << "Please enter only F/M" << endl;
		gender = getchar();
	}
	while ((getchar()) != '\n');

	cout << "Age: " << endl;
	double age;
	cin >> age;
	if (age < 18) {
		cout << "You are too young, come back when you are 18 years old" << endl;
		return;
	}

	cout << "Amount of hobbies: " << endl;
    int num_hobbies;
	cin >> num_hobbies;
	while (num_hobbies < 0) {
		cout << "Amount of hobbies must be a positive integer" << endl;
		cin >> num_hobbies;
	}
	char** hobbies_lst = new char* [num_hobbies];				//Allocating memory for hobbies list
	while ((getchar()) != '\n');				//clear the buffer;
	for (int i = 0; i < num_hobbies; i++) {
		cout << "Hobby number " << i + 1 <<": "<< endl;
		tmp = get_input();
		hobbies_lst[i] = tmp;
	}
	Client person(id, name, gender, age, num_hobbies, hobbies_lst);
	this->agency += person;
	for (int i = 0; i < num_hobbies; i++) delete[] hobbies_lst[i];
	delete[] hobbies_lst;
}

void Menu::Remove_client() {
	cout << "Please enter the ID of the client you would like to remove: " << endl;
	while ((getchar()) != '\n');				//clear the buffer;
	char* id = get_input();					// hold a string of the id;
	char** dontcare = NULL;
	Client remove_person(String(id), String("dontcare"), 'F', 50, 0, dontcare);
	if (this->agency -= remove_person) cout << "The client removed." << endl;
	else cout << "The client not found" << endl;
}

void Menu::print() {
	cout << this->agency;
	cout << "The amount of clients is: " << this->agency.get_num_clients() << endl;
}

void Menu::print_matches(){
	cout << "Please enter the ID of the client for finding matchs: " << endl;
	while ((getchar()) != '\n');				//clear the buffer;
	char* id = get_input();					//tmp hold a string of the id;
	String match_client(id);
	this->agency.find_match(match_client);
}


void Menu::display() {
	int option = 0;
	while (option != 5) {
		while (option < 1 || option > 5) {                //displaying main menu
			cout <<endl<< "Please choose one of the following options:\n";
			cout << "=============================================== \n";
			cout << "1) Add a new client to the database.\n";
			cout << "2) Remove an existing client from the database.\n";
			cout << "3) Print all clients.\n";
			cout << "4) Print all matches for a client.\n";
			cout << "5) Quit the program.\n";
			cout << "==========================================================\n";
			cin >> option;
		}
	
		if (option == 1) this->Add_new_client();
		if (option == 2) this->Remove_client();
		if (option == 3) this->print();
		if (option == 4) this->print_matches();

		if (option == 5) cout << "Goodbye" << endl;
		if (option != 5) option = 0;				//returning to main menu if 4 wasn't pressed
	}
}

