library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.numeric_std.all;

library work;
use work.neurals_utils.all;

entity dot_product is
    Port ( 
        a: in matrix_1_8;
        b: in matrix_1_8;
        c: out matrix_1_8;
        dot_ready: out std_logic

    );
end dot_product;

architecture Behavioral of dot_product is
begin
    F1: for i in 0 to 7 generate
        c(i) <= a(i) * b(i);
        j <= j + i;
    end generate F1;
    dot_ready <= '1';
end Behavioral;
