library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity trabalho1 is
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
end trabalho1;

architecture calc of trabalho1 is

	signal s_A: signed(K-1 downto 0);
	signal s_B: signed(K-1 downto 0);
	signal s_res: signed(2*K-1 downto 0);

begin
	s_A <= signed(entradaA);
	s_B <= signed(entradaB);
	resposta <= std_logic_vector(s_res);

	process(clock) is
	begin
		if(rising_edge(clock)) then

			case sel is
				when "0000" => s_res <= resize(s_A + s_B, s_res'length);
				when "0001" => s_res <= resize(s_A - s_B, s_res'length);
				when "0010" => s_res <= resize(s_A * s_B, s_res'length);
				when "0011" => s_res <= resize(s_A / s_B, s_res'length);
				when "0100" => s_res <= resize(s_A rem s_B, s_res'length);
				when "0101" => s_res <= resize(s_A mod s_B, s_res'length);
				when "0110" => s_res <= resize(abs(s_A), s_res'length);
				when "0111" => s_res <= resize(not(s_A), s_res'length);
				when "1000" => s_res <= resize(s_A and s_B, s_res'length);
				when "1001" => s_res <= resize(s_A or s_B, s_res'length);
				when "1010" => s_res <= resize(s_A xor s_B, s_res'length);
				when others => s_res <= s_res;
			end case;
		end if;
	end process;
end calc;