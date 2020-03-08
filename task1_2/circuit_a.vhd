--------------------------------------------
-- Module Name: circuit_a
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity circuit_a is
    port (
		v_in : in std_logic_vector(3 downto 0);
		a_out : out std_logic_vector(3 downto 0)
	);
end circuit_a;

architecture behavior of circuit_a is

    begin

        process(v_in)
            begin
            if v_in > "1001" then
                a_out <= (v_in - "1010");
            else
                a_out <= v_in;
            end if;

        end process;

end behavior;
		

