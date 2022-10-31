/* Assignment C++: 2
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "String.h"
#include <iostream>
#include <string.h>
#include "Client.h"
#include <vector>
using namespace std;
#pragma once
class MatchMakingAgency
{
private:
	int num_clients;
	vector<Client> clients;
public:
	MatchMakingAgency();
	~MatchMakingAgency() {}
	bool operator+=(const Client& obj2);
	bool operator-=(const Client &obj2);
	void find_match(const String& id);
	MatchMakingAgency& operator=(const MatchMakingAgency obj2);
	friend ostream& operator <<(ostream& out, const MatchMakingAgency& c);
	int get_num_clients() { return num_clients; }
};