/* Assignment C++: 2
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "String.h"
#include <iostream>
#include <string.h>
#include "Client.h"
#include "MatchMakingAgency.h"
#include "Menu.h"
using namespace std;


int main() {
	/*char tom[] = "tom kesos";
	String dan("tom kesos");
	char t[] = "dan";
	String tmp("dan");
	if (tmp == dan) cout << "true";
	else cout << "false";
	cout << tmp;
	tmp = dan;
	if (tmp == dan) cout << "true" << endl;
	else cout << "false" << endl;
	cout << tmp;
	cout << "gt";
	char** hobbies, temp[256];
	int n,i;
	cin >> n;
	hobbies = new char*[n];
	for (i = 0; i < n; i++) {
		cin>>temp;
		hobbies[i] = new char[strlen(temp) + 1];
		strcpy(hobbies[i], temp);
	}
	

	String id("316333   079   "), name("dan  ben ami  ");
	Client one(id, name, 'M', 50.6, 4, hobbies);
	Client two(String("54"), String("   nli   de  "),'F', 47, 4, hobbies);
	if (one == two) cout << "math found\n";

	MatchMakingAgency tom;
	tom += one;
	tom += two;
	MatchMakingAgency dan;
	dan = tom;
	cout << tom;
	tom -= one;
	tom -= two;
	tom.find_match(String("54"));*/

	Menu dan;
	dan.display();
}