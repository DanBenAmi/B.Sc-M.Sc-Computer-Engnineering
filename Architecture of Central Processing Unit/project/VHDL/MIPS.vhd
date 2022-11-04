				-- Top Level Structural Model for MIPS Processor Core
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY MIPS IS

	generic(
		AddressWidth : integer := 9;
		DataWidth : integer := 10
	);

	PORT( key0,key1, key2,key3,clock	: IN 	STD_LOGIC; 					---------quartus key0
		-- Output important signals to pins for easy display in Simulator
		PC								: OUT  STD_LOGIC_VECTOR( 9 DOWNTO 0 );
		ALU_result_out, read_data_1_out, read_data_2_out, write_data_out,	
     	Instruction_out					: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
		Branch_out, Zero_out, Memwrite_out, 
		Regwrite_out					: OUT 	STD_LOGIC ;
		----------------------------------------------------------------------------
		Switches						: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );		    -----------decoder	-----------decoder
		LEDSG	 						: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
		LEDSR							: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );		
		digit0,digit1,digit2,digit3		: OUT std_logic_vector (6 downto 0)   		       -----------decoder
		);
	END MIPS;

ARCHITECTURE structure OF MIPS IS

	COMPONENT Ifetch IS
	generic(
		AddressWidth : integer := 9;
		DataWidth : integer := 10
	);
	PORT(	SIGNAL Instruction 		: buffer	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			SIGNAL jump				: IN	STD_LOGIC;							------------Jump
        	SIGNAL PC_plus_4_out 	: OUT	STD_LOGIC_VECTOR( 9 DOWNTO 0 );
        	SIGNAL Add_result 		: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
        	SIGNAL Beq ,Bne			: IN 	STD_LOGIC;
        	SIGNAL Zero 			: IN 	STD_LOGIC;
			signal jal,jr		    : in 	std_logic;					------------jal		-------jr
			signal read_data_1		: in 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );		---------------jr
        	SIGNAL clock, reset,intr	: IN 	STD_LOGIC;
			signal int_vec_add		: in STD_LOGIC_VECTOR( AddressWidth DOWNTO 0 );
			SIGNAL inta 			: buffer	STD_LOGIC := '0');
			
	END COMPONENT; 

	COMPONENT Idecode IS
	  PORT(	read_data_1	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data_2	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Instruction : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			read_data 	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			ALU_result	: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			RegWrite 	: IN 	STD_LOGIC;
			MemtoReg 	: IN 	STD_LOGIC;
			RegDst 		: IN 	STD_LOGIC;
			Sign_extend : OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			jal,intr	: in  	STD_LOGIC;							----------------------jal
			GIE			: OUT 	STD_LOGIC;
			PC_plus_4 	: in	STD_LOGIC_VECTOR( 9 DOWNTO 0 );			-------------jal
			clock,reset	: IN 	STD_LOGIC );
	END COMPONENT;

	COMPONENT control IS
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

	END COMPONENT;

	COMPONENT  Execute
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
			i_format,clock, reset	: IN 	STD_LOGIC );						------------i_format
	END COMPONENT;
	
	COMPONENT decoder IS														------------ decoder------------ decoder
   PORT( 	
	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
	ALU_Result 	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	Switches	: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	Read_data_2 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	MemRead     : IN 	STD_LOGIC;
	MemWrite 	: IN 	STD_LOGIC;
	clock		: IN 	STD_LOGIC;
	DMemRead    : OUT 	STD_LOGIC;
	DMemWrite 	: OUT 	STD_LOGIC;
	read_data 	: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	LEDSG	 	: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	LEDSR		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	digit0,digit1,digit2,digit3: OUT std_logic_vector (6 downto 0)
	);																							------------ decoder

	END COMPONENT;


	COMPONENT dmemory
	generic(
		AddressWidth : integer := 9;
		DataWidth : integer := 10
	);
	     PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		address 			: IN 	STD_LOGIC_VECTOR( 9 DOWNTO 0 ); 			
        		write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        		MemRead, Memwrite 	: IN 	STD_LOGIC;
        		Clock,reset			: IN 	STD_LOGIC );
	END COMPONENT;
	
	component interrupt IS
	generic(
		AddressWidth : integer := 9;
		DataWidth : integer := 10
	);
	PORT(	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALU_Result 	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemRead     : IN 	STD_LOGIC;
			MemWrite 	: IN 	STD_LOGIC;
			inta, key1, key2,key3,GIE : in std_logic;
        	clock, reset 	: IN 	STD_LOGIC;
			intr			: out std_logic;
			int_vec_add			: out STD_LOGIC_VECTOR( AddressWidth DOWNTO 0 )
			);
			
	END component;

					-- declare signals used to connect VHDL components
	SIGNAL PC_plus_4		: STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL address_shifted 		: STD_LOGIC_VECTOR( AddressWidth DOWNTO 0 );		-------------address_shifted	
	SIGNAL read_data_1 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL read_data_2 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL Sign_Extend,Sign_extend_jump : STD_LOGIC_VECTOR( 31 DOWNTO 0 );      ----------Jump		--------jr
	SIGNAL jump,reset,jr				: STD_LOGIC;							------jr		---------quartus key0									----------Jump
	SIGNAL Add_result 		: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	SIGNAL ALU_result		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );			
	SIGNAL read_data,read_data_switches,read_data_memory 		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );		------------ decoder
	SIGNAL ALUSrc ,i_format	: STD_LOGIC;							----------i_format
	SIGNAL Beq ,Bne,jal		: STD_LOGIC;
	SIGNAL RegDst 			: STD_LOGIC;
	SIGNAL Regwrite 		: STD_LOGIC;
	SIGNAL Zero 			: STD_LOGIC;
	SIGNAL MemWrite, DMemWrite		: STD_LOGIC;					------------ decoder
	SIGNAL MemtoReg 		: STD_LOGIC;
	SIGNAL MemRead, DMemRead 			: STD_LOGIC;				------------ decoder
	SIGNAL ALUop 			: STD_LOGIC_VECTOR(  1 DOWNTO 0 );
	SIGNAL Instruction		: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL inta			    : std_logic;
	SIGNAL intr, GIE			: std_logic;
	SIGNAL int_vec_add		: STD_LOGIC_VECTOR( AddressWidth DOWNTO 0 );
	SIGNAL ra 			: STD_LOGIC_VECTOR( 9 DOWNTO 0 );

