/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Layer.h"

Class Layer::get_class_by_idx(int idx) {
	return *classes[idx];
}

Class* Layer::set_class(int class_num) {
	vector<Pupil*> tmp;
	classes.push_back(new Class(this->layer, class_num, tmp, 0));
	return classes[classes.size() - 1];
}

