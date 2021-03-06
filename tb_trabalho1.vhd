library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_trabalho1 is
	generic(
		K: natural := 8
	);
end entity;

architecture sim of tb_trabalho1 is
	component trabalho1 is
		generic(
			K: natural := 8
		);
		port(
		clock: in std_logic;
		entradaA: in std_logic_vector(K-1 downto 0);
		entradaB: in std_logic_vector(K-1 downto 0);
		sel: in std_logic_vector(3 downto 0);
		resposta: out std_logic_vector(2*K-1 downto 0)
		);
	end component;
	
	signal clock: std_logic;
	signal entradaA: std_logic_vector(K-1 downto 0);
	signal entradaB: std_logic_vector(K-1 downto 0);
	signal sel: std_logic_vector(3 downto 0);
	signal resposta: std_logic_vector(2*K-1 downto 0);

begin
ULA: trabalho1
	generic map(
		K => K
	)
	port map(
		clock => clock,
		entradaA => entradaA,
		entradaB => entradaB,
		sel => sel,
		resposta => resposta
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
		for A in 0 to 2**K-1 loop
			for B in 0 to 2**K-1 loop
				for OP in 0 to 10 loop
					sel <= std_logic_vector(to_unsigned(OP,sel'length));
					entradaA <= std_logic_vector(to_signed(A,entradaA'length));
					entradaB <= std_logic_vector(to_signed(B,entradaB'length));
					wait for 2 ns;
				end loop;
			end loop;
		end loop;
	end process;
end architecture;
	
