library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

use work.parametros.all;

entity tb_projeto2 is
	generic(
		n: natural:= n;
		m: natural:= m
	);
end entity;

architecture sim of tb_projeto2 is
	component projeto2 is
		generic(
			n : natural;
			m : natural	
		);
		port(
			clock   : in std_logic;
			entrada : in std_logic_vector(n-1 downto 0);
			saida: out std_logic_vector(n-1 downto 0)
	    	);
	end component;	

	signal clock : std_logic;
	signal entrada : std_logic_vector(n-1 downto 0);
	signal saida : std_logic_vector(n-1 downto 0);

begin
proj2: projeto2
	generic map(
		n => n,
		m => m
	)
	port map(
		clock => clock,
		entrada => entrada,
		saida => saida
	);

	process is
	begin
		
		clock <= '0';
		wait for 1 ns;
		clock <= '1';
		wait for 1 ns;
	end process;

	process is
	begin
		for A in 0 to 2**n-1 loop

			entrada <= std_logic_vector(to_signed(A,entrada'length));

			wait for 2 ns;

		end loop;
	end process;
end architecture;
