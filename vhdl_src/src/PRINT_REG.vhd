-- PRINT_REG to be used in MMIO
-- Only support byte access

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity PRINT_REG is 
	generic (addr 	: std_logic_vector);
	port (
		reset		: in std_logic;
		clk 		: in std_logic;

		-- Bus Interface
		data_in 	: in std_logic_vector (31 downto 0);
		addr_data	: in std_logic_vector (31 downto 0);
		we 			: in std_logic;
		mode		: in std_logic_vector (2 downto 0);
		data_out 	: out std_logic_vector (31 downto 0)
    );
end PRINT_REG;

architecture behavioral of PRINT_REG is

	-- Signals
	signal we_in, bg_in : std_logic; 

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (we_in = '1') then
                -- Print data write as reports
				report integer'image(to_integer(unsigned(data_in(7 downto 0)))) severity note;
			end if;
		end if;
	end process;

	-- In logic
	bg_in <= '1' when addr_data = addr else '0';
	we_in <= we and bg_in;

	-- Out logic
	data_out <= (others => 'Z');

end behavioral;