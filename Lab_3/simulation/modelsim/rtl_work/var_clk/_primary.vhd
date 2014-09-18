library verilog;
use verilog.vl_types.all;
entity var_clk is
    port(
        clock_sel       : in     vl_logic_vector(2 downto 0);
        clock_50MHz     : in     vl_logic;
        var_clock       : out    vl_logic
    );
end var_clk;
