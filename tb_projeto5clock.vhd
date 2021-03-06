library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_projeto5clock is

end entity;

architecture sim of tb_projeto5clock is
	component jogodavelha is
		port(
			clk     : in std_logic; 
			reset   : in std_logic; 
			start : in std_logic;
			primeiro : in std_logic;
			posicao: in std_logic_vector(3 downto 0);
			joga : in std_logic;
			maquina: out std_logic_vector(3 downto 0);
			fim: out std_logic;
			win: out std_logic_vector(1 downto 0)
    		);
	end component;	

	signal clk     : std_logic; 
	signal reset   : std_logic; 
	signal primeiro : std_logic;
	signal start : std_logic;
	signal posicao: std_logic_vector(3 downto 0);
	signal joga : std_logic;
	signal maquina: std_logic_vector(3 downto 0);
	signal fim: std_logic;
	signal win: std_logic_vector(1 downto 0);

begin
projeto5: jogodavelha
	port map(
		clk => clk,
		reset => reset,
		primeiro => primeiro,
		start => start,
		posicao => posicao,
		joga => joga,
		maquina => maquina,
		fim => fim,
		win => win
	);

	process is
	begin
		
		clk <= '0';
		wait for 1 ns;
		clk <= '1';
		wait for 1 ns;
	end process;
end architecture;
