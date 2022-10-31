/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "Tutor.h"
#include "Manager.h"
#include "VecAnalyser.h"
#include "School.h"



int main() {
	/*string first = "tom";
	string last = "kessous";
	string first1 = "dan";
	string last1 = "ben ami";
	
	vector<int> grades;
	for (int i = 0; i < 11; i++) grades.push_back(i + 79);
	Pupil tom1(first,last,grades, 'a', 2);
	tom1.print_details();
	Person* pp = &tom1;
	cout << pp->get_first_name() << endl;
	pp->print_details();
	vector<string> courses;
	courses.push_back("hedva");
	courses.push_back("dvarim kefim");
	Teacher dan1(first1, last1, 3, courses, 2);
	dan1.print_details();
	vector<Pupil*> vec_pup;
	Pupil* ppup = &tom1;
	vec_pup.push_back(ppup);
	Tutor tomi(first, last, 5, courses, 2);
	Tutor* pt = &tomi;
	Class a2('a', 2, vec_pup, 1);
	pt->set_my_class(&a2);
	a2.set_class_tutor(pt);
	Class* pc = &a2;
	tomi.set_my_class(pc);
	tomi.print_details();
	cout << endl;
	string o_n = "29";
	Manager* dan2 = Manager::manager(first1, last1,7,o_n);
	//Manager* dan2 = Manager::who_is_the_boss();
	dan2->print_details();
	cout << endl;
	dan2->make_manager_teacher(courses, 2, 3);
	dan2->print_details();
	//Worker* p_dan = &dan2;
	//Manager::manager(first, last, 5, o_n);
	/*VecAnalyser<Pupil> vect(vec_pup);
	vect.printElement(0);
	vect.printAll();
	cout << vect.is_manager(0);
	vect.printMax();
	vector<Worker*> vectush;
	vectush.push_back(p_dan);
	VecAnalyser<Worker> amit(vectush);
	amit.printElement(0);
	amit.printAll();
	cout << amit.is_manager(0);
	amit.printMax();*/
	School* bgu = School::school();
	bgu->menu();
}
