/*
 * TFC.h
 *
 *  Created on: Apr 13, 2012
 *      Author: emh203
 */

#ifndef TFC_H_
#define TFC_H_
#define cb_size		 4096
#define files_amount 3

#include <stdint.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include "Derivative.h"
#include "BoardSupport.h"
#include "arm_cm0.h"
#include "UART.h"


struct files_struct{
	int files_pointer[files_amount] ;
	char files_names[files_amount][20];
	int files_num;
	int file_idx;
	int files_size[files_amount];
	int valid[files_amount];
	int cb_pointer;
};

void lcd_count_up();
void lcd_count_down();
void servo_deg();
void servo_scan();
void decode_instruction(const char* instruction);
void execute_script();
void send_scripts_list();
void get_file();
void display_files(int disp_file_cnt);
void circular_logic();
void run_over_logic();
void init();
void telemeter();
void radar();
void script();




#endif /* TFC_H_ */
