/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Class.h"

Class::Class(char layer, int class_num, vector<Pupil*> pupils,
	int num_of_pupils) : layer(layer), class_num(class_num),
	pupils(pupils), num_of_pupils(num_of_pupils) {
	tutor = NULL;
}

void Class::set_class_tutor(Tutor* tutor) {
	this->tutor = tutor;
}


void Class::add_pupil(Pupil* new_pupil) {
	pupils.push_back(new_pupil);
	this->num_of_pupils++;
}

Pupil* Class::get_pupil_by_index(int index) {
	if (index< pupils.size() && index>=0) return pupils[index]; 
	else {
	cout<<"Index is illegal"<<endl;
	return NULL;
	}
}	

void Class::print_details() {
	cout << "Layer: " << layer << endl <<
		"class Number: " << class_num << endl <<
		"Number of pupils: " << num_of_pupils << endl;
	if (num_of_pupils) {
		cout << "The pupils in the class are:" << endl;
		for (int i = 0; i < num_of_pupils; i++) {
			cout << "Pupil number " << i + 1 << ":" << endl;
			pupils[i]->print_details();
		}
	}
	else cout << "Threre are no pupils in this class." << endl;
}


