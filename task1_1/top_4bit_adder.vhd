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
    signal a_in, b_in, s_out : std_logic_vector(3 downto 0);
    signal cout_int : std_logic_vector(4 downto 0);
    constant adder_cnt:integer:=4;

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

        -- Map Sum s_out to LED(3 - 0)
        led(3 downto 0) <= s_out;  

        -- Map co_out to LED(4)
        led(4) <= cout_int(4);     

        -- Map ci_in to Switch B -> DIP8
        cout_int(0) <= pd_swb_out(7);
        
        -- Wire 4-bit ripple carry adder, add0 is LSB, add3 is MSB
        -- using a generate loop
        adders:
            for i in 0 to (adder_cnt - 1) generate
                adder: fulladder_dataflow port map(a_in(i), b_in(i), cout_int(i), cout_int(i+1), s_out(i));
            end generate;

end behavior;
		

