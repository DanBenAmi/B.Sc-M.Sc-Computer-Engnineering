/*
 * hal.c
 *
 *  Created on: Jun 6, 2021
 *      Author: tomki
 */
# include "TFC.h"
#include <stdio.h>
#include <math.h>
#include <string.h>


extern void run_over_logic();
extern void circular_logic();
extern void display(char arr);
extern struct files_struct files;
extern uint8_t state,sub_state;
extern void display_files(int disp_file_cnt);
extern disp_file_cnt;
extern int one_time_flag,target_angle,file_num,opc,opr;



int FW_BW=0,angle_diff=0,echo_times_idx=0;;
char arr[32];
int k = 0;
extern uint8_t str_num;
int prev_sample, echo_dist[4],counter=0;



//-----------------------------------------------------------------
// PIT - ISR = Interrupt Service Routine
//-----------------------------------------------------------------
void PIT_IRQHandler(){
	int angle;
	switch (state){
		case 1:
			if ((FW_BW==0)&&(TPM0_C1V<=0x1C18)){
				TPM0_C1V= (TPM0_C1V +0x09);
			}
			else if ((FW_BW==0)&&(TPM0_C1V>=0x1C18)){
				FW_BW=1;
			}
			else if((FW_BW==1)&&(TPM0_C1V>=0x700)){
				TPM0_C1V=(TPM0_C1V - 0x09);
			}
			else{
				FW_BW=0;
			}
			break;
		case 2:
			angle = target_angle*30+0x700;
			angle_diff = TPM0_C1V-angle;
			if(angle_diff < -9) TPM0_C1V= (TPM0_C1V +0x09);
			else if(angle_diff > 9) TPM0_C1V= (TPM0_C1V - 0x09);
			else {
				echo_times_idx=0;
				PIT_MCR |= PIT_MCR_MDIS_MASK; //Disable the PIT module
				sub_state=2;
			}
		case 3:
			if(opc==1){
				static uint8_t Color = 0;						//blink RGB
				if(Color & 0x01) RED_LED_ON;
				else RED_LED_OFF;
				if(Color & 0x02)GREEN_LED_ON;
				else GREEN_LED_OFF;
				if(Color & 0x04)BLUE_LED_ON;
				else BLUE_LED_OFF;
				if (Color>0x06){
					Color = (Color + 0x01) & 0x0007;
					opr--;
				}
				else Color = Color + 0x01;
			}
			else if((opc==2)||(opc==3)){		//count down or up
				char num[3]={'\0'};
				if(opc==2)sprintf(num,"%d",counter);
				else sprintf(num,"%d",10-counter);
				if(counter == 10){
					opr--;
				}
				counter = (counter + 1)%11;
				lcd_clear();
				lcd_home();
				DelayMs(15);
				lcd_puts(num);
			}
			else if(opc==6){						//servo_deg
				angle = target_angle*30+0x700;
				angle_diff = TPM0_C1V-angle;
				if(angle_diff < -9) TPM0_C1V= (TPM0_C1V +0x09);
				else if(angle_diff > 9) TPM0_C1V= (TPM0_C1V - 0x09);
				else echo_times_idx=0;
			}
	}
	PIT_TFLG0 = PIT_TFLG_TIF_MASK; //Turn off the Pit 0 Irq flag 
}

void FTM2_IRQHandler(){
	int echo_time = abs(TPM2_C1V-prev_sample);
	echo_times_idx = (echo_times_idx)%4;
	echo_dist[echo_times_idx++]= echo_time/44;//*17322;
	prev_sample = TPM2_C1V;
	TPM2_C1SC |= TPM_CnSC_CHF_MASK;
}




//-----------------------------------------------------------------
//  UART0 - ISR
//-----------------------------------------------------------------
void UART0_IRQHandler(){			//TODO move logical to main
	if(UART0_S1 & UART_S1_RDRF_MASK){ // RX buffer is full and ready for reading
		arr[k] = UART0_D;
		k++;
		if (arr[k-1] == '\n'){
			arr[k-1] = '\0';
			if ((arr[0]=='1') && (k=2) &&(arr[1]=='\0')) state=1;
			else if ((arr[0]=='2') && (k=2) &&(arr[1]=='\0')){
				state =2;
				sub_state=0;
			}
			else if ((arr[0]=='3') && (k=2) &&(arr[1]=='\0')){
				state = 3;
				sub_state = 0;
				lcd_clear();
				lcd_home();
				DelayMs(15);
			}
			else if ((arr[0]=='4') && (k=2) &&(arr[1]=='\0')){
				TPM0_C1V= 0x700;			//0x700= 0.6ms = 0 degree.
				PIT_MCR |= PIT_MCR_MDIS_MASK; //Disable the PIT module
				state =4;
			}
			else if((state==2)&&(sub_state==0)){
				sscanf(arr,"%d",&target_angle);
				sub_state=1;
			}
			else if((state==3)&&(arr[0]=='R')&&(arr[1]=='L')){		//pc ask to receive file list
				sub_state=3;
				one_time_flag = 1;
			}
			else if((state==3)&&(arr[0]=='E')&&(arr[1]=='X')){		// pc ask to execute a file 
				sub_state=4;
				one_time_flag = 1;
			}
			else if (state==3){
				sub_state++;
				one_time_flag = 1;
			}
			k=0;
		}
	}
}
////-----------------------------------------------------------------
//// 				DMA - HANDLER
////-----------------------------------------------------------------
void DMA0_IRQHandler(void)	  //when the file transfer from pc to MCU finished
{	
	UART0_C5 = 0x00; // Disable Transmitter, Receiver,DMA!
	disable_irq(INT_DMA0 - 16);
	UARTprintf(UART0_BASE_PTR,"Ack");
	if(files.cb_pointer > cb_size-1) circular_logic();

	if(files.file_idx==0){
		files.valid[2]=1;
		if((files.files_pointer[2]<files.files_pointer[0])&&
				(files.cb_pointer > files.files_pointer[0])) run_over_logic();
	}
	else{
		files.valid[files.file_idx-1]=1;
		if((files.files_pointer[files.file_idx-1]<files.files_pointer[0])&&
				(files.cb_pointer > files.files_pointer[0])) run_over_logic();
	}
	/* Enable DMA0*/ 
	DMA_DSR_BCR0 &= !DMA_DSR_BCR_DONE_MASK;	// Clear Done Flag
	DMA_DSR_BCR0 |= DMA_DSR_BCR_BCR(5571);		// Set byte count register
	sub_state=0;
}

void DMA1_IRQHandler(void)
{
	/* Enable DMA1*/ 
	DMA_DSR_BCR1 |= DMA_DSR_BCR_DONE_MASK;	// Clear Done Flag
	DMA_DSR_BCR1 |= DMA_DSR_BCR_BCR(2048);		// Set byte count register
	disable_irq(INT_DMA1 - 16);

}
