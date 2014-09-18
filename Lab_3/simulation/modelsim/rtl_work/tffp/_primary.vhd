library verilog;
use verilog.vl_types.all;
entity tffp is
    port(
        CLK             : in     vl_logic;
        RESET           : in     vl_logic;
        T               : in     vl_logic;
        Q               : out    vl_logic
    );
end tffp;
