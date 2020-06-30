


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
           an : out STD_LOGIC_VECTOR (3 downto 0); -- Sinal para o estado dos anodos
           dp: out STD_LOGIC); -- Sinal para o estado do ponto dos Display
end user;


architecture Behavioral of user is


--Sinais do usuário

begin

--Lógica do usuário

end Behavioral;
