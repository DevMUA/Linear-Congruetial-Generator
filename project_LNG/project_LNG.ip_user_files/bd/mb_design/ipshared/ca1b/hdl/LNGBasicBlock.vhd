----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/16/2021 07:32:34 PM
-- Design Name: 
-- Module Name: LNGBasicBlock - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LNGBasicBlock is
    generic(
        SEED_SIZE : integer
    );
    Port ( 
        seed : in std_logic_vector(SEED_SIZE-1 downto 0);
        a : in std_logic_vector(7 downto 0);
        inc : in std_logic_vector(7 downto 0);
        m : in std_logic_vector(7 downto 0);
        a_out : out std_logic_vector(15 downto 0);
        inc_out: out std_logic_vector(15 downto 0);
        m_out: out std_logic_vector(15 downto 0);
        seed_out : out std_logic_vector(SEED_SIZE-1 downto 0)
    );
end LNGBasicBlock;

architecture Behavioral of LNGBasicBlock is

    signal s_multiplicationOutput,s_additionOutput :   std_logic_vector(15 downto 0);
    signal paddedA,paddedInc,paddedM : std_logic_vector(15 downto 0);
    

    component ALU
        generic(
            N : natural
        );
        port(
            A,B : in std_logic_vector(15 downto 0);
            ALU_Sel : in std_logic_vector(3 downto 0);
            ALU_Out : out std_logic_vector(15 downto 0);
            Carryout : out std_logic
        );
     end component;

begin

    paddedA <= "00000000" & A;
    paddedInc <= "00000000" & inc;
    paddedM <= "00000000" & m;


    -- multiplication
    alu1: ALU
        generic map(
            N => 1
        )
        port map(
            A => paddedA,
            B => seed,
            ALU_Sel => "0010",
            ALU_Out => s_multiplicationOutput,
            Carryout => open
        );
     -- addition
     alu2: ALU
        generic map(
            N => 1
        )
        port map(
            A => s_multiplicationOutput,
            B => paddedInc,
            ALU_Sel => "0000",
            ALU_Out => s_additionOutput,
            Carryout => open
        );
        
        a_out <= paddedA;
        inc_out <= paddedInc;
        m_out <= paddedM;
        -- modulus operation
        seed_out <= std_logic_vector(unsigned(s_additionOutput) mod unsigned(paddedM));
        


end Behavioral;


--
-- ALU
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
entity ALU is
  generic ( 
     constant N: natural := 1  -- number of shited or rotated bits
    );
  
    Port (
    A, B     : in  STD_LOGIC_VECTOR(15 downto 0);  -- 2 inputs 8-bit
    ALU_Sel  : in  STD_LOGIC_VECTOR(3 downto 0);  -- 1 input 4-bit for selecting function
    ALU_Out   : out  STD_LOGIC_VECTOR(15 downto 0); -- 1 output 8-bit 
    Carryout : out std_logic        -- Carryout flag
    );
end ALU; 
architecture Behavioral of ALU is

signal ALU_Result : std_logic_vector (15 downto 0);
signal tmp: std_logic_vector (16 downto 0);

begin
   process(A,B,ALU_Sel)
 begin
  case(ALU_Sel) is
  when "0000" => -- Addition
   ALU_Result <= A + B ; 
  when "0001" => -- Subtraction
   ALU_Result <= A - B ;
  when "0010" => -- Multiplication
   ALU_Result <= std_logic_vector(to_unsigned((to_integer(unsigned(A)) * to_integer(unsigned(B))),16)) ;
  when "0011" => -- Division
   ALU_Result <= std_logic_vector(to_unsigned(to_integer(unsigned(A)) / to_integer(unsigned(B)),16)) ;
  when "0100" => -- Logical shift left
   ALU_Result <= std_logic_vector(unsigned(A) sll N);
  when "0101" => -- Logical shift right
   ALU_Result <= std_logic_vector(unsigned(A) srl N);
  when "0110" => --  Rotate left
   ALU_Result <= std_logic_vector(unsigned(A) rol N);
  when "0111" => -- Rotate right
   ALU_Result <= std_logic_vector(unsigned(A) ror N);
  when "1000" => -- Logical and 
   ALU_Result <= A and B;
  when "1001" => -- Logical or
   ALU_Result <= A or B;
  when "1010" => -- Logical xor 
   ALU_Result <= A xor B;
  when "1011" => -- Logical nor
   ALU_Result <= A nor B;
  when "1100" => -- Logical nand 
   ALU_Result <= A nand B;
  when "1101" => -- Logical xnor
   ALU_Result <= A xnor B;
  when "1110" => -- Greater comparison
   if(A>B) then
    ALU_Result <= x"0001" ;
   else
    ALU_Result <= x"0000" ;
   end if; 
  when "1111" => -- Equal comparison   
   if(A=B) then
    ALU_Result <= x"0001" ;
   else
    ALU_Result <= x"0000" ;
   end if;
  when others => ALU_Result <= A + B ; 
  end case;
 end process;
 ALU_Out <= ALU_Result; -- ALU out
 tmp <= ('0' & A) + ('0' & B);
 Carryout <= tmp(8); -- Carryout flag
end Behavioral;