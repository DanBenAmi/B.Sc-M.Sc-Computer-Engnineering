#-------------------- MEMORY Mapped I/O -----------------------
#define PORT_LEDG[7-0] 0x800 - LSB byte (Output Mode)
#define PORT_LEDR[7-0] 0x804 - LSB byte (Output Mode)
#define PORT_HEX0[7-0] 0x808 - LSB byte (Output Mode)
#define PORT_HEX1[7-0] 0x80C - LSB byte (Output Mode)
#define PORT_HEX2[7-0] 0x810 - LSB byte (Output Mode)
#define PORT_HEX3[7-0] 0x814 - LSB byte (Output Mode)
#define PORT_SW[7-0]   0x818 - LSB byte (Input Mode)
#define PORT_KEY[3-0]  0x81C - LSB nibble (Input Mode)
#define BTCTL          0x820 - LSB byte 
#define BTCNT          0x824 - Word 
#--------------------------------------------------------------
#define IE             0x828 - LSB byte 
#define IFG            0x82C - LSB byte
#--------------------------------------------------------------
.data 
	N:	.word 0xB71B00
	IV: 	.word KEY1_ISR
		.word KEY2_ISR
		.word KEY3_ISR
		.word BT_ISR
.text
	addi $sp,$zero,0x400 # $sp=0x400
	addi $t0,$zero,0x39  
	sw   $t0,0x820       # BTIP=7, BTSSEL=3, BTHOLD=1
	sw   $0,0x824        # BTCNT=0
	sw   $0,0x828        # IE=0
	sw   $0,0x82C        # IFG=0
	addi $t0,$zero,0x19  
	sw   $t0,0x820       # BTIP=7, BTSSEL=3, BTHOLD=0
	addi $t0,$zero,0x0F 
	sw   $t0,0x828        # IE=0x0F
	ori  $k0,$k0,0x01     # $k0[0] uses as GIE
	
	lw   $t0,0x818 # read the state of PORT_SW[7-0]
L:	j    L
	
KEY1_ISR:
	sw   $t0,0x800 # write to PORT_LEDG[7-0]
	sw   $t0,0x804 # write to PORT_LEDR[7-0]
	
	lw   $t1,0x82C # read IFG
	andi $t1,$t1,0xFFFE 
	sw   $t1,0x82C # clr KEY2IFG
	jr   $ra # reti
	
KEY2_ISR:
	sw   $t0,0x808 # write to PORT_HEX0[7-0]
	sw   $t0,0x80C # write to PORT_HEX1[7-0]
	
	lw   $t1,0x82C # read IFG
	andi $t1,$t1,0xFFFD 
	sw   $t1,0x82C # clr KEY2IFG
	jr   $ra # reti

KEY3_ISR:
	sw   $t0,0x810 # write to PORT_HEX2[7-0]
	sw   $t0,0x814 # write to PORT_HEX3[7-0]
	
	lw   $t1,0x82C # read IFG
	andi $t1,$t1,0xFFFB 
	sw   $t1,0x82C # clr KEY3IFG
	jr   $ra # reti
		
BT_ISR:	addi $t0,$t0,1  # $t1=$t1+1
	sw   $t0,0x800 # write to PORT_LEDG[7-0]
	
	lw   $t1,0x82C # read IFG
	andi $t1,$t1,0xFFF7 
	sw   $t1,0x82C # clr BTIFG
        jr   $ra # reti
         
