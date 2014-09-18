library verilog;
use verilog.vl_types.all;
entity lab3 is
    port(
        CLK50           : in     vl_logic;
        RESET           : in     vl_logic;
        CLK_SEL         : in     vl_logic_vector(2 downto 0);
        ENABLE          : in     vl_logic;
        TIME            : out    vl_logic_vector(19 downto 0);
        CLK             : out    vl_logic;
        HEX7            : out    vl_logic_vector(6 downto 0);
        HEX6            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0)
    );
end lab3;
