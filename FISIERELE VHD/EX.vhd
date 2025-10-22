----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 04:41:46 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
    Port (RD1:in std_logic_vector(31 downto 0);
     RD2:in std_logic_vector(31 downto 0);
    AluSrc:in std_logic;
   ext_imm:in std_logic_vector(31 downto 0);
    sa: in STD_LOGIC_VECTOR(4 downto 0);
    func:in std_logic_vector(5 downto 0);
    aluop:in std_logic_vector(2 downto 0);
    pc4:in std_logic_vector(31 downto 0);
    branch_adress:out std_logic_vector(31 downto 0);
    zero:out std_logic;
    alures:out std_logic_vector(31 downto 0));
end EX;

architecture Behavioral of EX is
signal a:std_logic_vector(31 downto 0);
signal b:std_logic_vector(31 downto 0);
signal c:std_logic_vector(31 downto 0);
signal ALUctrl:std_logic_vector(2 downto 0);
begin

process(aluop,func)
begin
case aluop is
when "010" =>
case func is 
when "000000" =>aluctrl<="010";
when "000001" =>aluctrl<="110";
when "000010" =>aluctrl<="011";
when "000011" =>aluctrl<="100";
when "000100" =>aluctrl<="000";
when "000101" =>aluctrl<="001";
when "000110" =>aluctrl<="101";
when "000111" =>aluctrl<="111";
when others =>aluctrl<="XXX";
end case;
when "000" =>aluctrl<="010";
when "001" =>aluctrl<="110";
when "011" =>aluctrl<="001";
when "111" =>aluctrl<="000";
when "XXX" =>aluctrl<="XXX";
when others => aluctrl<="XXX";
end case;
end process;

process(alusrc,rd2,ext_imm)
begin
if(alusrc='0')then
b<=rd2;
else
b<=ext_imm;
end if;
end process;
a<=rd1;
process(a,b,sa,aluctrl)
begin
case aluctrl is  
when "010"=>c<=a+b;
when "110"=>c<=a-b;
when "011"=>c<=to_stdlogicvector (to_bitvector(B)sll conv_integer (sa));
when "100"=> c<=to_stdlogicvector (to_bitvector(B)srl conv_integer (sa));
when "000"=>c<=a and b;
when "001"=>c<=a or b ;
when "101"=> c<=a xor b;
when "111"=> c<=to_stdlogicvector (to_bitvector(a)sra conv_integer (sa));
when others => c<=(others=>'X');
end case;
end process;

alures<=c;
zero<='1'when c=0 else '0';
branch_adress<=pc4+(ext_imm(29 downto 0) & "00");
end Behavioral;
