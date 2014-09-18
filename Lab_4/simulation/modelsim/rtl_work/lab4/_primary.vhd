library verilog;
use verilog.vl_types.all;
entity lab4 is
    port(
        CLK50           : in     vl_logic;
        RESET           : in     vl_logic;
        CLK_SEL         : in     vl_logic_vector(2 downto 0);
        \NEXT\          : in     vl_logic;
        PLAYER_A        : in     vl_logic;
        PLAYER_B        : in     vl_logic;
        TEST_LOAD       : in     vl_logic;
        \SIGNAL\        : out    vl_logic;
        SCORE_A         : out    vl_logic_vector(3 downto 0);
        SCORE_B         : out    vl_logic_vector(3 downto 0);
        A_INC           : out    vl_logic;
        B_INC           : out    vl_logic;
        WINNER          : out    vl_logic_vector(3 downto 0);
        STATE           : out    vl_logic_vector(3 downto 0);
        FALSE_START     : out    vl_logic;
        ADDRESS         : out    vl_logic_vector(2 downto 0);
        DATA            : out    vl_logic_vector(9 downto 0);
        CLK             : out    vl_logic;
        LEDARRAYRED     : out    vl_logic_vector(17 downto 0);
        LEDARRAYGREEN   : out    vl_logic_vector(8 downto 0);
        HEX7            : out    vl_logic_vector(6 downto 0);
        HEX6            : out    vl_logic_vector(6 downto 0);
        HEX5            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0);
        LOAD_MUX        : out    vl_logic
    );
end lab4;
