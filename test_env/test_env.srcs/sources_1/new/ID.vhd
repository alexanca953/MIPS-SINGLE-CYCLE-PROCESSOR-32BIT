----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 04:33:14 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
  Port ( clk : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           Instr : in std_logic_VECTOR(25 downto 0);
            RegDst : in std_Logic;
            EN : in STD_LOGIC;
            ExtOp : in STD_LOGIC;
           WD : in STD_LOGIC_VECTOR (31 downto 0);
       
           RD1 : out STD_LOGIC_VECTOR (31 downto 0);
            RD2 : out STD_LOGIC_VECTOR (31 downto 0);
           Ext_imm : out STD_LOGIC_VECTOR (31 downto 0);
     
           func : out STD_LOGIC_VECTOR (5 downto 0);
          sa: out STD_LOGIC_VECTOR (4 downto 0));
end ID;

architecture Behavioral of ID is
component reg_file is
port ( clk : in std_logic;
ra1 : in std_logic_vector(4 downto 0);
ra2 : in std_logic_vector(4 downto 0);
wa : in std_logic_vector(4 downto 0);
wd : in std_logic_vector(31 downto 0);
regwr : in std_logic;
en:in std_logic;
rd1 : out std_logic_vector(31 downto 0);
rd2 : out std_logic_vector(31 downto 0));
end component;
signal muxout :std_logic_vector(4 downto 0):="00000";
begin

regf:reg_file port map (clk,instr(25 downto 21),instr(20 downto 16),muxout,wd,RegWrite,en,rd1,rd2);

process(regdst,instr)
begin
if(regdst='1')then
muxout<=Instr(15 downto 11);
else
muxout<=Instr(20 downto 16);
end if;
end process;
ext_imm(15 downto 0)<=instr(15 downto 0);
ext_imm(31 downto 16)<=(others=> instr(15))when extop='1'
else (others=>'0');
func<=instr(5 downto 0);
sa<=instr(10 downto 6);
end Behavioral;
