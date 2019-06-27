library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.numeric_std.all;

library work;
use work.neurals_utils.all;

entity matrix_sum is
    Port ( 
        a: in matrix_1_8;
        b: in matrix_1_8;
        c: out matrix_1_8;
        sum_ready: out std_logic
    );
end matrix_sum;

architecture Behavioral of matrix_sum is
begin
    F1: for i in 0 to 8 generate
        c(i) <= a(i) + b(i);
    end generate F1;
    sum_ready <= '1';
end Behavioral;
