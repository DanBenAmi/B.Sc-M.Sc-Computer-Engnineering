-- Ifetch module (provides the PC and instruction 
--memory for the MIPS computer)
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY Ifetch IS
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
			
END Ifetch;

ARCHITECTURE behavior OF Ifetch IS
	component dmemory IS
	generic(
		AddressWidth : integer := 9;
		DataWidth : integer := 10
	);
	PORT(	read_data 			: OUT 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
        	address 			: IN 	STD_LOGIC_VECTOR( AddressWidth DOWNTO 0 );				
        	write_data 			: IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	   		MemRead, Memwrite 	: IN 	STD_LOGIC;
            clock,reset			: IN 	STD_LOGIC );
	END component;
	
	SIGNAL PC, PC_plus_4 : STD_LOGIC_VECTOR( 9 DOWNTO 0 );
	SIGNAL Mem_Addr,int_vec_tmp : STD_LOGIC_VECTOR( AddressWidth DOWNTO 0 );
	signal vec_isr,Instruction_memory	: STD_LOGIC_VECTOR( 31 DOWNTO 0 );
	SIGNAL next_PC 			: STD_LOGIC_VECTOR( 7 DOWNTO 0 );
	
BEGIN
						--ROM for Instruction Memory
inst_memory: altsyncram
	
	GENERIC MAP (
		operation_mode => "ROM",
		width_a => 32,
		widthad_a => DataWidth,											
		lpm_type => "altsyncram",
		outdata_reg_a => "UNREGISTERED",
		init_file => "program.hex",
		intended_device_family => "Cyclone"
	)
	PORT MAP (
		clock0     => clock,
		address_a 	=> Mem_Addr, 
		q_a 			=> Instruction_memory );
					-- Instructions always start on word address - not byte
	PC(1 DOWNTO 0) <= "00";
				-- copy output signals - allows read inside module
	PC_plus_4_out 	<= PC_plus_4;
		
				-- Adder to increment PC by 4        
	PC_plus_4( 9 DOWNTO 2 )  <= PC( 9 DOWNTO 2 ) + 1;
	PC_plus_4( 1 DOWNTO 0 )  <= "00";
					-- Mux to select Branch Address or PC + 4        
	Next_PC  <= X"00"
				WHEN Reset = '1' ELSE
				Add_result  WHEN (( ( Beq = '1' ) AND ( Zero = '1' ) ) or
				( ( Bne = '1' ) AND ( Zero = '0' ) )) else							-----------bne,beq
				Instruction( 7 DOWNTO 0 ) when (jump='1' or jal='1') else	    -----------jal      	-----------jump
				"00"&read_data_1(7 downto 2) when jr='1' else					-----------jr
				PC_plus_4( 9 DOWNTO 2 );
					-- send address to inst. memory address register
	modelsim : if (AddressWidth = 7) generate
		begin
			Mem_Addr <= Next_PC;
		end generate;
		
	quartus : if (AddressWidth = 9) generate
		begin
			Mem_Addr <= Next_PC & "00";
		end generate;
	PROCESS
		BEGIN
			WAIT UNTIL ( clock'EVENT ) AND ( clock = '1' );
			IF reset = '1' THEN
				   PC( 9 DOWNTO 2) <= "00000000" ; 
			ELSE 
				   PC( 9 DOWNTO 2 ) <= next_PC;
			END IF;
	END PROCESS;
	
	modelsim1 : if (AddressWidth = 7) generate
		begin
			int_vec_tmp <= "00"&int_vec_add(7 downto 2);
		end generate;
		
	quartus1 : if (AddressWidth = 9) generate
		begin
			int_vec_tmp <= int_vec_add;
		end generate;
		
	INT1: dmemory
		generic map(
		AddressWidth,DataWidth)
	PORT map(vec_isr,int_vec_tmp,X"00000000",'1','0',clock,reset);
	
	instruction <= "00001100"&vec_isr( 25 downto 2) when (intr = '1' and inta = '0') else Instruction_memory;

	process(clock)
	begin
		if (clock'event and clock='1') then
			if (inta = '1' and jr = '1' and intr = '0') then 
				inta <= '0';
			elsif (intr = '1' and inta = '0') then
				inta <= '1';
			else
				inta <= inta;
			end if;
		end if;
	end process;
	
	
	
END behavior;


