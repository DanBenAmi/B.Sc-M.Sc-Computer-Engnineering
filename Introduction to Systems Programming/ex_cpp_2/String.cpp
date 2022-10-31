/* Assignment C++: 2
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/ 
#include "String.h"
#include <iostream>
#include <string.h>
using namespace std;

String::String() { this->str = NULL; }					//Default constructor.


String::String(const char* str) {						//constructor.
	int i = 0, counter = 0;
	while (str[i] == ' ' || str[i] == '\t') i++;		//move the index to the start of the name.
	while (str[i] != '\0') {							//counting the real size of str.
		if (str[i] != ' ' && str[i] != '\t')counter++;
		else if (str[i - 1] != ' ' && str[i - 1] != '\t' && i > 0) counter++;
		i++;
	}
	if (str[i - 1] == ' ')counter--;
	this->str = new char[counter + 1];					//allocating dynamic memory
	int j = 0;
	i = 0;
	while (str[i] != '\0' && j != counter) {			//copy the name/id to the correct size str.
		if (str[i] != ' ' && str[i] != '\t')this->str[j++] = str[i];
		else if (str[i - 1] >= '0' && str[i - 1] <= '9' && i > 0);
		else if (str[i - 1] != ' ' && str[i - 1] != '\t' && i > 0) this->str[j++] = str[i];
		i++;
	}
	this->str[j] = '\0';
}

String::String(const String& obj) {					//copy constructor.
	this->str = new char[strlen(obj.str) + 1];
	strcpy(this->str, obj.str);
}

String::~String() {									//destructor.
	delete[] this->str;
}

String &String:: operator=(const String obj2) {
	delete[] this->str;
	this->str = new char[strlen(obj2.str) + 1];
	strcpy(this->str, obj2.str);
	return *this;
}

bool String::operator==(const String obj2) {
	int i = 0;
	if (strlen(this->str) != strlen(obj2.str)) return false;
	while (this->str[i] == obj2.str[i]) {
		if (i == strlen(this->str)) return true;
		i++;
	}
	return false;
}

ostream& operator <<(ostream& out, const String& c) {
	return out << c.str;
}






