		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY control IS
   PORT( 	
	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	Function_opcode : IN STD_LOGIC_VECTOR( 5 DOWNTO 0 ); --------------Sll
	RegDst 		: OUT 	STD_LOGIC;
	ALUSrc 		: OUT 	STD_LOGIC;
	MemtoReg 	: OUT 	STD_LOGIC;
	RegWrite 	: OUT 	STD_LOGIC;
	MemRead     : OUT 	STD_LOGIC;
	MemWrite 	: OUT 	STD_LOGIC;			
	Beq ,Bne 	: buffer STD_LOGIC;							---------------bne,beq
	Jump 		: OUT  	STD_LOGIC; 							-----------------------Jump
	ALUop 		: OUT 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
	jal			: buffer  	STD_LOGIC;							----------------------jal
	jr			: OUT  	STD_LOGIC; 								-----------------------jr
	i_format    : buffer  	STD_LOGIC; 							-----------------i-format
	clock, reset	: IN 	STD_LOGIC );

END control;

ARCHITECTURE behavior OF control IS

	SIGNAL  R_format, Lw, Sw,ori,addi,andi,xori 	: STD_LOGIC;

BEGIN           
				-- Code to generate control signals using opcode bits
	R_format 	<=  '1'  WHEN  Opcode = "000000"  ELSE '0';
	Lw          <=  '1'  WHEN  Opcode = "100011"  ELSE '0';
 	Sw          <=  '1'  WHEN  Opcode = "101011"  ELSE '0';
	ori			<=  '1'  WHEN  Opcode = "001101"  ELSE '0';
	addi		<=  '1'  WHEN  Opcode = "001000"  ELSE '0';
	andi		<=  '1'  WHEN  Opcode = "001100"  ELSE '0';
	xori		<=  '1'  WHEN  Opcode = "001110"  ELSE '0';
	jal			<=  '1'  WHEN  Opcode = "000011"  ELSE '0';				------------jal
	jr			<=  '1'  WHEN (Opcode = "000000" and Function_opcode="01000")  ELSE '0';			--------jr
	i_format    <=  '1'  WHEN  (addi or ori or xori or andi)='1' ELSE '0';		 ------------i_format
  	RegDst    	<=  R_format;
 	ALUSrc  	<=  Lw OR Sw or i_format;   ------------i_format
	MemtoReg 	<=  Lw;
  	RegWrite 	<=  R_format OR Lw or i_format or jal;	 ------------i_format 	--------------jal
  	MemRead 	<=  Lw;
   	MemWrite 	<=  Sw; 
 	Beq         <=  '1'  WHEN  Opcode = "000100" ELSE '0'; -------------BEQ
	Bne			<=  '1'  when  Opcode = "000101" ELSE '0'; -------------BNE
	ALUOp( 1 ) 	<=  R_format or ori or xori;  				-------- 00=addi , 01=andi, 10=ori ,11=xori
	ALUOp( 0 ) 	<=  Beq or Bne or andi or xori; 
	Jump        <=  '1'  WHEN  Opcode = "000010"  ELSE '0';					---------------------Jump		
   END behavior;


