--------------------------------------------
-- Module Name: seven_seg_display
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity seven_seg_display is
port (
		bin_input : inout std_logic_vector(3 downto 0);
		segment_output : out std_logic_vector(6 downto 0)
	);
end seven_seg_display;

architecture behavior of seven_seg_display is

    begin
        with bin_input select
        segment_output <= "0000001" when "0000",
                        "1001111" when "0001",
                        "0010010" when "0010",
                        "0000110" when "0011",
                        "1001100" when "0100",
                        "0100100" when "0101",
                        "0100000" when "0110",
                        "0001111" when "0111",
                        "0000000" when "1000",
                        "0000100" when "1001",
                        "1111111" when others;

end behavior;
		

