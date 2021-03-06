library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.numeric_std.all;

library work;
use work.neurals_utils.all;

entity forget is
    Port (
        xt: in matrix_1_4;
        ht_1: in matrix_1_8;
        f: out matrix_1_8
    );
end forget;

architecture Behavioral of forget is

    signal wf: matrix_4_8 := (
    (-0.02987039,0.04314025,0.53898245,0.41512847,-0.80487585,-0.09355235,-0.41942886,-0.357487),
    (0.73685104,0.3203586,-0.49644002,-0.05589191,0.5361538,0.4786008,0.18015783,0.536344),
    (-0.27975634,-0.32213825,0.44963884,-0.1668127,-0.72459227,-0.5951743,-0.12105721,-0.8235756), 
    (-0.1605476,0.14743894,0.2773945,0.29888842,0.533289,0.8247989,0.08690736,0.56370485));

    signal uf: matrix_8_8 := (
    (0.12014879,-0.0524535,-0.12467378,-0.03299288,0.4924234,-0.24017411,0.03967816,0.35719723),
    (-0.1104935,0.12806204,0.16687083,0.3333305,-0.02045518,-0.16147594,-0.13974743,-0.38790867),
    (0.2634898,0.23817575,-0.07626809,0.05557626,-0.04142026,0.2815075,0.05502056,0.34272337),
    (-0.05009506,0.06229772,-0.0626516,0.45941448,-0.3453443,-0.3853578,-0.08171016,-0.05097225),
    (-0.23506312,0.12299766,0.18684718,-0.15129495,0.28006473,0.30475447,-0.1648891,0.2405248),
    (-0.059511,-0.04555352,-0.19750983,0.03688432,0.166731,0.14389813,0.19836815,-0.19307654),
    (-0.0608201,-0.6685579,-0.14629643,0.2732291,-0.1487119,-0.5028979,-0.19989286,-0.60279423),
    (-0.01670908,0.25028083,0.06285841,0.08058461,0.05506877,0.09961189,0.21074672,0.26627186));
    
    signal bf: matrix_1_8 := (
     1.1545736,
     1.2713808,
     1.0521708,
     1.2388046,
     1.3204008,
     1.2830889,
     1.1497107,
     1.1425042);
    
    signal xt_wf: matrix_1_8 := (others => 0.0);
    signal ht_1_uf: matrix_1_8 := (others => 0.0);
         
     
begin

    process
    variable temp : real := 0.0;
    begin
        F1: for i in 0 to 7 loop
            F2: for j in 0 to 3 loop
                temp := xt(j) * wf(j, i);
                xt_wf(i) <= xt_wf(i) + temp;  
            end loop F2;
        end loop F1;
        
        F3: for i in 0 to 7 loop
            F4: for j in 0 to 7 loop
                temp := ht_1(j) * uf(j, i);
                ht_1_uf(i) <= ht_1_uf(i) + temp;  
            end loop F4;
        end loop F3;
        
        F5: for i in 0 to 7 loop
            temp := bf(i) + ht_1_uf(i);
            f(i) <= temp + xt_wf(i);
        end loop F5;
            
    end process;
end Behavioral;
