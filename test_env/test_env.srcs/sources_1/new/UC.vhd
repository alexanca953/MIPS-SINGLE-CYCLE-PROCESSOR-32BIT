library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
    Port (
        Instr : in  STD_LOGIC_VECTOR(5 downto 0);  -- Opcode (6 bits)
        RegDst : out STD_LOGIC;                    
        ExtOp  : out STD_LOGIC;                    -- Sign extension
        ALUSrc : out STD_LOGIC;                    
        Branch : out STD_LOGIC;                    
        Jump   : out STD_LOGIC;                  
        JmpR   : out STD_LOGIC;                   
        MemWrite : out STD_LOGIC;                  
        MemtoReg : out STD_LOGIC;                  
        RegWrite : out STD_LOGIC;                
        ALUOp  : out STD_LOGIC_VECTOR(2 downto 0)  
    );
end UC;

architecture Behavioral of UC is
begin
    process(Instr)
    begin
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        JmpR <= '0';
        MemWrite <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        ALUOp <= "000";   
        case Instr is
            -- R instructions (ADD, SUB, AND, OR, XOR, SLT, SLL, SRL)
            when "000000" =>
                RegDst <= '1';
                RegWrite <= '1';
                ALUOp <= "010";  
            -- ADDI
            when "001000" =>
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "000";                
            -- ANDI
            when "001100" =>
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "111";  
            -- ORI
            when "001101" =>
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "011";               
            -- LW
            when "100011" =>
                ExtOp <= '1';
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                ALUOp <= "000";               
            -- SW
            when "101011" =>
                ExtOp <= '1';
                ALUSrc <= '1';
                MemWrite <= '1';
                ALUOp <= "000";              
            -- BEQ
            when "000100" =>
                ExtOp <= '1';
                Branch <= '1';
                ALUOp <= "001";            
            -- J
            when "000010" =>
                Jump <= '1';                
            when others =>
              NULL;
        end case;
    end process;
end Behavioral;