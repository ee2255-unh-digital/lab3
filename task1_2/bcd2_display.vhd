--------------------------------------------
-- Module Name: bcd2_display
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity bcd2_display is
port (
		bin_input : in std_logic_vector(3 downto 0);
        digit0_out : out std_logic_vector(6 downto 0);
        digit1_out : out std_logic
	);
end bcd2_display;

architecture behavior of bcd2_display is

    signal z : std_logic;
    signal a : std_logic_vector(3 downto 0);
    signal m : std_logic_vector(3 downto 0);

    -- comparator
    component comparator
        port (
            v_in : inout std_logic_vector(3 downto 0);
            z_out : out std_logic
        );
    end component;

    -- circuit A
    component circuit_a
        port (
            v_in : inout std_logic_vector(3 downto 0);
            a_out : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- 7-segment display component
    component seven_seg_display
        port (
            bin_input : inout std_logic_vector(3 downto 0);
		    segment_output : out std_logic_vector(6 downto 0)
        );
    end component;

    begin
        -- wire comparator
        cmp: comparator port map(
            v_in => bin_input,
            z_out => z
        );

        -- wire circuit A
        cA: circuit_a port map(
            v_in => bin_input,
            a_out => a
        );

        -- wire 7-segment display DIP switch A -> input, LED1 segment display -> output
        led1_disp: seven_seg_display port map(
            bin_input => m,
            segment_output => digit0_out
        );

        digit1_out <= z;

        -- mux
        process(v, z, a)
            begin
            if z = '0' then
                m <= v;
            else
                m <= a;
            end if;
        end process;

end behavior;
		

