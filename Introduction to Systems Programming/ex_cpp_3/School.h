/* Assignment: 3
Author1: Tom Kessous,
ID: 206018749
Author2: Dan Ben Ami,
ID: 316333079
*/
#pragma once
#include "Layer.h"
#include "Pupil.h"
#include "Manager.h"
#include "Tutor.h"
#include "Secretary.h"



class School
{
private:
	vector<Layer*> Layers;
	int num_of_Layer;
	vector<Pupil*> pupils;
	vector<Worker*> workers;
	static School* p_school;
	School():num_of_Layer(0) {}
	int manager_idx = -1;

public:
	~School();
	static School* school();
	void menu();
	void Add_pupil();
	void Add_teacher_tutor(const string who);
	int is_layer(char layer);
	bool is_class_num(char layer, int class_num);
	int Add_layer_ret_idx(char layer);
	Class* Add_class_ret_ptrclass(char layer, int class_num);
	void Add_Secretary();
	void Print_person_details();
	void Print_outstanding_people();
	void Print_tutors_class();
	void Highest_paid_worker();
	void Add_manager();
};

