LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;

ENTITY interrupt IS
	generic(
		AddressWidth : integer := 9;
		DataWidth : integer := 10
	);
	PORT(	Opcode 		: IN 	STD_LOGIC_VECTOR( 5 DOWNTO 0 );
			ALU_Result 	: IN	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			Read_data_2 : IN 	STD_LOGIC_VECTOR( 31 DOWNTO 0 );
			MemRead     : IN 	STD_LOGIC;
			MemWrite 	: IN 	STD_LOGIC;
			inta, key1, key2,key3 : in std_logic;
        	clock, reset,GIE 	: IN 	STD_LOGIC;
			intr			: out std_logic;
			int_vec_add			: out STD_LOGIC_VECTOR( AddressWidth DOWNTO 0 )
			);
			
END interrupt;

ARCHITECTURE struct OF interrupt IS	
signal IFG,IE,I_TYPE,tmp : std_logic_vector (7 downto 0) := "00000000";
signal BTCTL	   		: std_logic_vector (7 downto 0);
signal BTIFG, selected_clk,BTHOLD	 : STD_LOGIC;
signal clock0,clock1,clock2,clock3 : STD_LOGIC := '0';
signal BTCNT,ones : std_logic_vector (31 downto 0);
signal BTSSEL : std_logic_vector (1 downto 0);
signal BTIP : std_logic_vector (2 downto 0);
signal clk_cnt : std_logic_vector (2 downto 0) := "000";

BEGIN
	BTSSEL <= BTCTL(4 downto 3);
	clock0 <= clock;
	clock1 <= clk_cnt(0);
	clock2 <= clk_cnt(1);
	clock3 <= clk_cnt(2);

	selected_clk <= clock0 when BTSSEL = "00" else
					clock1 when BTSSEL = "01" else
					clock2 when BTSSEL = "10" else
					clock3;

	BTHOLD <= BTCTL(5);
	BTIP <= BTCTL(2 downto 0);
	ones <= (others => '1');
	BTIFG <= '1' when BTIP = "000" else
			'1' when BTIP = "001" and (BTCNT(2 downto 0) = ones (2 downto 0)) else
			'1' when BTIP = "010" and (BTCNT(6 downto 0) = ones (6 downto 0)) else
			'1' when BTIP = "011" and (BTCNT(10 downto 0) = ones (10 downto 0)) else
			'1' when BTIP = "100" and (BTCNT(14 downto 0) = ones (14 downto 0)) else
			'1' when BTIP = "101" and (BTCNT(18 downto 0) = ones (18 downto 0)) else
			'1' when BTIP = "110" and (BTCNT(22 downto 0) = ones (22 downto 0)) else
			'1' when BTIP = "111" and (BTCNT(24 downto 0) = ones (24 downto 0)) else
			BTCNT(31);
	
	tmp <= I_TYPE + 4;
	
	modelsim : if (AddressWidth = 7) generate
		begin
			int_vec_add <= tmp;
		end generate;
		
	quartus : if (AddressWidth = 9) generate
		begin
			int_vec_add <= "00"&tmp;
		end generate;
		
	intr <= GIE and ((IFG(0) and IE(0)) or
					(IFG(1) and IE(1)) or
				    (IFG(2) and IE(2)) or
					(IFG(3) and IE(3)));
			
	
	process(clock,selected_clk)
	begin
		if (clock'event and clock='1') then
			if reset = '1' then
				clk_cnt <= "000";
			else
				clk_cnt <= clk_cnt + 1;
			end if;
		end if;
	
		if (clock'event and clock='1') then
			if reset = '1' then
				BTCTL <= (others => '0');
			elsif (ALU_Result = X"00000820" and Opcode = "101011" and MemWrite='1') then
				BTCTL <= Read_data_2(7 downto 0);
			end if;
		end if;
		
		if (selected_clk'event and selected_clk='1') then
			if reset = '1' then
				BTCNT <= (others => '0');
			elsif (ALU_Result = X"00000824" and Opcode = "101011" and MemWrite='1') then
				BTCNT <= Read_data_2;
			elsif BTIFG ='1' then
				BTCNT <= (others => '0');
			elsif BTHOLD = '0' then 
				BTCNT <= BTCNT + 1;
			end if;
		end if;
		
		if (clock'event and clock='1') then
			if reset = '1' then
				IE <= (others => '0');
			elsif (ALU_Result = X"00000828" and Opcode = "101011" and MemWrite='1') then 
				IE <= Read_data_2(7 downto 0);
			end if;
		end if;
	
		if (clock'event and clock='1') then
			if reset = '1' then
				I_TYPE <= (others => '0');
			elsif BTIFG = '1' then
				I_TYPE(3 downto 0) <= "1100";
			elsif not(key3) = '1' then
				I_TYPE(3 downto 0) <= "1000";
			elsif not(key2) = '1' then
				I_TYPE(3 downto 0) <= "0100";
			else 
				I_TYPE (3 downto 0) <= "0000";
			end if;
		end if;
		
		if (clock'event and clock='1') then
			if reset = '1' then
				IFG <= (others => '0');
			elsif (ALU_Result = X"0000082C" and Opcode = "101011" and MemWrite='1') then 
				IFG <= Read_data_2(7 downto 0);
			elsif not(key1) = '1' then
				IFG(0) <= '1';
			elsif not(key2) = '1' then
				IFG(1) <= '1';
			elsif not(key3) = '1' then
				IFG(2) <= '1';
			elsif BTIFG = '1' and not(I_TYPE="1100" and inta = '1') then
				IFG(3) <= '1';
			else 
				IFG(3) <= '0';
			end if;
		end if;
	end process;								

END struct;





	
	


