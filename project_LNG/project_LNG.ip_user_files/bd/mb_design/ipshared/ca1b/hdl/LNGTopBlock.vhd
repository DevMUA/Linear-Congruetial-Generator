----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/16/2021 08:04:17 PM
-- Design Name: 
-- Module Name: LNGTopBlock - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LNGTopBlock is
    generic(
        SEED_SIZE : integer := 16
    );
    Port ( 
        CLK     : in std_logic;
        NEW_VALUE : in std_logic;
        INITIAL_SEED : in std_logic_vector(SEED_SIZE-1 downto 0);
        INITIAL_A : in std_logic_vector(7 downto 0);
        INITIAL_INC : in std_logic_vector(7 downto 0);
        INITIAL_M:  in std_logic_vector(7 downto 0);
        RESULT: out std_logic_vector(SEED_SIZE-1 downto 0);
        DONE:   out std_logic
    );
end LNGTopBlock;

architecture Behavioral of LNGTopBlock is


    component LNGBasicBlock is
        generic (
            SEED_SIZE : integer
        );
        port(
            seed : in std_logic_vector(SEED_SIZE-1 downto 0);
            a : in std_logic_vector( 7 downto 0);
            inc : in std_logic_vector( 7 downto 0);
            m : in std_logic_vector( 7 downto 0);
            a_out : out std_logic_vector( 15 downto 0);
            inc_out: out std_logic_vector( 15 downto 0);
            m_out : out std_logic_vector( 15 downto 0);
            seed_out: out std_logic_vector( SEED_SIZE-1 downto 0)
        );
     end component;
     
    component RegisterBankCustom is
        generic (
            SEED_SIZE : integer
        );
        port(
            clk, nSet, nRst : in  std_logic;
            validIn         : in  std_logic;
            D0, D1, D2, D3      : in  std_logic_vector(SEED_SIZE-1 downto 0);
            validOut        : out std_logic;
            Q0, Q1, Q2, Q3      : out std_logic_vector(SEED_SIZE-1 downto 0)
        );
     end component;
     
     constant N_ITER : integer := 10;
     type TLNGData32 is array (0 to 2*(N_ITER-1)) of std_logic_vector(SEED_SIZE-1 downto 0);
     type TLNGData16 is array (0 to 2*(N_ITER-1)) of std_logic_vector(15 downto 0);
     type TValid is array (0 to N_ITER-1) of std_logic;
     signal seed_array: TLNGData32;
     signal a_array,inc_array,m_array: TLNGData16;
     signal valid_array: TValid; 
     signal s_seed: std_logic_vector(SEED_SIZE-1 downto 0);
     signal s_valid: std_logic;

begin

    seed_array(0) <= INITIAL_SEED;
    a_array(0) <= x"00" & INITIAL_A;
    inc_array(0) <= x"00" &  INITIAL_INC;
    m_array(0) <= x"00" & INITIAL_M;
    valid_array(0) <= NEW_VALUE;
    
gen_LNG_blocks: for I in 0 to N_ITER-1 generate
    NORMAL_ITER: if I<N_ITER-1 generate
        LNGBasic : LNGBasicBlock
            generic map (
                SEED_SIZE => SEED_SIZE
            )
            port map(
                seed => seed_array(2*I),
                a => a_array(2*I)(7 downto 0),
                inc => inc_array(2*I)(7 downto 0),
                m => m_array(2*I)(7 downto 0),
                a_out => a_array(2*I+1),
                inc_out => inc_array(2*I+1),
                m_out => m_array(2*I+1),
                seed_out => seed_array(2*I+1)
            );
            
        RegisterBank1 : RegisterBankCustom
            generic map(
                SEED_SIZE => SEED_SIZE
            )
            port map(
                clk => clk,
                nSet => '1',
                nRst => '1',
                validIn => valid_array(I),
                D0 => seed_array(2*I+1),
                D1 => a_array(2*I+1),
                D2 => inc_array(2*I+1),
                D3 => m_array(2*I+1),
                validOut => valid_array(I+1),
                Q0 => a_array(2*(I+1)),
                Q1 => inc_array(2*(I+1)),
                Q2 => m_array(2*(I+1)),
                Q3 => seed_array(2*(I+1))
            );
     end generate NORMAL_ITER;
     
     LAST_ITER: if I=N_ITER-1 generate
        LNGBasic: LNGBasicBlock
            generic map (
                SEED_SIZE => SEED_SIZE
            )
            port map(
                seed => seed_array(2*I),
                a => a_array(2*I)(7 downto 0),
                inc => inc_array(2*I)(7 downto 0),
                m => m_array(2*I)(7 downto 0),
                a_out => open,
                inc_out => open,
                m_out => open,
                seed_out => s_seed
            );
        end generate LAST_ITER;
        
        RESULT <= s_seed;
        DONE <= valid_array(N_ITER-1);
     
 end generate gen_LNG_blocks;

