/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Worker.h"

 void Worker::print_details() {
	 Person::print_details();
	 cout << "Managerial seniority years: " << managerial_years << endl;
	 cout << "Teaching seniority years: " << teaching_years << endl;
 }


