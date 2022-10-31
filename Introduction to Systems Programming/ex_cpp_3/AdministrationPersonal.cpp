/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "AdministrationPersonal.h"
AdministrationPersonal::AdministrationPersonal(string first_name,
	string last_name, int managerial_years, string office_number)
	: Worker(first_name,last_name, managerial_years,0), office_num(office_number) {}
