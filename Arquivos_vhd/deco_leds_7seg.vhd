----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.06.2018 16:34:26
-- Design Name: 
-- Module Name: leds_7seg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_arith.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity deco_leds_7seg is
    Port ( clk : in STD_LOGIC;  
           reset : in STD_LOGIC;
           tx_ready : in STD_LOGIC;
           led : in STD_LOGIC_VECTOR (15 downto 0);
           seg : in STD_LOGIC_VECTOR (6 downto 0);
           dp : in STD_LOGIC;
           an : in STD_LOGIC_VECTOR (7 downto 0);
           start : out STD_LOGIC;
           data_in : out STD_LOGIC_VECTOR (7 downto 0));
end deco_leds_7seg;

architecture Behavioral of deco_leds_7seg is

constant preset: STD_LOGIC_VECTOR(17 downto 0):="100100100111101111"; --1.5ms
signal count: STD_LOGIC_VECTOR(17 downto 0):=(others=>'0');
signal s_tx_ready : std_logic :='1';
signal s_mux : std_logic_vector(2 downto 0) := (others=>'0');
signal l_led : std_logic_vector(7 downto 0) :=(others=>'0');
signal m_led : std_logic_vector(7 downto 0) :=(others=>'0');
signal s_seg : std_logic_vector(7 downto 0) :=(others=>'0');
signal s_an : std_logic_vector(7 downto 0) :=(others=>'0');
signal s_start : std_logic:='0';
--signal s_data_in : std_logic_vector(7 downto 0) :=(others=>'0');


begin


s_tx_ready<=tx_ready;
l_led <= led(7 downto 0);
m_led <= led(15 downto 8);
s_seg <= seg&dp;
s_an<=an;
start<=s_start;
--data_in<=s_data_in;

process(clk,reset,s_tx_ready,s_start)
begin
    if rising_edge(clk) then
        if reset='1' then
            count<=(others=>'0');
            s_mux<="000";
            s_start<='0';
        else
            if count=preset then
                s_start<='1';
                s_mux<=s_mux+1;         
                count<=(others=>'0');
            elsif s_tx_ready='1' and s_start='1' then
                s_start<='0';
                count<=count+1;
--                case s_mux is
--                    when "00" => s_data_in <= l_led;
--                    when "01" => s_data_in <= m_led; 
--                    when "10" => s_data_in <= s_an; 
--                    when "11" => s_data_in <= s_seg; 
--                    when others => s_data_in <= (others=>'0');
--                end case;

             else 
                count<=count+1;
            end if;
        end if;
    end if;
end process;

with s_mux select
data_in <=   "01010110" when "000", -- V
             l_led when "001",
             "01010111" when "010" ,-- W 
             m_led when "011" ,
             "01011000" when "100", -- X
             s_an when "101",
             "01011001" when "110", -- Y
             s_seg when "111",
             "00000000" when others;
             
--process(clk,reset,l_led,m_led,s_an,s_seg,s_tx_ready,s_start)
----begin
--    if rising_edge(clk) then
--        if reset='1' then
--            count<=(others=>'0');
--            s_data_in<=l_led;
--            s_mux<="00";
--            s_start<='0';
--            count2<=(others=>'0');
--        else
--            if count=preset then
--                s_start<='1';
--                s_mux<=s_mux+1;         
--                count<=(others=>'0');
--            else
--                count<=count+1;
--                if s_start<='1' then
--                    count2<=count2+1;
--                      if count2<=4 then
                
--                    end if;
--                end if            
--             end if;
--        end if;
--    end if;
--end process;


end Behavioral;


