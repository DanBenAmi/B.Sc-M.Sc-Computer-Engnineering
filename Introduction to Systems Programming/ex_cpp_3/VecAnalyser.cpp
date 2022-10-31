/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#include "VecAnalyser.h"
template <typename T>
T& VecAnalyser<T>::operator[](int i)
{
	if (i >= 0 && i < vec.size())
		return  *vec[i];
	else
		cout << "The index " << i << " is out of range.\nThe range of the correct indexes are from 0 to " << vec.size() - 1 << "." << endl;
}

template <typename T>
void VecAnalyser<T>::swap(int i, int j) {
	T* tmp;
	int problem = i;
	if (i >= 0 && i < vec.size()) {
		problem = j;
		if (j >= 0 && j < vec.size()) {
			tmp = vec[i];
			vec[i] = vec[j];
			vec[j] = tmp;
		}
	}
	else
		cout << "The index " << problem << " is out of range.\nThe range of the correct indexes are from 0 to " << vec.size() - 1 << "." << endl;

	
}

template <typename T>
void VecAnalyser<T>::printElement(int i) {
	if (i >= 0 && i < vec.size())
		vec[i]->print_details();
	else
		cout << "The index " << i << " is out of range.\nThe range of the correct indexes are from 0 to " << vec.size() - 1 << "." << endl;
}

template <>
void VecAnalyser<Pupil>::printAll() {
	for (int i = 0; i < vec.size(); i++)
		this->printElement(i);
}

template <>
void VecAnalyser<Worker>::printAll() {
	for (int i = 0; i < vec.size(); i++)
		this->printElement(i);
}

template <>
void VecAnalyser<Pupil>::printMax() {
	int max = 0;
	for (int i = 1; i < vec.size(); i++) {
		if (vec[i]->average() > vec[max]->average())
			max = i;
	}
	cout << "The pupil with the best average is:" << endl;
	printElement(max);
}

template <>
void VecAnalyser<Worker>::printMax() {
	int max = 0;
	for (int i = 1; i < vec.size(); i++) {
		if (vec[i]->get_salary() > vec[max]->get_salary())
			max = i;
	}
	cout << "The worker with the highest salary is:" << endl;
	printElement(max);
}

template <>
bool VecAnalyser<Worker>::is_manager(int i) {
	string tmp = typeid (*vec[i]).name();
	if (tmp == "class Manager")
		return true;
	return false;
}

template <>
bool VecAnalyser<Pupil>::is_manager(int i) {
	if (typeid(*vec[i]).name() == "class Manager")
		return true;
	return false;
}
