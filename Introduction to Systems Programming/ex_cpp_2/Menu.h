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
#pragma once
class Menu
{
private:
	MatchMakingAgency agency;
	void Add_new_client();
	char* get_input();
	void Remove_client();
	void print();
	void print_matches();
public:
	Menu() {}
	void display();

};

