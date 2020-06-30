


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
--use UNISIM.VComponents.all ;

entity user is
    Port (
           clk : in STD_LOGIC; -- Sinal de clock
           reset : in STD_LOGIC; -- Sinal de reset
           sw : in STD_LOGIC_VECTOR (15 downto 0); -- Sinal para as 16 chaves
           buttons : in STD_LOGIC_VECTOR(3 downto 0); -- Sinais para os 4 botões
           led : out STD_LOGIC_VECTOR (15 downto 0); --Sinal para os 16 LEDs
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- Sinal para o estado do Display
           an : out STD_LOGIC_VECTOR (7 downto 0); -- Sinal para o estado dos anodos
           dp: out STD_LOGIC); -- Sinal para o estado do ponto dos Display
end user;


architecture Behavioral of user is

signal clk_div : std_logic := '0';
signal cnt_div : std_logic_vector(25 downto 0) := (others=>'0');
signal count : std_logic_vector(3 downto 0) := "0000";
signal s_led : std_logic_vector(3 downto 0):= "0000";
constant pseget : std_logic_vector(25 downto 0) := "10111110101111000001111111";


begin

 dp<='0';
 led(3 downto 0)<=count;
 led(11 downto 8)<="1111"-count;
 an<="00111111";
    
 process(clk,reset)  
    begin
        if rising_edge(clk) then
            if reset='1' then
                clk_div <= '0';
                cnt_div <= (others=>'0');
            elsif cnt_div = pseget then
                clk_div <= not clk_div;
                cnt_div <= (others=>'0');
            else
                cnt_div <= cnt_div + '1';
            end if;                
--            if cnt_div = "0000000...01" then
--                clk_div <= not clk_div;
--                cnt_div <= (others=>'0');
--            end if;
        end if;
    end process; 
    
    process(clk_div,reset)
    begin
        if rising_edge(clk_div) then
            if reset = '1' then
                count <= "0000";
            elsif count="1111" then
                count <= "0000";
            else
                count <= count+'1';
            end if;
        end if;
    end process; 
    
    
    process(count)
    begin
        case count is
          --when "xxxx" => seg <= "pgfedcba";
            when "0000" => seg <= "1000000"; --0
            when "0001" => seg <= "1111001"; --1
            when "0010" => seg <= "0100100"; --2
            when "0011" => seg <= "0110000"; --3
            when "0100" => seg <= "0011001"; --4
            when "0101" => seg <= "0010010"; --5
            when "0110" => seg <= "0000010"; --6
            when "0111" => seg <= "1111000"; --7
            when "1000" => seg <= "0000000"; --8
            when "1001" => seg <= "0010000"; --9
            when "1010" => seg <= "0001000"; --A
            when "1011" => seg <= "0000011"; --B
            when "1100" => seg <= "1000110"; --C
            when "1101" => seg <= "0100001"; --D
            when "1110" => seg <= "0000110"; --E
            when "1111" => seg <= "0001110"; --F
            when others => seg <= "1111111"; --outros casos
        end case;
    end process;


end Behavioral;
