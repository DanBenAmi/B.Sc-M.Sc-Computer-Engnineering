/* Assignment: 1
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "TwoDigits.h"
#include<iostream>
using namespace std;

TwoDigits::TwoDigits() { lsb = '0'; msb = '0'; };			//set both to zeros.		

TwoDigits::TwoDigits(int num) {
	if (num < 0 || num>99)									//check if the num have two digits.
		cout << "number is not in the correct range, please enter a number from 0 to 99.";
	else {
	lsb = char(num % 10 + '0');								//convert the units digit to lsb.	
	msb = char(num / 10 + '0');								//convert the dozen digit to msb.		
	}
};

TwoDigits::TwoDigits(char new_msb, char new_lsb) {
	if (int(new_msb)-'0'>= 10 || int(new_lsb)-'0'>= 10)		//check if the new msb or the new lsb id digit.
		cout << "please enter digits and not other characters.";
	else {
		msb = new_msb;				
		lsb = new_lsb;
	}
}

int TwoDigits::value() {
	return (int(msb-'0') * 10 + int(lsb-'0'));				//return the value.
}

void TwoDigits::update(int new_num) {
	if (new_num < 0 || new_num>99)							//check if the num have two digits.
		cout << "number is not in the correct range, please enter a number from 0 to 99."<<endl;
	else {
		lsb = char(new_num % 10+'0');						//convert the units digit to lsb.
		msb = char(new_num / 10+'0');						//convert the dozen digit to msb.
	}
}

void TwoDigits::printValue() {
	if (msb == '0') cout << lsb << endl;
	else cout << msb << lsb<<endl;					//print the number.
}