/* Assignment: 1
Author: Dan Ben Ami, ID: 316333079
Author: Tom Kessous, ID: 206018749
*/
#pragma once
#include<iostream>

class Fraction
{
private:
	int mone, mechane;
public:
	Fraction();
	Fraction(int new_mone, int new_mechane);
	float value();
	void updateNumerator(int new_mone);
	void updateDenominator(int new_mechane);
	void printValue();
};

