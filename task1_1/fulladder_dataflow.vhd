library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 1-bit Full Adder using dataflow
entity fulladder_dataflow is
    port (
        a : in std_logic;       -- 1-bit (a) 
        b : in std_logic;       -- 1-bit (b)
        ci : in std_logic;      -- Carry in
        co : out std_logic;     -- Carry out
        s : out std_logic       -- sum bit
	);
end fulladder_dataflow;

architecture behavior of fulladder_dataflow is
    -- Implement architecture using data flow
    -- look a truth table and generate logic expression

    begin
        s <= a xor b xor ci;
        
		co <= ((a and b) or ((a xor b) and ci));

end behavior;