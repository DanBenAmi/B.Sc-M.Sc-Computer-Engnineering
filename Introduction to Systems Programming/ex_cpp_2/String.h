/* Assignment C++: 2
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#pragma once
#include <iostream>
using namespace std;
class String
{
private:
	char* str;

public:
	String();
	String(const char* str);
	String(const String& obj);
	~String();
	String& operator=(const String obj2);			//opreator overloading
	bool operator==(const String obj2);
	friend ostream& operator <<(ostream& out, const String& c);
};