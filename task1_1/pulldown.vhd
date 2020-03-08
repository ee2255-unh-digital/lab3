--------------------------------------------
-- Module Name: pulldown
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pulldown is
    port (
        in_swt : inout std_logic_vector(7 downto 0);
        clk : in std_logic;
		swt_state : out std_logic_vector(7 downto 0)
	);
end pulldown;

architecture behavior of pulldown is
    
    signal clk_count : unsigned(7 downto 0) := 0;
    signal read_enable : std_logic := '0';
    signal a : std_logic_vector(7 downto 0);

    begin
        process (clk)
            begin
            if clk'event and clk='1' then --CLK rising edge
                clk_count <= clk_count + 1;

                --a <= in_swt;
                a <= in_swt;

                if (clk_count > 2) then
                    read_enable <= not(read_enable);
                    clk_count <= 0;
                end if;
            end if;

        end process;

        process (read_enable, in_swt)
            begin
            if (read_enable = '1') then
                in_swt <= "ZZZZZZZZ";
                swt_state <= a;
            else
                in_swt <= "00000000";
            end if;
        end process;

end behavior;
		

