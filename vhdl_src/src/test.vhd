
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity test is end test;

architecture behavioral of test is

	component RISC_SOC is 
	port (
		clk : in std_logic;
		reset : in std_logic
	);
	end component;

	-- General signals
	signal CLK, RESET : std_logic;

	-- Clock period definitions
	-- 1 MHz
	constant CLK_period : time := 1000 ns;

begin

	-- Component Instantiation
	proc : RISC_SOC PORT MAP (
		clk => clk, 
		reset => reset
	);

	-- Clock process definitions
	CLK_process : process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;

	test_proc: process
	begin
		RESET <= '1';
		wait for CLK_period * 3/2;
		RESET <= '0';
		wait;
	end process;

end behavioral;
