library verilog;
use verilog.vl_types.all;
entity address_generator is
    port(
        RESET           : in     vl_logic;
        CLK             : in     vl_logic;
        Address         : out    vl_logic_vector(2 downto 0)
    );
end address_generator;
