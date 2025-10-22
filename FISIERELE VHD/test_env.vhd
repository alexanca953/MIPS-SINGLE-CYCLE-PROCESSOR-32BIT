----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2025 08:40:19 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
  Port (btn:in std_logic_vector(1 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           sw:in std_logic_vector(15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
  clk:in std_Logic);
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component ssd is
    Port ( clk : in STD_LOGIC;
           digit : in STD_LOGIC_VECTOR (31 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component UC is
    Port (
        Instr : in  STD_LOGIC_VECTOR(5 downto 0);-- Opcode (6 bits)
        RegDst : out STD_LOGIC;                   
        ExtOp  : out STD_LOGIC;-- Sign extension
        ALUSrc : out STD_LOGIC;                   
        Branch : out STD_LOGIC;                   
        Jump   : out STD_LOGIC;                    
        JmpR   : out STD_LOGIC;                   
        MemWrite : out STD_LOGIC;                 
        MemtoReg : out STD_LOGIC;                
        RegWrite : out STD_LOGIC;                  
        ALUOp  : out STD_LOGIC_VECTOR(2 downto 0) 
    );
end component;

component ID is
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
end component;
component EX is
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
end component;
component IFetch is
Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           jump : in std_Logic;
           jumpadress : in STD_LOGIC_VECTOR (31 downto 0);
           pcsrc : in std_logic;
           branchadress : in STD_LOGIC_VECTOR (31 downto 0);
           pc4 : out STD_LOGIC_VECTOR (31 downto 0);
           instruction : out STD_LOGIC_VECTOR (31 downto 0));
end component;
component MEM is
 Port (
  MemWrite:in std_logic;    
 AluRes:in std_logic_vector(31 downto 0);                      
rd2:in std_logic_vector(31 downto 0);  
 clk: in STD_LOGIC;    
 en:in std_logic;     
 memData:out std_logic_vector(31 downto 0);    
 aluresout:out std_logic_vector(31 downto 0));
end component;
---semnalele
signal branchAdress:std_logic_vector(31 downto 0);
signal jump :std_Logic;
signal jumpadress :STD_LOGIC_VECTOR (31 downto 0);
signal pcsrc :std_logic;
signal pc4 :STD_LOGIC_VECTOR (31 downto 0):=X"00000000";
signal instruction :STD_LOGIC_VECTOR (31 downto 0);
signal rst :std_logic;
signal RegWrite:STD_LOGIC;
signal RegDst :std_Logic;
signal EN :STD_LOGIC;
signal ExtOp :STD_LOGIC;
signal WD :STD_LOGIC_VECTOR (31 downto 0);
signal RD1 :STD_LOGIC_VECTOR (31 downto 0);
signal RD2 :STD_LOGIC_VECTOR (31 downto 0);
signal Ext_imm :STD_LOGIC_VECTOR (31 downto 0);
signal func :STD_LOGIC_VECTOR (5 downto 0);
signal sa:  STD_LOGIC_VECTOR (4 downto 0);
signal AluSrc: std_logic;
signal aluop: std_logic_vector(2 downto 0);
signal zero: std_logic;
signal alures: std_logic_vector(31 downto 0);
signal MemWrite:std_logic;    
signal memData: std_logic_vector(31 downto 0);    
signal aluresout: std_logic_vector(31 downto 0);    
signal Branch :  STD_LOGIC;
signal JumpR   : STD_LOGIC;
signal MemtoReg :STD_LOGIC;
---mux ssg
signal out2:std_Logic_vector(31 downto 0);
begin

ifetch1: ifetch port map(clk,en,btn(1),jump,jumpadress,pcsrc,branchadress,pc4,instruction);
id1:id port map(clk,regwrite,instruction(25 downto 0),regdst,en,extop,wd,rd1,rd2,ext_imm,func,sa);
ex1:ex port map(rd1,rd2,alusrc,ext_imm,sa,func,aluop,pc4,branchadress,zero,alures);
mem1:mem port map(memwrite,alures,rd2,clk,en,memdata,aluresout);
uc1:uc port map(instruction(31 downto 26),regdst,extop,alusrc,branch,jump,jumpr,memwrite,memtoreg,regwrite,aluop);
mpg1:MPG port map(btn(0),clk,en);
ssd1:ssd port map(clk,out2,an,cat);

--mux wb
process(memdata,aluresout,memtoreg)
begin
if(memtoreg='1')then
wd<=memdata;
else
wd<=aluresout;
end if;
end process;
---

jumpadress<=pc4(31 downto 28)&(instruction(25 downto 0)&"00");
led(10 downto 0)<=aluop & regdst&extop&alusrc&branch&jump&memwrite&memtoreg&regwrite;
pcsrc<=branch and zero;

--mux ssd
process(sw(7 downto 5),instruction,pc4,rd1,rd2,ext_imm,alures,memdata,wd)
begin
case sw(7 downto 5) is
when "000" => out2<=instruction;
when "001" => out2<=pc4;
when "010" => out2<=rd1;
when "011" => out2<=rd2;
when "100" => out2<=ext_imm;
when "101" => out2<=alureS;
when "110" => out2<=MEMDATA;
when "111" => out2<=wd;
when others => out2<="00000000000000000000000000000000";
end case;
end process;

end Behavioral;