library verilog;
use verilog.vl_types.all;
entity treg4bit is
    port(
        CLK             : in     vl_logic;
        RESET           : in     vl_logic;
        \IN\            : in     vl_logic_vector(3 downto 0);
        \OUT\           : out    vl_logic_vector(3 downto 0)
    );
end treg4bit;
