--------------------------------------------
-- Module Name: comparator
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity comparator is
    port (
		v_in : in std_logic_vector(3 downto 0);
		z_out : out std_logic
	);
end comparator;

architecture behavior of comparator is

    begin
        with v_in select
        z_out <= '0' when "0000",
            '0' when "0001",
            '0' when "0010",
            '0' when "0011",
            '0' when "0100",
            '0' when "0101",
            '0' when "0110",
            '0' when "0111",
            '0' when "1000",
            '0' when "1001",
            '1' when others;

end behavior;
		

