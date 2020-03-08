--------------------------------------------
-- Module Name: top_4bit_adder
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity top_4bit_adder is
port (
        io_swt_a : inout std_logic_vector(7 downto 0);      -- IO Switch a_in
        io_swt_b : inout std_logic_vector(7 downto 0);      -- IO Switch B
        clk_in : in std_logic;
        led : out std_logic_vector(7 downto 0);             -- LEDs on FPGA board
        seg_ledmux_out : out std_logic_vector(6 downto 0);  -- Seven segment mux output
        seg_led1_en : out std_logic                         -- Seven segment LED1 display enable
	);
end top_4bit_adder;

architecture behavior of top_4bit_adder is

    -- internal net for outputs from pulldown module (SWT a_in)
    signal pd_swa_out : std_logic_vector(7 downto 0);

    -- internal net for outputs from pulldown module (SWT B)
    signal pd_swb_out : std_logic_vector(7 downto 0);

    -- internal nets for ripple carry adder
    signal cout_0,cout_1,cout_2,cout_3 : std_logic;
    signal a_in, b_in, s_out : std_logic_vector(3 downto 0);
    signal ci_in, co_out : std_logic;

    -- pull-down component
	component pulldown
		port (
        	in_swt : inout std_logic_vector(7 downto 0);
        	clk : in std_logic;
			swt_state : out std_logic_vector(7 downto 0)
		);
    end component;

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
        -- disable led1 segment display
        seg_led1_en <= '1';
        seg_ledmux_out <= "1111111";

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

        -- Wire 4-bit ripple carry adder, add0 is LSB, add3 is MSB
        add0: fulladder_dataflow port map(a_in(0), b_in(0), ci_in, cout_0, s_out(0));
		add1: fulladder_dataflow port map(a_in(1), b_in(1), cout_0, cout_1, s_out(1));
		add2: fulladder_dataflow port map(a_in(2), b_in(2), cout_1, cout_2, s_out(2));
		add3: fulladder_dataflow port map(a_in(3), b_in(3), cout_2, cout_3, s_out(3));
		
        co_out <= cout_3;
        
        -- Map number (a) to switch A (DIP1 - DIP4)
        a_in(3) <= pd_swa_out(0); -- DIP1 (MSB)
        a_in(2) <= pd_swa_out(1); -- DIP2
        a_in(1) <= pd_swa_out(2); -- DIP3
        a_in(0) <= pd_swa_out(3); -- DIP4 (LSB)
        
        -- Map number (a) to switch B (DIP1 - DIP4)
        b_in(3) <= pd_swb_out(0); -- DIP1 (MSB)
        b_in(2) <= pd_swb_out(1); -- DIP2
        b_in(1) <= pd_swb_out(2); -- DIP3
        b_in(0) <= pd_swb_out(3); -- DIP4 (LSB)
        
        -- Map ci_in to Switch B -> DIP8
        ci_in <= pd_swb_out(7);

        -- Map Sum s_out to LED(3 - 0)
        led(3 downto 0) <= s_out;

        -- Map co_out to LED(4)
        led(4) <= co_out;        

end behavior;
		

