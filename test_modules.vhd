library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.numeric_std.all;


entity tb_modules is
end tb_modules;

architecture Behavioral of tb_modules is

    component add_module is
        Port (
           inputx : in real;
           inputy : in real;
           output : out real);
    end component;
    component multiplier_module is
        Port (
       inputx : in real;
       inputy : in real;
       output : out real);
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
   signal clk :  std_logic := '0';
   signal enable :  std_logic := '0';
   signal inputx :  real;
   signal   inputy :  real;
   signal   output_add :  real;
   signal   output_mult :  real;
   signal   output_tanh :  real;
   signal   output_sigmoid :  real;
begin
      
    inputx <= 2.25, -13.4 after 200 ns;
    inputy <= 8.4, 29.4 after 200 ns;
    clk <= not clk after 10 ns;
    enable <= '1';
    adder_ut : add_module Port map (
            inputx => inputx,
            inputy => inputy,
            output => output_add);
    mult_ut : multiplier_module Port map (
            inputx => inputx,
            inputy => inputy,
            output => output_mult);
 
    sigmoid_ut : sigmoid_module Port map (
                clk => clk,
                enable => enable,
                input => inputx,
                output => output_sigmoid);
    tanh_ut : tanh_module Port map (
                clk => clk,
                enable => enable,
                input => inputx,
                output => output_tanh);           
end Behavioral;

