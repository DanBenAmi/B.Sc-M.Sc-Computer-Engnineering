/* Assignment: 1
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "String.h"
#include<iostream>
using namespace std;
String::String() {									//Default constractor.
	str[10] = {NULL};
	len = 0;
}

String::String(char new_str[]) {					//Constractor.
	int i = 0;
	while (new_str[i] != '\0' || i == 9) {			//Initialize the string.
		str[i] = new_str[i];
		i++;
	}
	str[i] = '\0';
	len = i;
}

void String::updateValue(char new_str[]) {
	int i = 0;
	while (new_str[i] != '\0' && i != 9) {		///Update the string.
		str[i] = new_str[i];
		i++;
	}
	str[i] = '\0';
	len = i;

}

bool String::setCharAt(char chr, int idx) {
	if (idx <= len) {						//if index is legal.
		if (idx == len && len < 9) {
			str[idx + 1] = '\0';			//extent the string by 1.
			len++;
		}
		str[idx] = chr;
		return true;
	}
	return false;
}

bool String::setCharsByUser() {
	char finish = 'n';
	char tmp_chr, arr[10] = { NULL };
	int tmp_idx;
	while (finish != 'y') {						//while the user continue to set.
		cout << "Please enter char: ";
		cin >> tmp_chr;							//the char to update
		cout << endl;
		cout << "Please enter index (from 0 to the length of the string): ";
		cin >> tmp_idx;							//the index of the char.
		cout << endl;
		if (tmp_idx > len || tmp_idx < 0 || tmp_idx == 9) return false;  //inex out of range
		arr[tmp_idx] = tmp_chr;
		do {                                                       //finish withe this option?
			cout << "did you finish? press single char [y/n]: ";
			cin >> finish;
			cout << endl;
		} while (finish != 'y' && finish != 'n');
	}                                                      //if we got here, the inputs were valid,
	for (int i = 0; i < len; i++) {             // copying the changes
		if (arr[i] != NULL)	str[i] = arr[i];
	}
	if (arr[len] != NULL) {       //extending the string if necessery
		str[len] = arr[len];
		len++;
		str[len] = '\0';
	}
	return true;
}

char String::getCharAt(int idx) {
	if (idx < 0 || idx > len) return '-';    //dealing with invalid index
	return str[idx];
}

void String::printValue() {
	for (int i = 0; i < len; i++) {
		cout << str[i];
	}
	cout << endl;
}

void String::printValue(bool upper) {
	if (upper) {
		for (int i = 0; i < len; i++) {
			if ('a' <= str[i] && str[i] <= 'z')    //if the char is lowecase letter
				cout << char(str[i] - 'a' + 'A');
			else
				cout << str[i];
		}
		cout << endl;
	}
	else {
		for (int i = 0; i < len; i++) {
			if ('A' <= str[i] && str[i] <= 'Z')			//if the char is uppercase letter
				cout << char(str[i] + 'a' - 'A');
			else
				cout << str[i];
		}
		cout << endl;
	}
}