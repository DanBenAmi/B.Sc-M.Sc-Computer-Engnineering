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

MatchMakingAgency::MatchMakingAgency() { num_clients = NULL; }

bool MatchMakingAgency:: operator+=(const Client &obj2) {
	for (int i = 0; i < clients.size(); i++) {
		if (clients[i].get_id() == obj2.get_id()) return false;
	}
	clients.push_back(obj2);
	num_clients++;
	return true;
}

bool MatchMakingAgency::operator-=(const Client& obj2) {
	for (int i = 0; i < clients.size(); i++) {
		if (clients[i].get_id() == obj2.get_id()) {
			clients.erase(clients.begin()+i);
			num_clients--;
			return true;
		}
	}
	return false;
}

void MatchMakingAgency::find_match(const String &match_id) {
	cout << "The matches are:" << endl;
	bool flag_matches = false, flag_exist = false;
	for (int i = 0; i < clients.size(); i++) {
		if (clients[i].get_id() == match_id) {
			flag_exist = true;
			for (int j = 0; j < clients.size(); j++){
				if (clients[i] == clients[j]) {
					cout <<"Name: "<<clients[j].get_name() << "	   " <<"ID: "<< clients[j].get_id() << endl;
					flag_matches = true;
				}
			}
		}
	}
	if (!flag_exist) cout << "The client is not the databse" << endl;
	if (!flag_matches) cout << "No matches found" << endl;
}

MatchMakingAgency& MatchMakingAgency:: operator=(const MatchMakingAgency obj2) {
	this->num_clients = obj2.num_clients;
	this->clients = obj2.clients;
	return *this;
}

ostream& operator <<(ostream& out, const MatchMakingAgency& c) {
	out << "Clients List" << endl<<"================" << endl;
	for (int i = 0; i < c.clients.size(); i++) {
		out << "Name: " << c.clients[i].get_name() << endl << "ID: " <<
			c.clients[i].get_id() << endl << "Gender: " << c.clients[i].get_gender()
			<< endl << "Age: "<< c.clients[i].get_age() <<endl <<"Num of hobbies: "<<
			c.clients[i].get_num_hobbies() << endl << "Client Hobbies: ";
		for (int j = 0; j < c.clients[i].get_num_hobbies(); j++) {
			out << c.clients[i].get_hobbies_lst()[j];
			if (j != c.clients[i].get_num_hobbies() - 1) cout << ", ";
		}
		out << endl<<endl;
	}
	return out;

}

