library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package my_package is

	function conferindo(	velha : std_logic_vector(8 downto 0))--funcao que confere se a partida acabou
			return std_logic;

end package my_package;

package body my_package is

	function conferindo(	velha : std_logic_vector(8 downto 0))
			return std_logic is
		variable acabou : std_logic := '0';
	begin
		if(velha(0) = '1' and velha(1) = '1' and velha(2) = '1') then
			acabou := '1';
		elsif(velha(3) = '1' and velha(4) = '1' and velha(5) = '1') then
			acabou := '1';
		elsif(velha(6) = '1' and velha(7) = '1' and velha(8) = '1') then
			acabou := '1';	
		elsif(velha(0) = '1' and velha(3) = '1' and velha(6) = '1') then
			acabou := '1';
		elsif(velha(1) = '1' and velha(4) = '1' and velha(7) = '1') then
			acabou := '1';
		elsif(velha(2) = '1' and velha(5) = '1' and velha(8) = '1') then
			acabou := '1';
		elsif(velha(0) = '1' and velha(4) = '1' and velha(8) = '1') then
			acabou := '1';
		elsif(velha(2) = '1' and velha(4) = '1' and velha(6) = '1') then
			acabou := '1';
		else
			acabou := '0';
		end if;	
		return acabou;
	end function;

end;
