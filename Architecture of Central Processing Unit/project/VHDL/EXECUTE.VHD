--  Execute module (implements the data ALU and Branch Address Adder  
--  for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY  Execute IS
	PORT(	Read_data_1 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Sign_extend 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Function_opcode : IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALUOp 			: IN 	STD_LOGIC_VECTOR( 1 DOWNTO 0 );
			ALUSrc 			: IN 	STD_LOGIC;
			Zero 			: OUT	STD_LOGIC;
			ALU_Result 		: OUT	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Add_Result 		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			PC_plus_4 		: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
			i_format,clock, reset	: IN 	STD_LOGIC );						-----------------i-format
END Execute;

ARCHITECTURE behavior OF Execute IS
SIGNAL Ainput, Binput 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL ALU_output_mux		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
SIGNAL Branch_Add 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
SIGNAL ALU_ctl,ALU_ctl_final	: STD_LOGIC_VECTOR( 2 DOWNTO 0 );
SIGNAL Sll_flag				: STD_LOGIC;						  ------------ Sll
BEGIN
	Ainput <= Read_data_1;
						-- ALU input mux
	Binput <= Read_data_2 
		WHEN ( ALUSrc = '0' ) 
  		ELSE  Sign_extend( 31 DOWNTO 0 );
	
						-- Generate ALU control bits
	ALU_ctl( 0 ) <= ( Function_opcode( 0 ) OR Function_opcode( 3 ) ) AND ALUOp(1 );
	ALU_ctl( 1 ) <= ( NOT Function_opcode( 2 ) ) OR (NOT ALUOp( 1 ) );
	ALU_ctl( 2 ) <= ( Function_opcode( 1 ) AND ALUOp( 1 )) OR ALUOp( 0 );
	---------------------shift and immediate-------------------------
	ALU_ctl_final <= "011" when (Function_opcode="000000" and ALUOp(1)='1') else		----------- SLL
			   "101" when (Function_opcode="000010" and ALUOp(1)='1') else		----------- SRL
			   "010" when i_format='1' and ALUOp="00" else 	----------- addi
			   "000" when i_format='1' and ALUOp="01" else 	----------- andi
			   "001" when i_format='1' and ALUOp="10" else 	----------- ori
			   "100" when i_format='1' and ALUOp="11" else 	----------- xori
			   ALU_ctl;
			   
			   
			   
	Zero <= '1' 
		WHEN ( ALU_output_mux( 31 DOWNTO 0 ) = X"00000000"  )
		ELSE '0';    
						-- Select ALU output        
	ALU_result <= X"0000000" & B"000"  & ALU_output_mux( 31 ) 
		WHEN  ALU_ctl = "111" 
		ELSE  	ALU_output_mux( 31 DOWNTO 0 );
						-- Adder to compute Branch Address
	Branch_Add	<= PC_plus_4( 9 DOWNTO 2 ) +  Sign_extend( 7 DOWNTO 0 ) ;
	Add_result 	<= Branch_Add( 7 DOWNTO 0 );

PROCESS ( ALU_ctl_final, Ainput, Binput )
	BEGIN
					-- Select ALU operation
 	CASE ALU_ctl_final IS
						-- ALU performs ALUresult = A_input AND B_input
		WHEN "000" 	 =>	ALU_output_mux 	<= Ainput AND Binput; 
						-- ALU performs ALUresult = A_input OR B_input
     	WHEN "001" 	=>	ALU_output_mux 	<= Ainput OR Binput;
						-- ALU performs ALUresult = A_input + B_input
	 	WHEN "010" 	=>	ALU_output_mux 	<= Ainput + Binput;
						-- ALU performs ALUresult = A_input SLL B_input
 	 	WHEN "011" 	=>	ALU_output_mux <=  To_StdLogicVector(to_bitvector(Binput) sll CONV_INTEGER(unsigned(Sign_extend(10 downto 6)))); ----------- SLL
						-- ALU performs ALUresult = A_input xor B_input
 	 	WHEN "100" 	=>	ALU_output_mux 	<= Ainput xor Binput; 								------------ xor
						-- ALU performs  ALUresult = A_input SRL B_inputs
 	 	WHEN "101" 	=>	ALU_output_mux 	<= To_StdLogicVector(to_bitvector(Binput) srl CONV_INTEGER(unsigned(Sign_extend(10 downto 6)))); ----------- SRL
						-- ALU performs ALUresult = A_input -B_input
 	 	WHEN "110" 	=>	ALU_output_mux 	<= Ainput - Binput;
						-- ALU performs SLT
  	 	WHEN "111" 	=>	ALU_output_mux 	<= Ainput - Binput ;
 	 	WHEN OTHERS	=>	ALU_output_mux 	<= X"00000000" ;
  	END CASE;
  END PROCESS;
END behavior;

