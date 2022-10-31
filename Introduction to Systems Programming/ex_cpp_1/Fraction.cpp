/* Assignment: 1
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#include "Fraction.h"
#include<iostream>
using namespace std;

Fraction::Fraction() { mone = 0; mechane = 1; }				//Generic constractor.
Fraction::Fraction(int new_mone, int new_mechane) {			//Constractor.
	if (new_mechane == 0) {
		mechane = 1;
		mone = 0;
	}
	else {
		mone = new_mone;									//Initialize the fraction
		mechane = new_mechane;
	}
}

float Fraction::value() {
	return float(mone)/ mechane;
}

void Fraction::updateNumerator(int new_mone) {
	mone = new_mone;
}

void Fraction::updateDenominator(int new_mechane) {
	if (new_mechane == 0) {
		mechane = 1;
		mone = 0;
	}
	else
		mechane = new_mechane;
}

void Fraction::printValue() {
	cout << mone << '/' << mechane << endl;
}

