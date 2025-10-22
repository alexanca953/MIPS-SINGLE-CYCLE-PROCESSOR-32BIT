----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2025 08:03:44 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

entity MEM is
 Port (
  MemWrite:in std_logic;    
 AluRes:in std_logic_vector(31 downto 0);                      
rd2:in std_logic_vector(31 downto 0);  
 clk: in STD_LOGIC;    
 en:in std_logic;     
 memData:out std_logic_vector(31 downto 0);    
 aluresout:out std_logic_vector(31 downto 0));
end MEM;

architecture Behavioral of MEM is
type memory is array(0 to 63) of std_logic_vector(31 downto 0);
signal mem : memory := (
  0 => X"00000000", -- rezultat final
  1 => X"00000005", -- N = 5
  2 => X"00000007", -- array[0] =7
  3 => X"FFFFFFFD", -- array[1] =-3
  4 => X"0000000A", -- array[2] =10
  5 => X"00000009", -- array[3] =9
  6 => X"FFFFFFFC", -- array[4] =-4
  others => X"00000000"
);
begin
process(clk)
begin
if rising_edge(clk) then
if (en = '1'and memwrite='1') then
mem(conv_integer (alures(7 downto 2)))<=rd2;
end if;
end if;
end process;

memdata <= mem(conv_integer(alures(7 downto 2)));
aluresout<=alures;
end Behavioral;
