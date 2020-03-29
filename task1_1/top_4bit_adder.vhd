--------------------------------------------
-- Module Name: top_4bit_adder
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity top_4bit_adder is
port (
        av : inout std_logic_vector(3 downto 0);      
        bv : inout std_logic_vector(3 downto 0);
        cin : in std_logic;
        sv : out std_logic_vector(3 downto 0);
        cout : out std_logic                         
	);
end top_4bit_adder;

architecture behavior of top_4bit_adder is

    signal cout_int : std_logic_vector(4 downto 0);
    constant adder_cnt:integer:=4;

    -- full adder component
    component fulladder_dataflow
        port (
            a : in std_logic;       -- 1-bit (a) 
            b : in std_logic;       -- 1-bit (b)
            ci : in std_logic;      -- Carry in
            co : out std_logic;     -- Carry out
            s : out std_logic       -- sum bit
        );
    end component;

    begin

        cout_int(0) <= cin;

        cout <= cout_int(4);
        
        -- Wire 4-bit ripple carry adder
        -- using a generate loop
        adders:
            for i in 0 to (adder_cnt - 1) generate
                adder: fulladder_dataflow port map(av(i), bv(i), cout_int(i), cout_int(i+1), sv(i));
            end generate;

end behavior;
		

