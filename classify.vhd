library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.numeric_std.all;

library work;
use work.neurals_utils.all;

entity classify is
    Generic (
      input_h_rows : integer := 1;
      input_h_cols : integer := 8
    );
    Port (
        clk: in std_logic;
        rst: in std_logic;
        enable_ht: in std_logic;
        ht: in real;
        first_sigmoid: out real;
        second_sigmoid: out real
    );
end classify;

architecture Behavioral of classify is

    signal output_weights: matrix_8_2 := (
    (1.0394741,-1.113635),
    (-0.8161245,1.3644532),
    (-0.8602668,0.8385718), 
    (0.01399208,0.6809298),
    (0.9627248,-1.0659114 ),
    (1.4139701,-1.3464441),
    (0.03614046,1.0304761 ),
    (1.0350043,-0.89600146));

    signal output_biases: matrix_1_2 := (-0.3260368,-0.0219169);
    
    signal ht_ow: matrix_1_2 := (others => 0.0);
    signal final: matrix_1_2 := (others => 0.0);
         
        component sigmoid_module is
    Port (
           clk : in std_logic;
           enable : in std_logic;
           input : in real;
           output : out real);
    end component;
     
    signal flag : std_logic := '0'; 
     
    signal ht_matrix: matrix_1_8 := (others => 0.0);
    signal h_ready : std_logic;
     
begin
    process(clk)
    variable i : integer := 0;
    begin
        if rising_edge(clk) then
            if rst='1' then --if rst = 1 then reset the memories for a 
                h_ready <= '0';
            elsif enable_ht = '1' then --else read a column till one columns of firstmem is full
                if(h_ready = '0') then
                    ht_matrix(i) <= ht;
                    i := i+1;
                end if;
            end if;
            if(i = input_h_cols) then  --if all columns are read, a is ready 
                h_ready <= '1' ;
            end if;
        end if;
    end process;
    
    process(h_ready)
    variable temp : real := 0.0;
    begin
        IF1: if(h_ready = '1') then
            F1: for i in 0 to 1 loop
                F2: for j in 0 to 7 loop
                    temp := ht_matrix(j) * output_weights(j, i);
                    ht_ow(i) <= ht_ow(i) + temp;  
                end loop F2;
            end loop F1;
            F3: for i in 0 to 1 loop
                final(i) <= ht_ow(i) + output_biases(i);
            end loop F3;
            flag <= '1';
        end if IF1;
    end process;
    IF1: if(flag = '1') generate
        final_sigmoid1: sigmoid_module port map (clk => clk, enable => '1', input => final(0), output => first_sigmoid);
        final_sigmoid2: sigmoid_module port map (clk => clk, enable => '1', input => final(1), output => second_sigmoid);
    end generate IF1;
end Behavioral;
