		-- control module (implements MIPS control unit)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY decoder IS
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
	);

END decoder;

ARCHITECTURE struct OF decoder IS
	component seven_seg is
		port(
			nibel : in std_logic_vector(3 downto 0);
			----------------------------------------
			LED_out : out std_logic_vector(6 downto 0)
		);
	end component;
signal d0, d1, d2, d3 : std_logic_vector (6 downto 0);
BEGIN
	DMemRead <= '0' when ALU_Result >= X"000000"&"1000"&X"00" 		-----------if address grater then 0x800 then gpio else data memory
				else MemRead;
	DMemWrite <= '0' when ALU_Result  >=  X"000000"&"1000"&X"00"  
				else MemWrite;
	read_data <= X"000000"&Switches;
	g1: seven_seg port map(Read_data_2(3 downto 0),d0);
	g2: seven_seg port map(Read_data_2(3 downto 0),d1);
	g3: seven_seg port map(Read_data_2(3 downto 0),d2);
	g4: seven_seg port map(Read_data_2(3 downto 0),d3);
	process(clock)
	begin
		if (clock'event and clock='1') then
			if (ALU_Result = X"00000"&"100000000000" and Opcode = "101011" and MemWrite='1') then 
				LEDSG <= Read_data_2(7 downto 0);
			end if;
		end if;
		
		if (clock'event and clock='1') then
			if (ALU_Result = X"00000"&"100000000100" and Opcode = "101011" and MemWrite='1') then 
				LEDSR <= Read_data_2(7 downto 0);
			end if;
		end if;
		
		if (clock'event and clock='1') then
			if (ALU_Result = X"00000"&"100000001000" and Opcode = "101011" and MemWrite='1') then 
				digit0 <= d0;
			end if;
		end if;
		
		if (clock'event and clock='1') then
			if (ALU_Result = X"00000"&"100000001100" and Opcode = "101011" and MemWrite='1') then 
				digit1 <= d1;
			end if;
		end if;
		
		if (clock'event and clock='1') then
			if (ALU_Result = X"00000"&"100000010000" and Opcode = "101011" and MemWrite='1') then 
				digit2 <= d2;
			end if;
		end if;
		
		if (clock'event and clock='1') then
			if (ALU_Result = X"00000"&"100000010100" and Opcode = "101011" and MemWrite='1')  then 
				digit3 <= d3;
			end if;
		end if;
	end process;								

END struct;


