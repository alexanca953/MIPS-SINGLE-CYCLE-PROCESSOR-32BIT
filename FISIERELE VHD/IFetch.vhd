----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2025 04:31:36 PM
-- Design Name: 
-- Module Name: IFetch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFetch is
Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           jump : in std_Logic;
           jumpadress : in STD_LOGIC_VECTOR (31 downto 0);
           pcsrc : in std_logic;
           branchadress : in STD_LOGIC_VECTOR (31 downto 0);
           pc4 : out STD_LOGIC_VECTOR (31 downto 0);
           instruction : out STD_LOGIC_VECTOR (31 downto 0));
end IFetch;

architecture Behavioral of IFetch is
signal d:std_logic_vector(31 downto 0);
signal q:std_logic_vector(31 downto 0):=X"00000000";
signal outmux1:std_logic_vector(31 downto 0);
signal outrom:std_logic_vector(31 downto 0);
type rom is array(0 to 31) of std_logic_vector(31 downto 0);
signal rom2:rom:=(
B"100011_00000_01000_0000_0000_0000_0100", -- X"8C080004", 01: LW $t0, 4($zero)        ; $t0 = N
B"001000_00000_01001_0000_0000_0000_0000", -- X"20090000", 02: ADDI $t1, $zero, 0     ; $t1 = 0 (counter)
B"001000_00000_01010_0000_0000_0000_1000", -- X"200A0008", 03: ADDI $t2, $zero, 8     ; $t2 = 8 (array base)
B"000100_01000_00000_0000_0000_0000_1010", -- X"1100000a", 04: BEQ $t0, $zero, 10      ; if $t0 == 0 -> jump to end
B"100011_01010_01011_0000_0000_0000_0000", -- X"8D4B0000", 05: LW $t3, 0($t2)         ; $t3 = Mem[$t2]
B"000000_01011_00000_01100_11111_000111",  -- X"016067C7", 06: SRA $t4, $t3, 31     ; $t4 = $t3 >>a 31 (sign bit)
B"000100_01100_00000_0000_0000_0000_0001", -- X"11800001", 07: BEQ $t4, $zero, 1     ; if $t4 == 0 (positive) -> skip
B"000010_00000_00000_00000_00000_001011",   -- X"0800000B", 08: J 11                  ; jump to check odd
B"001100_01011_01101_0000_0000_0000_0001", -- X"316D0001", 09: ANDI $t5, $t3, 1      ; $t5 = $t3 & 1 (check odd)
B"000100_01101_00000_0000_0000_0000_0001", -- X"11A00001", 10: BEQ $t5, $zero, 1     ; if even -> skip next
B"001000_01001_01001_0000_0000_0000_0001", -- X"21290001", 11: ADDI $t1, $t1, 1      ; $t1++
B"001000_01010_01010_0000_0000_0000_0100", -- X"214A0004", 12: ADDI $t2, $t2, 4      ; $t2 += 4 (next element)
B"001000_01000_01000_1111_1111_1111_1111", -- X"2108FFFF", 13: ADDI $t0, $t0, -1     ; $t0--
B"000010_00000_00000_00000_00000_000011",   -- X"08000003", 14: J 3                   ; jump back to loop
B"101011_00000_01001_0000_0000_0000_0000", -- X"AC090000", 15: SW $t1, 0($zero)      ; store result in Mem[0]
others => X"00000000"
);
begin
pc4<=q+4;
instruction<=rom2(conv_integer (q(6 downto 2)));

--PC
process(clk,rst)
begin
if(rst='1')then
q<=(others=>'0');
elsif rising_edge (clk)then
if(en='1')then
q<=d;
end if;
end if;
end process;
---mux pt brench
process(branchadress,pcsrc,q)
begin
if(pcsrc='1')then
outmux1<=branchadress;
else
outmux1<=q+4;
end if;
end process;
---mux pt jmp
process(jump,jumpadress,outmux1)
begin
if(jump='1')then
d<=jumpadress;
else
d<=outmux1;
end if;
end process;

end Behavioral;
