--------------------------------------------
-- Module Name: top_4bit_adder
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity top_4bit_adder is
port (
        io_swt_a : inout std_logic_vector(7 downto 0);      -- IO Switch A
        io_swt_b : inout std_logic_vector(7 downto 0);      -- IO Switch B
        clk_in : in std_logic;
        led : out std_logic_vector(7 downto 0);             -- LEDs on FPGA board
        seg_ledmux_out : out std_logic_vector(6 downto 0);  -- Seven segment mux output
        seg_led1_en : out std_logic                         -- Seven segment LED1 display enable
	);
end top_4bit_adder;

architecture behavior of top_4bit_adder is

    -- internal net for outputs from pulldown module (SWT A)
    signal pd_swa_out : std_logic_vector(7 downto 0);

    -- internal net for outputs from pulldown module (SWT B)
    signal pd_swb_out : std_logic_vector(7 downto 0);

    -- pull-down component
	component pulldown
		port (
        	in_swt : inout std_logic_vector(7 downto 0);
        	clk : in std_logic;
			swt_state : out std_logic_vector(7 downto 0)
		);
    end component;

    begin
        -- enable led1 segment display
        seg_led1_en <= '0';

        -- wire pulldown component (SWTA switches)
        swta_pd: pulldown port map(
            in_swt => io_swt_a, 
            clk => clk_in, 
            swt_state=> pd_swa_out
        );

        -- wire pulldown component (SWTB switches)
        swtb_pd: pulldown port map(
            in_swt => io_swt_b, 
            clk => clk_in, 
            swt_state=> pd_swb_out
        );
        

end behavior;
		

