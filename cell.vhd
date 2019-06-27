library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.numeric_std.all;

library work;
use work.neurals_utils.all;

entity cell is
    Generic (
      input_x_rows : integer := 1;
      input_x_cols : integer := 4;
      input_c_rows : integer := 1;
      input_c_cols : integer := 8;
      input_h_rows : integer := 1;
      input_h_cols : integer := 8
    );
    Port(
        clk: in std_logic;
        rst: in std_logic;
        enable_x : in std_logic;
        enable_ht_1 : in std_logic;
        enable_ct_1 : in std_logic;
        ct_1: in real;
        ht_1: in real;
        xt: in real;
        ct: out real;
        ht: out real;
        enable_ct: inout std_logic;
        enable_ht: inout std_logic
    );
end cell;

architecture Behavioral of cell is

    signal xt_matrix: matrix_1_4 := (others => 0.0);
    signal ht_1_matrix: matrix_1_8 := (others => 0.0);
    signal ct_1_matrix: matrix_1_8 := (others => 0.0);
    signal ct_matrix: matrix_1_8 := (others => 0.0);
    signal ht_matrix: matrix_1_8 := (others => 0.0);
    
    signal x_ready : std_logic;
    signal h_ready : std_logic;
    signal ct_1_ready : std_logic;
    signal ct_ready : std_logic;
  
    signal f: matrix_1_8;
    signal inp: matrix_1_8;
    signal o: matrix_1_8;
    signal cnd: matrix_1_8;
    
    signal ft: matrix_1_8;
    signal it: matrix_1_8;
    signal ot: matrix_1_8;
    signal cndt: matrix_1_8;
    
    signal d1: matrix_1_8 := (others => 0.0);
    signal d1r: std_logic := '0';
    signal d2: matrix_1_8 := (others => 0.0);
    signal d2r: std_logic := '0';
    signal t1: matrix_1_8 := (others => 0.0);
    signal s1: matrix_1_8 := (others => 0.0);
    signal s1r: std_logic := '0';
    signal d3r: std_logic := '0';
    
    component forget is
    Port (
        xt: in matrix_1_4;
        ht_1: in matrix_1_8;
        f: out matrix_1_8
    );
    end component;

    component input is
    Port (
        xt: in matrix_1_4;
        ht_1: in matrix_1_8;
        i: out matrix_1_8
    );
    end component;
    
    component candidate is
    Port (
        xt: in matrix_1_4;
        ht_1: in matrix_1_8;
        cnd: out matrix_1_8
    );
    end component;

    component output is
    Port (
        xt: in matrix_1_4;
        ht_1: in matrix_1_8;
        o: out matrix_1_8
    );
    end component;
    
    component sigmoid_module is
    Port (
           clk : in std_logic;
           enable : in std_logic;
           input : in real;
           output : out real);
    end component;
    
    component tanh_module is
    Port (
           clk : in std_logic;
           enable : in std_logic;
           input : in real;
           output : out real);
    end component;

    component dot_product is
    Port ( 
        a: in matrix_1_8;
        b: in matrix_1_8;
        c: out matrix_1_8;
        dot_ready: std_logic
    );
    end component;
    
    component matrix_sum is
    Port ( 
        a: in matrix_1_8;
        b: in matrix_1_8;
        c: out matrix_1_8;
        sum_ready: out std_logic
    );
    end component;
    
