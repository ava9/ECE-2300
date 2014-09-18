library verilog;
use verilog.vl_types.all;
entity hex_to_seven_seg is
    port(
        B               : in     vl_logic_vector(3 downto 0);
        SSEG_L          : out    vl_logic_vector(6 downto 0)
    );
end hex_to_seven_seg;
