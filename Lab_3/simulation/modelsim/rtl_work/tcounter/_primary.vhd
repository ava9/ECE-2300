library verilog;
use verilog.vl_types.all;
entity tcounter is
    port(
        CLK             : in     vl_logic;
        CLR             : in     vl_logic;
        ENP             : in     vl_logic;
        ENT             : in     vl_logic;
        Q               : out    vl_logic_vector(3 downto 0)
    );
end tcounter;
