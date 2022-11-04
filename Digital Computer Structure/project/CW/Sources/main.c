/*
 * main implementation: use this 'C' sample to create your own application
 *
 */


#include "derivative.h" /* include peripheral declarations */
#include "TFC.h"
#include <math.h>

extern char arr[32];
extern int k,got_name,echo_times_idx, echo_dist[8],FW_BW,angle_diff;

uint8_t state,sub_state;
struct files_struct files ={.files_num=0,.cb_pointer=0};
int one_time_flag=0,disp_file_cnt=0,target_angle=0,file_num,script_delay=50,opc=0,opr=0,opr2=0;
char circular_buffer[cb_size];
uint8_t str_num;

int main(){
	init();
	while(1){  						 //FSM
		if(state==1) radar();
		else if(state==2) telemeter();
		else if(state==3) script();
		else if(state==4) wait();	//Main menu - Sleep.
	}
	return 0;
}

void init(){
	int i;
	for(i=0;i<cb_size;i++)circular_buffer[i]='\0';
	state=4;
	InitGPIO();
	ClockSetupTPM();
	lcd_init();
	InitUARTs(9600);
	InitTPM(0);
	InitTPM(2);

	TPM0_SC |= TPM_SC_CMOD(1); //Start the TPM0 counter
	TPM2_SC |= TPM_SC_CMOD(1); //Start the TPM2 counter

	TPM0_C1V= 0x700;			//0x700= 0.6ms = 0 degree.
//	TPM0_C1V= 0x1C18;			//0x1D00= 2.5ms = 180 degree.

	InitPIT();
	PIT_MCR &= ~PIT_MCR_MDIS_MASK; //Enable the PIT module
	dma0_init();
	RGB_LED_OFF;
}

void telemeter(){
	if((state==2)&&(k==0)&&(sub_state==1)){
		PIT_MCR &= ~PIT_MCR_MDIS_MASK; //Enable the PIT module
	}
	if((state==2)&&(sub_state==2)&&(echo_times_idx==4)){
		int i,average=0;
		char str_dist[4];
		for(i=0;i<4;i++) {
			average = average + echo_dist[i];
		}
		average = average>>2;
		sprintf(str_dist,"%d",average);
		UARTprintf(UART0_BASE_PTR,str_dist);
		sub_state=0;
	}
}

void radar(){
	char vals[9]={'\0'};
	int curr_angle,prev_angle,tmp;
	PIT_MCR &= ~PIT_MCR_MDIS_MASK; //Enable the PIT module
	prev_angle = floor((TPM0_C1V-0x700)/30);
	while (state==1){
		int i,average=0;
		tmp=TPM0_C1V;
		curr_angle = floor((tmp-1792)/30);
		if((FW_BW==0)&&(curr_angle>prev_angle+2)){
			for(i=0;i<4;i++) {
				average = average + echo_dist[i];
			}
			average = average>>2;
			sprintf(vals,"%d,%d,\0",curr_angle,average);
			UARTprintf(UART0_BASE_PTR,vals);
			DelayMs(15);
			prev_angle = curr_angle;
		}
		else if((FW_BW==1)&&(curr_angle<prev_angle-2)){
			for(i=0;i<4;i++) {
				average = average + echo_dist[i];
			}
			average = average>>2;
			sprintf(vals,"%d,%d,\0",curr_angle,average);
			UARTprintf(UART0_BASE_PTR,vals);
			DelayMs(15);
			prev_angle = curr_angle;
		}
		wait();
	}
}

void script(){
	wait();
	if ((sub_state==1) &&(k==0)&&(one_time_flag == 1)){   //save name
		files.files_pointer[files.file_idx] = files.cb_pointer;
		strcpy(files.files_names[files.file_idx],arr);
		one_time_flag=0;
	}
	else if ((sub_state==2) &&(k==0)&&(one_time_flag == 1)){
		get_file();
		one_time_flag=0;
	}
	else if((sub_state==3) &&(k==0)&&(one_time_flag == 1)){
		send_scripts_list();
		one_time_flag=0;
		sub_state = 0;
	}
	else if((sub_state==4) &&(k==0)&&(one_time_flag == 1)){
		execute_script();
		one_time_flag=0;
		sub_state = 0;
	}
}

