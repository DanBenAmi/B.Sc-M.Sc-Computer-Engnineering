/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Pupil.h"
#pragma once
class Tutor;

class Class
{
private:
	char layer;
	int class_num;
	vector<Pupil*> pupils;
	int num_of_pupils;
	Tutor* tutor;
public:
	Class() {}
	Class(char layer, int class_num, vector<Pupil*> pupils,
		int num_of_pupils);
	~Class() {}
	void set_class_tutor(Tutor* tutor);
	Tutor* get_class_tutor() { return tutor; }
	void add_pupil(Pupil* new_pupil);
	Pupil* get_pupil_by_index(int index);
	int get_num_of_pupils() { return num_of_pupils; }
	void print_details();
	int get_class_num() { return class_num; }


};

