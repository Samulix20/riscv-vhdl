--32 bit interger MULDIV unit

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

-- mul      : "000"
-- mulh     : "001"
-- mulhsu   : "010"
-- mulhu    : "011"
-- div      : "100"
-- divu     : "101"
-- rem      : "110"
-- remu     : "111"

entity MULDIV_RISC is 
port (
	op1     : in std_logic_vector(31 downto 0);
	op2     : in std_logic_vector(31 downto 0);
	mode    : in std_logic_vector(2 downto 0);
	res     : out std_logic_vector(31 downto 0));
end MULDIV_RISC;

architecture behavioral of MULDIV_RISC is

    signal smul, umul : std_logic_vector(63 downto 0);
    signal sumul_op1, sumul_op2 : std_logic_vector(32 downto 0);
    signal sumul : std_logic_vector(65 downto 0);
    signal fixed_op2, s_div, s_divu, s_rem, s_remu : std_logic_vector(31 downto 0);

begin

    smul <= std_logic_vector(signed(op1) * signed(op2));
    umul <= std_logic_vector(unsigned(op1) * unsigned(op2));

    -- Signed x Unsigned multiplication
    -- Signed extension to 33 bits
    sumul_op1(31 downto 0) <= op1;
    sumul_op1(32) <= op1(31);
    -- Unsigned extension to 33 bits
    sumul_op2(31 downto 0) <= op2;
    sumul_op2(32) <= '0';
    -- 33 bits multiplication, ignore 66-65 bits of the result
    sumul <= std_logic_vector(signed(sumul_op1) * signed(sumul_op2));

    -- Avoid vhdl exception not dividing by 0
    fixed_op2 <= op2 when unsigned(op2) /= 0 else std_logic_vector(to_unsigned(1, 32));
    -- Division by 0 RISCV ISA expected results
    s_div <= std_logic_vector(signed(op1) / signed(fixed_op2)) when unsigned(op2) /= 0 else std_logic_vector(to_signed(-1, 32));
    s_divu <= std_logic_vector(unsigned(op1) / unsigned(fixed_op2)) when unsigned(op2) /= 0 else (others => '1');
    s_rem <= std_logic_vector(signed(op1) rem signed(fixed_op2)) when unsigned(op2) /= 0 else op1;
    s_remu <= std_logic_vector(unsigned(op1) rem unsigned(fixed_op2)) when unsigned(op2) /= 0 else op1;

    res <=  smul(31 downto 0) when mode = "000"
    else    smul(63 downto 32) when mode = "001"
    else    sumul(63 downto 32) when mode = "010"
    else    umul(63 downto 32) when mode = "011"
    else    s_div when mode = "100"
    else    s_divu when mode = "101"
    else    s_rem when mode = "110"
    else    s_remu when mode = "111";

end behavioral;