begin

    process(clk)
    variable i : integer := 0;
    begin
        if rising_edge(clk) then
            if rst='1' then --if rst = 1 then reset the memories for a 
                x_ready <= '0';
            elsif enable_x = '1' then --else read a column till one columns of firstmem is full
                if(x_ready = '0') then
                    xt_matrix(i) <= xt;
                    i := i+1;
                end if;
            end if;
            if(i = input_x_cols) then  --if all columns are read, a is ready 
                x_ready <= '1' ;
            end if;
        end if;
    end process;

    process(clk)
    variable i : integer := 0;
    begin
        if rising_edge(clk) then
            if rst='1' then --if rst = 1 then reset the memories for a 
                h_ready <= '0';
            elsif enable_ht_1 = '1' then --else read a column till one columns of firstmem is full
                if(h_ready = '0') then
                    ht_1_matrix(i) <= ht_1;
                    i := i+1;
                end if;
            end if;
            if(i = input_h_cols) then  --if all columns are read, a is ready 
                h_ready <= '1' ;
            end if;
        end if;
    end process;
    
    process(clk)
    variable i : integer := 0;
    begin
        if rising_edge(clk) then
            if rst='1' then --if rst = 1 then reset the memories for a 
                ct_1_ready <= '0';
            elsif enable_ct_1 = '1' then --else read a column till one columns of firstmem is full
                if(ct_1_ready = '0') then
                    ct_1_matrix(i) <= ct_1;
                    i := i+1;
                end if;
            end if;
            if(i = input_c_cols) then  --if all columns are read, a is ready 
                ct_1_ready <= '1' ;
            end if;
        end if;
    end process;
    
    IF1: if(x_ready = '1' and h_ready = '1' and ct_1_ready = '1') generate
        frgt: forget port map (xt => xt_matrix, ht_1 => ht_1_matrix, f => f);    
        op: output port map (xt => xt_matrix, ht_1 => ht_1_matrix, o => o);
        cnddt: candidate port map (xt => xt_matrix, ht_1 => ht_1_matrix, cnd => cnd);
        ip: input port map (xt => xt_matrix, ht_1 => ht_1_matrix, i => inp);
        F1: for i in 0 to 8 generate
            ft_sigmoid: sigmoid_module port map (clk => clk, enable => '1', input => f(i), output => ft(i));
        end generate F1;
        F2: for i in 0 to 8 generate
            it_sigmoid: sigmoid_module port map (clk => clk, enable => '1', input => inp(i), output => it(i));
        end generate F2;
        F3: for i in 0 to 8 generate
            ot_sigmoid: sigmoid_module port map (clk => clk, enable => '1', input => o(i), output => ot(i));
        end generate F3;
        F4: for i in 0 to 8 generate
            cndt_tanh_1: tanh_module port map (clk => clk, enable => '1', input => cnd(i), output => cndt(i));
        end generate F4;
        
        dot1: dot_product port map(a => ct_1_matrix, b => ft, c => d1, dot_ready => d1r);
        dot2: dot_product port map(a => it, b => cndt, c => d2, dot_ready => d2r);
        sum1: matrix_sum port map(a => d1, b => d2, c => s1, sum_ready => s1r);
        ct_matrix <= s1;
        F5: for i in 0 to 8 generate
            final_tanh: tanh_module port map (clk => clk, enable => '1', input => s1(i), output => t1(i));
        end generate F5;
        dot3: dot_product port map(a => t1,b => ot, c => ht_matrix, dot_ready => d3r);
    end generate;
    
    process(s1r)
    variable i : integer := 0;
    begin
        if rising_edge(clk) then
            if rst='1' then --if rst = 1 then reset the memories for a 
                enable_ct <= '0';
            elsif s1r = '1' then --else read a column till one columns of firstmem is full
                if(enable_ct = '0') then
                    ct <= ct_matrix(i);
                    i := i+1;
                end if;
            end if;
            if(i = input_c_cols) then  --if all columns are read, a is ready 
                enable_ct <= '1' ;
            end if;
        end if;    
    end process;
    
    process(d3r)
    variable i : integer := 0;
    begin
        if rising_edge(clk) then
            if rst='1' then --if rst = 1 then reset the memories for a 
                enable_ht <= '0';
            elsif d3r = '1' then --else read a column till one columns of firstmem is full
                if(enable_ht = '0') then
                    ht <= ht_matrix(i);
                    i := i+1;
                end if;
            end if;
            if(i = input_h_cols) then  --if all columns are read, a is ready 
                enable_ht <= '1' ;
            end if;
        end if;    
    end process;
    
end Behavioral;
