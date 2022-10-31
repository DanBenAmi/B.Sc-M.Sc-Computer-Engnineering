/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#pragma once
#include "Pupil.h"
#include "Worker.h"
#pragma once
template <typename T = Worker> class VecAnalyser
{
private:
	vector<T*> vec;
public:
	VecAnalyser(vector<T*> vect): vec(vect) {}
	T& operator[](int i);
	void swap(int i, int j);
	void printElement(int i);
	void printAll();
	void printMax();
	bool is_manager(int i);

};

