library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.numeric_std.all;

library work;
use work.neurals_utils.all;

entity LSTM_Structure is
  Port(
      clk: in std_logic;
      rst: in std_logic;
      enable_x : in std_logic;
      enable_ht_1 : in std_logic;
      enable_ct_1 : in std_logic;
      ct_1: in real;
      ht_1: in real;
      xt1: in real;
      xt2: in real;
      xt3: in real;
      xt4: in real;
      xt5: in real;
      sigmoid1: out real;
      sigmoid2: out real
      );
end LSTM_Structure;

architecture Behavioral of LSTM_Structure is

    component cell is
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
    end component;

    component classify is
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
    end component;
    
    type ct_array is array(0 to 4) of real;
    type enable_ct_array is array(0 to 4) of std_logic;
    type ht_array is array(0 to 4) of real;
    type enable_ht_array is array(0 to 4) of std_logic;
      
    signal cts: ct_array := (others => 0.0);
    signal cts_enable: enable_ct_array := (others => '0');
    signal hts: ht_array := (others => 0.0);
    signal hts_enable: enable_ht_array := (others => '0');  

begin
    
    first_cell: cell port map(
    clk => clk,
    rst => rst,
    enable_x => enable_x,
    enable_ht_1 => enable_ht_1,
    enable_ct_1 => enable_ct_1,
    ct_1 => ct_1,
    ht_1 => ht_1,
    xt => xt1,
    ct => cts(0),
    ht => hts(0),
    enable_ct => cts_enable(0),
    enable_ht => hts_enable(0)    
    );
    
    second_cell: cell port map(
    clk => clk,
    rst => rst,
    enable_x => enable_x,
    enable_ht_1 => hts_enable(0),
    enable_ct_1 => cts_enable(0),
    ct_1 => cts(0),
    ht_1 => hts(0),
    xt => xt2,
    ct => cts(1),
    ht => hts(1),
    enable_ct => cts_enable(1),
    enable_ht => hts_enable(1)    
    );    
    
    third_cell: cell port map(
    clk => clk,
    rst => rst,
    enable_x => enable_x,
    enable_ht_1 => hts_enable(1),
    enable_ct_1 => cts_enable(1),
    ct_1 => cts(1),
    ht_1 => hts(1),
    xt => xt3,
    ct => cts(2),
    ht => hts(2),
    enable_ct => cts_enable(2),
    enable_ht => hts_enable(2)    
    );    
    
    fourth_cell: cell port map(
    clk => clk,
    rst => rst,
    enable_x => enable_x,
    enable_ht_1 => hts_enable(2),
    enable_ct_1 => cts_enable(2),
    ct_1 => cts(2),
    ht_1 => hts(2),
    xt => xt4,
    ct => cts(3),
    ht => hts(3),
    enable_ct => cts_enable(3),
    enable_ht => hts_enable(3)    
    );    
    
    fifth_cell: cell port map(
    clk => clk,
    rst => rst,
    enable_x => enable_x,
    enable_ht_1 => hts_enable(3),
    enable_ct_1 => cts_enable(3),
    ct_1 => cts(3),
    ht_1 => hts(3),
    xt => xt5,
    ct => cts(4),
    ht => hts(4),
    enable_ct => cts_enable(4),
    enable_ht => hts_enable(4)    
    );
    
    classifying: classify port map (
    clk => clk,
    rst => rst,
    enable_ht => '1',
    ht => ht(4),
    first_sigmoid => sigmoid1,
    second_sigmoid => sigmoid2    
    );
    
end Behavioral;