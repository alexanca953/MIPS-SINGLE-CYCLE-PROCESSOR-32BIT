----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2025 04:37:58 PM
-- Design Name: 
-- Module Name: lab2 - Behavioral
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
use IEEe.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ssd is
    Port ( clk : in STD_LOGIC;
           digit : in STD_LOGIC_VECTOR (31 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end ssd;

architecture Behavioral of ssd is
signal count:std_logic_vector(16 downto 0):="00000000000000000";
signal outmuxcat:std_logic_vector(3 downto 0):="0000";

begin

process(clk)
begin
--pentru anozi
if(count="1111111111111111")then
		   count<="00000000000000000";
		end if;
		
if(count(16 downto 14)="000")then
an<="11111110";
elsif(count(16 downto 14)="001")then
an<="11111101";
elsif(count(16 downto 14)="010")then
an<="11111011";
elsif(count(16 downto 14)="011")then
an<="11110111";
elsif(count(16 downto 14)="100")then
an<="11101111";
elsif(count(16 downto 14)="101")then
an<="11011111";
elsif(count(16 downto 14)="110")then
an<="10111111";
elsif(count(16 downto 14)="111")then
an<="01111111";
end if;
--pentru catozi
if(count(16 downto 14)="000")then
outmuxcat<=digit(3 downto 0);
elsif(count(16 downto 14)="001")then
outmuxcat<=digit(7 downto 4);
elsif(count(16 downto 6)="010")then
outmuxcat<=digit(11 downto 8);
elsif(count(16 downto 14)="011")then
outmuxcat<=digit(15 downto 12);
elsif(count(16 downto 14)="100")then
outmuxcat<=digit(19 downto 16);
elsif(count(16 downto 14)="101")then
outmuxcat<=digit(23 downto 20);
elsif(count(16 downto 14)="110")then
outmuxcat<=digit(27 downto 24);
elsif(count(16 downto 14)="111")then
outmuxcat<=digit(31 downto 28);
end if;
--HEX-to-seven-segment decoder
case outmuxcat is

   when "0001"=> cat<= "1111001" ;  --1
   when "0010"=> cat<= "0100100" ;  --2
      when "0011"=> cat<=  "0110000";   --3
     when "0100"=>cat<=  "0011001"  ;  --4
    when "0101" =>  cat<=  "0010010" ;   --5
     when "0110" =>  cat<=  "0000010" ;  --6
    when "0111"    =>cat<= "1111000";    --7
  when "1000"     =>cat<="0000000" ;  --8
     when "1001"    => cat<= "0010000";  --9
    when "1010"  => cat<=  "0001000"  ;  --A
   when "1011"  =>  cat<=  "0000011" ;   --b
     when "1100"    => cat<= "1000110" ; --C
   when "1101"  =>   cat<= "0100001";    --d
   when "1110"    =>  cat<="0000110" ;  --E
     when "1111"  => cat<= "0001110" ;  --F
      when others  => cat<="1000000" ;   --0

		end case;
if(rising_edge (clk))then
		count<=count+1;
		end if;
end process;

end Behavioral;