end Behavioral;


-- ============
-- = FlipFlop =
-- ============
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipFlopDPET is
    port (
        clk, D      : in  std_logic;
        nSet, nRst  : in  std_logic;
        Q, nQ       : out std_logic
    );
end flipFlopDPET;

architecture Behavioral of flipFlopDPET is
begin
    process (clk, nSet, nRst)
    begin
        if (nRst = '0') then
            Q <= '0';
            nQ <= '1';
        elsif (nSet = '0') then
            Q <= '1';
            nQ <= '0';
        elsif (clk = '1') and (clk'event) then
            Q <= D;
            nQ <= not D;
        end if;
    end process;
end Behavioral;



-- ============
-- = Register =
-- ============
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterNBits is
    generic (
        SEED_SIZE: integer := 16
    );
    port (
        clk, nSet, nRst : in  std_logic;
        D               : in  std_logic_vector(SEED_SIZE-1 downto 0);
        Q, nQ           : out std_logic_vector(SEED_SIZE-1 downto 0)
    );
end RegisterNBits;

architecture Structural of RegisterNBits is

    component flipFlopDPET
        port (
            clk, D      : in  std_logic;
            nSet, nRst  : in  std_logic;
            Q, nQ       : out std_logic
        );
    end component;

begin
gen_reg: for I in 0 to SEED_SIZE-1 generate
    FlipFlop : flipFlopDPET
        port map (
            clk     => clk,
            D       => D(I),
            nSet    => nSet,
            nRst    => nRst,
            Q       => Q(I),
            nQ      => nQ(I)
        );
end generate gen_reg;
end Structural;



-- =================
-- = Register Bank =
-- =================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterBankCustom is
    generic (
        SEED_SIZE: integer
    );
    port (
        clk, nSet, nRst : in  std_logic;
        validIn         : in  std_logic;
        D0, D1, D2, D3      : in  std_logic_vector(SEED_SIZE-1 downto 0);
        validOut        : out std_logic;
        Q0, Q1, Q2, Q3      : out std_logic_vector(SEED_SIZE-1 downto 0)
    );
end RegisterBankCustom;

architecture Structural of RegisterBankCustom is

    component flipFlopDPET
        port (
            clk, D      : in  std_logic;
            nSet, nRst  : in  std_logic;
            Q, nQ       : out std_logic
        );
    end component;

    component RegisterNBits is
        generic (
            SEED_SIZE       : integer
        );
        port (
            clk, nSet, nRst : in  std_logic;
            D               : in  std_logic_vector(SEED_SIZE-1 downto 0);
            Q, nQ           : out std_logic_vector(SEED_SIZE-1 downto 0)
        );
    end component;

begin

    reg0: RegisterNBits
        generic map (SEED_SIZE)
        port map (clk, nSet, nRst, D0, Q0, open);

    reg1: RegisterNBits
        generic map (SEED_SIZE)
        port map (clk, nSet, nRst, D1, Q1, open);

    reg2: RegisterNBits
        generic map (SEED_SIZE)
        port map (clk, nSet, nRst, D2, Q2, open);
        
    reg3: RegisterNBits
        generic map (SEED_SIZE)
        port map (clk, nSet, nRst, D3, Q3, open);
    
    valid : flipFlopDPET
        port map (
            clk     => clk,
            D       => validIn,
            nSet    => nSet,
            nRst    => nRst,
            Q       => validOut,
            nQ      => open
        );

end Structural;