library verilog;
use verilog.vl_types.all;
entity countdown is
    port(
        RESET           : in     vl_logic;
        CLK             : in     vl_logic;
        LOAD            : in     vl_logic;
        DATA            : in     vl_logic_vector(9 downto 0);
        DONE            : out    vl_logic
    );
end countdown;