void display_files(int disp_file_cnt){
	char size[10];
	lcd_clear();
	lcd_home();
	DelayMs(15);
	lcd_puts(files.files_names[disp_file_cnt]);
	lcd_puts(" ");
	sprintf(size,"%d",files.files_size[disp_file_cnt]);
	lcd_puts(size);
	lcd_puts("B");
	lcd_cmd(0xC0);
	lcd_puts(files.files_names[(disp_file_cnt+1)%files.file_idx]);
	lcd_puts(" ");
	sprintf(size,"%d",files.files_size[(disp_file_cnt+1)%files.file_idx]);
	lcd_puts(size);
	lcd_puts("B");
}

void circular_logic(){
	int j,i=0,sum=0,new_files_num;
	files.cb_pointer = files.cb_pointer%cb_size;
	while(((files.files_pointer[i]<files.cb_pointer)||
			(files.files_pointer[i]>files.files_pointer[files.files_num-1]))
			&& (i<files.files_num-1)){
		files.valid[i]=0;
		files.files_size[i]=0;
		files.files_pointer[i]=0;
		i++;		
	}
	for(j=i;j<files.files_num;j++){
		files.files_size[j-i] = files.files_size[j];
		files.files_size[j]=0;
		files.valid[j-i] = files.valid[j];
		files.valid[j]=0;
		files.files_pointer[j-i] = files.files_pointer[j];
		files.files_pointer[j]=0;
		strcpy(files.files_names[j-i],files.files_names[j]);
	}
	new_files_num=files.files_num-i;
	for(j=files.files_num-i;j<files.files_num;j++) {
		for(i=0;i<20;i++){
			files.files_names[j][i]='\0';
		}
	}
	files.files_num=new_files_num;
}

void run_over_logic(){
	int i=0,j,new_files_num;
	while((files.files_pointer[i]<files.cb_pointer)&&
			(files.files_pointer[files.file_idx-1]<files.files_pointer[i])){
		files.valid[i]=0;
		files.files_size[i]=0;
		files.files_pointer[i]=0;
		i++;
	}
	for(j=i;j<files.file_idx;j++){
			files.files_size[j-i] = files.files_size[j];
			files.files_size[j]=0;
			files.valid[j-i] = files.valid[j];
			files.valid[j]=0;
			files.files_pointer[j-i] = files.files_pointer[j];
			files.files_pointer[j]=0;
			strcpy(files.files_names[j-i],files.files_names[j]);
		}
	new_files_num=files.file_idx-i;
		for(j=files.file_idx-i;j<files.file_idx;j++) {
			for(i=0;i<20;i++){
				files.files_names[j][i]='\0';
			}
		}
	files.file_idx=new_files_num;
}

void get_file(){
	sscanf(arr,"%d",&files.files_size[files.file_idx]);
	DMA_DSR_BCR0 = DMA_DSR_BCR_BCR(files.files_size[files.file_idx]); 
	UART0_C5 = UARTLP_C5_RDMAE_MASK | UARTLP_C5_TDMAE_MASK; // Enable Transmitter, Receiver,DMA!
	enable_irq(INT_DMA0 - 16);
	files.cb_pointer = (files.cb_pointer+files.files_size[files.file_idx]);
	if(files.files_num < 3)files.files_num++;
	files.file_idx = (files.file_idx+1)%3;
}

void send_scripts_list(){

	int i,idx;
	char files_list[60]={'\0'};
	idx = 2;
	if(files.files_num > 2){
		sprintf(files_list,"3\n");
		for(i=0;i<3;i++){
			memcpy( files_list+idx, files.files_names[i],
			strlen(files.files_names[i]));
			idx = idx+strlen(files.files_names[i]);
			files_list[idx]='\n';
			idx++;
		}
	}
		
	else {
		sprintf(files_list,"%d\n",files.file_idx);
		for(i=0;i<files.file_idx;i++){
			memcpy( files_list+idx, files.files_names[i],
			strlen(files.files_names[i]));
			idx = idx+strlen(files.files_names[i]);
			files_list[idx]='\n';
			idx++;
		}
	}
	UARTprintf(UART0_BASE_PTR,files_list);
}

