
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity RISC_SOC is 
port (
    clk : in std_logic;
    reset : in std_logic
);
end RISC_SOC;

architecture behavioral of RISC_SOC is

	component RISC is 
	port (
		clk 	: in std_logic;
		reset	: in std_logic;
		
		-- External interrupts
		ext_irq	: in std_logic;
		tim_irq : in std_logic;

		-- Fetch interface
		fetch 		: out std_logic;
		pc_fetch	: out std_logic_vector (29 downto 0);
		fetch_bus	: in std_logic_vector (31 downto 0);

		-- Mem Bus interface
		write_data	: out std_logic_vector (31 downto 0);
		addr_data	: out std_logic_vector (31 downto 0);
		bus_mode	: out std_logic_vector (2 downto 0);
		bus_we		: out std_logic;
		data_bus	: in std_logic_vector (31 downto 0)
	); 
	end component;

	component RAM_RISC is 
	port (
		reset		: in std_logic;
		clk 		: in std_logic;
		
		-- Fetch interface
		fetch		: in std_logic;
		addr_inst 	: in std_logic_vector (29 downto 0);
		inst_out 	: out std_logic_vector (31 downto 0);

		-- Mem Bus interface
		data_in 	: in std_logic_vector (31 downto 0);
		addr_data	: in std_logic_vector (31 downto 0);
		we 			: in std_logic;
		mode		: in std_logic_vector (2 downto 0);
		data_out 	: out std_logic_vector (31 downto 0)
	);
	end component;

	component IO_REG is 
	generic ( addr : std_logic_vector (31 downto 0));
	port (
		reset		: in std_logic;
		clk 		: in std_logic;

		-- Bus Interface
		data_in 	: in std_logic_vector (31 downto 0);
		addr_data	: in std_logic_vector (31 downto 0);
		we 			: in std_logic;
		mode		: in std_logic_vector (2 downto 0);
		data_out 	: out std_logic_vector (31 downto 0);
		
		-- To FPGA Interface
		fpga_out    : out std_logic_vector (31 downto 0));
	end component;

	component PRINT_REG is 
	generic (addr 	: std_logic_vector);
	port (
		reset		: in std_logic;
		clk 		: in std_logic;

		-- Bus Interface
		data_in 	: in std_logic_vector (31 downto 0);
		addr_data	: in std_logic_vector (31 downto 0);
		we 			: in std_logic;
		mode		: in std_logic_vector (2 downto 0);
		data_out 	: out std_logic_vector (31 downto 0));
    end component;

	component MTIMER_RISC is 
	generic (
		addr_mtime 	    : std_logic_vector(31 downto 0);
		addr_mtimecmp 	: std_logic_vector(31 downto 0));
	port (
		reset		: in std_logic;
		clk 		: in std_logic;
		irq         : out std_logic;

		-- Bus Interface
		data_in 	: in std_logic_vector (31 downto 0);
		addr_data	: in std_logic_vector (31 downto 0);
		we 			: in std_logic;
		mode		: in std_logic_vector (2 downto 0);
		data_out 	: out std_logic_vector (31 downto 0));
	end component;

	-- General signals
	signal IRQ : std_logic;
	
	-- Fetch Bus
	signal pc_bus : std_logic_vector(29 downto 0);
	signal instr_bus : std_logic_vector(31 downto 0);
	signal fetch_bus : std_logic;

	-- Mem Bus
	signal write_bus : std_logic_vector(31 downto 0);
	signal read_bus : std_logic_vector(31 downto 0);
	signal addr_bus : std_logic_vector(31 downto 0);
	signal mode_bus : std_logic_vector(2 downto 0);
	signal we_bus : std_logic;
	
	-- Dump signal
	signal dump_signal : std_logic_vector(31 downto 0);

begin

	-- Component Instantiation
	proc : RISC PORT MAP (
		clk => clk, 
		reset => reset,
		
		tim_irq => irq,
		ext_irq => '0',

		fetch => fetch_bus,
		pc_fetch => pc_bus,
		fetch_bus => instr_bus,

		write_data => write_bus,
		addr_data => addr_bus,
		bus_mode => mode_bus,
		bus_we => we_bus,
		data_bus => read_bus
	);

	mem : RAM_RISC PORT MAP (
		clk => clk,
		reset => reset,

		fetch => fetch_bus,
		addr_inst => pc_bus,
		inst_out => instr_bus,

		data_in => write_bus,
		addr_data => addr_bus,
		we => we_bus,
		mode => mode_bus,
		data_out => read_bus
	);

	example_io_reg : IO_REG 
	GENERIC MAP (addr => x"00080000")
	PORT MAP (
		reset => reset,
		clk => clk,

		-- Bus Interface
		data_in => write_bus,
		addr_data => addr_bus,
		we => we_bus,
		mode => mode_bus,
		data_out => read_bus,
		
		fpga_out => dump_signal
	);

	mtimer : MTIMER_RISC
	GENERIC MAP (addr_mtime => x"00050000", addr_mtimecmp => x"00050008")
	PORT MAP (
		reset => reset,
		clk => clk,
		irq => irq,

		-- Bus Interface
		data_in => write_bus,
		addr_data => addr_bus,
		we => we_bus,
		mode => mode_bus,
		data_out => read_bus
	);

	test_print : PRINT_REG
	GENERIC MAP (addr => x"00090000")
	PORT MAP (
		reset => reset,
		clk => clk,

		-- Bus Interface
		data_in => write_bus,
		addr_data => addr_bus,
		we => we_bus,
		mode => mode_bus,
		data_out => read_bus
	);

end behavioral;