BEGIN
					-- copy important signals to output pins for easy 
					-- display in Simulator
   Instruction_out 	<= Instruction;
   ALU_result_out 	<= ALU_result;
   read_data_1_out 	<= read_data_1;
   read_data_2_out 	<= read_data_2;
   write_data_out  	<= read_data WHEN MemtoReg = '1' ELSE ALU_result;
   Branch_out 		<= Beq;
   Zero_out 		<= Zero;
   reset			<= not(key0);									---------quartus key0
   RegWrite_out 	<= RegWrite;
   MemWrite_out 	<= MemWrite;	
					-- connect the 5 MIPS components   
  IFE : Ifetch
  generic map(AddressWidth,DataWidth)
	PORT MAP (	Instruction 	=> Instruction,
				Jump			=> Jump,						---------------------------Jump
    	    	PC_plus_4_out 	=> PC_plus_4,
				Add_result 		=> Add_result,
				Beq   	    	=> Beq,
				Bne				=> Bne,
				Zero 			=> Zero, 
				jal				=> jal, 				------------jal
				jr				=> jr,							----------------------jr
				read_data_1 	=> read_data_1,			------------jr
				clock 			=> clock,  
				reset 			=> reset,
				intr			=> intr,
				int_vec_add		=> int_vec_add,
				inta			=> inta);

   ID : Idecode
   	PORT MAP (	read_data_1 	=> read_data_1,
        		read_data_2 	=> read_data_2,
        		Instruction 	=> Instruction,
        		read_data 		=> read_data,
				ALU_result 		=> ALU_result,
				RegWrite 		=> RegWrite,
				MemtoReg 		=> MemtoReg,
				RegDst 			=> RegDst,
				Sign_extend 	=> Sign_extend,
				jal				=> jal,									------------jal
				intr			=> intr,
				GIE				=> GIE,
				PC_plus_4		=> PC_plus_4,							------------jal
        		clock 			=> clock,  
				reset 			=> reset );


   CTL:   control
	PORT MAP ( 	Opcode 			=> Instruction( 31 DOWNTO 26 ),
				Function_opcode => Instruction( 5 DOWNTO 0 ), 			-------------Sll
				RegDst 			=> RegDst,
				ALUSrc 			=> ALUSrc,
				MemtoReg 		=> MemtoReg,
				RegWrite 		=> RegWrite,
				MemRead 		=> MemRead,
				MemWrite 		=> MemWrite,
				Beq   	    	=> Beq,
				Bne				=> Bne,
				Jump			=> Jump,						---------------------------Jump
				ALUop 			=> ALUop,
				jal				=> jal,							----------------------jal
				jr				=> jr,							----------------------jr
				i_format		=> i_format,
                clock 			=> clock,
				reset 			=> reset );

   EXE:  Execute
   	PORT MAP (	Read_data_1 	=> read_data_1,
             	Read_data_2 	=> read_data_2,
				Sign_extend 	=> Sign_extend,
                Function_opcode	=> Instruction( 5 DOWNTO 0 ),
				ALUOp 			=> ALUop,
				ALUSrc 			=> ALUSrc,
				Zero 			=> Zero,
                ALU_Result		=> ALU_Result,
				Add_Result 		=> Add_Result,
				PC_plus_4		=> PC_plus_4,
				i_format		=> i_format,
                Clock			=> clock,
				Reset			=> reset );

   DEC: decoder																------------ decoder ------------ decoder
	PORT MAP(	Opcode			=> Instruction( 31 DOWNTO 26 ),			------------ decoder
				ALU_Result		=> ALU_Result,							------------ decoder
				Switches		=> Switches,
				Read_data_2		=> read_data_2,
				MemRead			=> MemRead,
				MemWrite		=> MemWrite,
				DMemRead		=> DMemRead,
				DMemWrite		=> DMemWrite,
				clock			=> clock,
				read_data		=> read_data_switches,
				LEDSG			=> LEDSG,
				LEDSR			=> LEDSR,
				digit0			=> digit0,
				digit1			=> digit1,
				digit2			=> digit2,
				digit3			=> digit3 );								------------ decoder
				
	read_data <= read_data_switches when (ALU_Result = X"00000"&"100000011000" and MemRead='1') else read_data_memory ;		------------ decoder
	address_shifted <= ALU_Result(9 DOWNTO 2)&"00" when AddressWidth=9 else ALU_Result(9 DOWNTO 2);							--jump memory address by 4
   MEM:  dmemory
   generic map(AddressWidth,DataWidth)
	PORT MAP (	read_data 		=> read_data_memory,											-----------decoder
				address 		=> address_shifted,--jump memory address by 4
				write_data 		=> read_data_2,
				MemRead 		=> DMemRead, 
				Memwrite 		=> DMemWrite, 
                clock 			=> clock,  
				reset 			=> reset );
				
	INT : interrupt
	   generic map(AddressWidth,DataWidth)
		PORT MAP ( Opcode 		=> Instruction( 31 DOWNTO 26 ),
					ALU_Result 	=> ALU_Result,
					Read_data_2 => Read_data_2,
					MemRead     => MemRead,
					MemWrite 	=> MemWrite,
					inta		=> inta,
					key1		=> key1,
					key2		=> key2,
					key3 		=> key3,
					GIE			=> GIE,
					clock		=> clock,
					reset		=> reset,
					intr		=> intr,
					int_vec_add	=> int_vec_add);
END structure;