void execute_script(){
	char file_num_str[1]={'\0'};
	char instruction[7]={'\0'};
	int i,curr_idx,end_idx;
	file_num_str[0]=arr[2];
	sscanf(file_num_str,"%d",&file_num);
	file_num--;
	curr_idx = files.files_pointer[file_num];
	end_idx = curr_idx + files.files_size[file_num];
	while(curr_idx<end_idx){
		for (i = 0; circular_buffer[curr_idx+i] && circular_buffer[curr_idx+i] != '\n'; ++i ) {
			instruction[i] = circular_buffer[i+curr_idx];
		}
		curr_idx = curr_idx+i+1;
		decode_instruction(instruction);
		RGB_LED_OFF;
	}
	PIT_LDVAL0 = 0x1387F; // 4ms
}

void decode_instruction(const char* instrution){
	char opcode[3]={'\0'}, operand[3]={'\0'},operand2[3]={'\0'};
	opcode[0] = instrution[0];
	opcode[1] = instrution[1];
	sscanf(opcode,"%d",&opc);
	operand[0] = instrution[2];
	operand[1] = instrution[3];
	sscanf(operand,"%2x",&opr);
	operand2[0] = instrution[4];
	operand2[1] = instrution[5];
	sscanf(operand2,"%2x",&opr2);
	PIT_LDVAL0 = 0x4E1F0 * script_delay; // 10ms = 0x4E1F0
	if(opc==1){
			PIT_MCR &= ~PIT_MCR_MDIS_MASK; //Enable the PIT module
			while (opr>0);
			PIT_MCR |= PIT_MCR_MDIS_MASK; //Disable the PIT module
			RGB_LED_OFF;
	}
	else if(opc==2)lcd_count_up();
	else if(opc==3)lcd_count_down();
	else if(opc==4)script_delay = opr;
	else if(opc==5)RGB_LED_OFF;
	else if(opc==6)servo_deg();
	else if(opc==7)servo_scan();
	else if(opc==8) wait();

}

void lcd_count_up(){
	lcd_clear();
	lcd_home();
	DelayMs(15);
	PIT_MCR &= ~PIT_MCR_MDIS_MASK; //Enable the PIT module
	while (opr>0);
	PIT_MCR |= PIT_MCR_MDIS_MASK; //Disable the PIT module
	lcd_clear();
	lcd_home();
	DelayMs(15);
	
}

void lcd_count_down(){
	lcd_clear();
	lcd_home();
	DelayMs(15);
	PIT_MCR &= ~PIT_MCR_MDIS_MASK; //Enable the PIT module
	while (opr>0);
	PIT_MCR |= PIT_MCR_MDIS_MASK; //Disable the PIT module
	lcd_clear();
	lcd_home();
	DelayMs(15);
}

void servo_deg(){
	int i,average=0;
	char str_angle_dist[8];
	UARTprintf(UART0_BASE_PTR,"op6");
	target_angle = opr;
	PIT_LDVAL0 = 0x1387F; // 4ms
	angle_diff = 10;
	PIT_MCR &= ~PIT_MCR_MDIS_MASK; //Enable the PIT module
	while(abs(angle_diff)>9);
	PIT_MCR |= PIT_MCR_MDIS_MASK; //Disable the PIT module
	PIT_LDVAL0 = 0x4E1F0 * script_delay; // 10ms = 0x4E1F0
	while (echo_times_idx!=4);
	for(i=0;i<4;i++) {
		average = average + echo_dist[i];
	}
	average = average>>2;
	sprintf(str_angle_dist,"%d,%d",target_angle,average);
	UARTprintf(UART0_BASE_PTR,str_angle_dist);
}

void servo_scan(){
	char vals[7]={'\0'};
	sprintf(vals,"op7%d",opr2);
	UARTprintf(UART0_BASE_PTR,vals);
	DelayMs(15);
	TPM0_C1V = opr*30+0x700;
	PIT_LDVAL0 = 0x1387F; // 4ms
	FW_BW=0;
	while ((arr[0] != 's')||(arr[1] != 'c')||(arr[2] != 'a')||(arr[3] != 'n') );
	state=1;
	radar();
	PIT_MCR |= PIT_MCR_MDIS_MASK; //Disable the PIT module
	PIT_LDVAL0 = 0x4E1F0 * script_delay; // 10ms = 0x4E1F0
	while ((arr[0] != '7')||(arr[1] != 'D')||(arr[2] != 'o')||(arr[3] != 'n')||(arr[4] != 'e') );

}



		
