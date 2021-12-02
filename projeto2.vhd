library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.parametros.all;

entity projeto2 is
	generic(
		n : natural:= n;
		m : natural:= m
	);
	port(
		clock : in std_logic;	
		entrada : in std_logic_vector(n-1 downto 0);
		saida : out std_logic_vector(n-1 downto 0)
    );
end projeto2;

architecture basic of projeto2 is

	type vm is array (m-1 downto 0)
	of signed(n-1 downto 0);

	signal v : vm;

	signal s_entrada: signed(n-1 downto 0);
	signal s_saida: signed(n-1 downto 0);

begin
	s_entrada <= signed(entrada);
	saida <= std_logic_vector(s_saida);
	process(clock)
	variable soma : signed(n-1 downto 0);
	begin
		soma := (others => '0');
		if rising_edge(clock) then
			v(0) <= s_entrada;
			v(m-1 downto 1) <= v(m-2 downto 0); 
			for x in 0 to m-1 loop
				soma := signed(soma) + signed(v(x));
			end loop;
			s_saida <= resize(soma / m, s_saida'length);
		end if;
	end process;

end basic;