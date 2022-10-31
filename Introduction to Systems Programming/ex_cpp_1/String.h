/* Assignment: 1
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#pragma once
#include<iostream>
class String
{
private:
	char str[10];
	int len;
public:
	String();
	String(char new_str[]);
	void updateValue(char new_str[]);
	bool setCharAt(char chr, int idx);
	bool setCharsByUser();
	char getCharAt(int idx);
	void printValue();
	void printValue(bool upper);

};

