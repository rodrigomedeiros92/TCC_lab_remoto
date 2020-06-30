-------------------------------------------------
-- Company:       FGA-UnB
-- Engineer:      DANIEL MAURICIO MUÑOZ ARBOLEDA
-- 
-- Create Date:   18-Sep-2013
-- Description:   envia a entrada de 1 byte (|'O'/'X'|posicao|) atraves da porta RS232 (pin "dout")
--                recebe o comando enviado desde o PC pelo pino "din"
--                opera a 100MHz, 9600 bps, no parity, 1 stop bit
-- Automatically generated using the vHPSOgen.m v1.0
-- Modificate in 20-05-2018 by Rodrigo Bonifácio de Medeiros  (Retirado o sinal ready_data
-- para a arquitetura do lab remoto e acréscimo do tx_ready sinalizando o fim do recebimento de dados,
-- Mudança de nomes de alguns sinais e entradas e saídas).
--V 2.0


-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity serialcom is
port(reset		  :  in std_logic;
	  clk 		  :  in std_logic;
	  start   	  :  in std_logic;
      data_in     :  in std_logic_vector(7 downto 0);
	  rx    	  :  in std_logic;
	  data_out    : out std_logic_vector(7 downto 0);
	  tx_ready    : out std_logic;
	  tx        : out std_logic);
end serialcom;

architecture comportamental of serialcom is

signal clk9600	 : std_logic;	-- clk de trabalho
signal reg9600	 : std_logic_vector(12 downto 0) := "1010001001111"; -- clk 100MHz
signal Reg_R    : std_logic_vector(10 downto 0) := (others=>'0');
signal srx     : std_logic;
signal load     : std_logic := '0';
signal count    : std_logic_vector(5 downto 0):=(others=>'0');
signal ena      : std_logic := '0';
signal err      : std_logic := '0';
signal aux_data : std_logic_vector(7 downto 0) := (others => '0');
signal aux_dv   : std_logic := '0';
signal aux_lock : std_logic := '0';
signal s_tx_ready : std_logic :='0';


begin

tx_ready<=s_tx_ready;
srx <= not rx;

---------- Divisor de Clk 9600bps-----------------------
gera9600bps: process(reset,clk)
begin
   if rising_edge(clk) then
       if reset='1' then
           reg9600	<=	"1010001001111"; --9600 bps at clk=100MHz 
--         reg9600	<= "0101000100111"; --9600 bps at clk=50MHz
           clk9600   <= '0';
       else
			reg9600 <= reg9600 - 1;
			if reg9600 = "000000000000" then
               clk9600	<= not(clk9600);
				reg9600	<= "1010001001111"; --clk=100MHz
--				reg9600	<= "0101000100111"; --clk=50MHz
			end if;
		end if;
   end if;
end process gera9600bps;

------------ Paraleliza o Dato Serial -------------
------------ Paraleliza o Dato Serial -------------
process (reset,clk9600)
variable count: integer range 0 to 10;
variable reg: std_logic_vector (10 downto 0);
variable temp : std_logic := '0';
begin
   if (clk9600'EVENT and clk9600='1') then
       if reset='1' then
           count:=0;
           reg := (reg'RANGE => '0');
           temp := '0';
           aux_dv     <= '0';
           aux_data   <= "00000000";
       else
           aux_dv     <= '0';
           if (reg(0)='0' and srx='1') then
               reg(0) := '1';
           elsif (reg(0)='1') then
               count := count + 1;
               if (count < 10) then
                   reg(count) := srx;
               elsif (count = 10) then
                   temp := (reg(1) xor reg(2) xor reg(3) xor
                           reg(4) xor reg(5) xor reg(6) xor
                           reg(7) xor reg(8)) and reg(9);
                   count := 0;
                   reg(0) := srx;
                   if (temp = '0') then
                       aux_data <= reg(8 downto 1);
                       aux_dv     <= '1';
                   end if;
               end if;
           end if;
       end if;
   end if;
end process;

process(reset,clk,aux_dv)
begin
   if rising_edge(clk) then
		if reset = '1' then
			aux_lock <= '0';
			data_out <= (others=>'0');
		else
			if aux_dv = '1' and aux_lock = '0' then
				aux_lock <= '1';
				data_out    <= aux_data;

			elsif aux_dv = '0' then
				aux_lock <= '0';
	
			else
	
			end if;
		end if;
   end if;
end process;
--------- Serializa o Dato Paralelo -------------
process (reset,clk9600,start)
begin
   if rising_edge(clk9600) then
		if reset='1' then
			Reg_R <= (others => '1');
			count <= (others => '0');
			ena   <= '0';
		else
			if start='1' then
		        s_tx_ready<='1';
				ena   <= '1';
				count <= (others => '0');
				Reg_R(1)  <= '0'; -- start bit
				Reg_R(10) <= '1'; -- bit de parada
				Reg_R(9 downto 2) <= data_in(7 downto 0); 
			elsif count = "001011" then  -- if count = 11 then
				s_tx_ready<='0';
				ena   <= '0';
				count <= (others => '0');
				Reg_R <= (others => '1');
			elsif count < "001011" and ena = '1' then -- if count < 11 AND enable 
				count <= count+'1';
				Reg_R <= '1'&Reg_R(10 downto 1);
			end if;
		end if;
   end if;
end process;

tx <= Reg_R(0);

process(reset,clk,start)
begin
   if rising_edge(clk) then
		if reset = '1' then
			load <= '0';
		else
			if start = '1' then
				load <= '1';
			else
				load <= '0';
			end if;
		end if;
   end if;
end process;

end comportamental;
