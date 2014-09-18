library verilog;
use verilog.vl_types.all;
entity prandom is
    port(
        ADDRESS         : in     vl_logic_vector(2 downto 0);
        DATA            : out    vl_logic_vector(9 downto 0)
    );
end prandom;
