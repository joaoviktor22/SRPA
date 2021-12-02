library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_projeto5 is

end entity;

architecture sim of tb_projeto5 is
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

	process is
	begin
		wait for 2 ns;
		-- tempo parado antes de começar
		reset <= '0';
		primeiro <= '0';
		start <= '0';
		posicao <= "0000";
		joga <= '0';
		wait for 2 ns;
		reset <= '0';
		primeiro <= '0';
		start <= '1';
		wait for 2 ns;
		posicao <= "0100";--4
		joga <= '1';
		wait for 2 ns;
		posicao <= "0001";--1
		joga <= '1';
		wait for 2 ns;
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		primeiro <= '0';
		start <= '1';
		wait for 2 ns;
		posicao <= "0001";--1
		joga <= '1';
		wait for 4 ns;
		posicao <= "0011";--3
		joga <= '1';
		wait for 4 ns;
		posicao <= "1001";--9 ESCOLHA RUIM
		joga <= '1';
		wait for 4 ns;--PERDI
		wait for 2 ns;--ESPERAR FINALIZAR--ESPERAR MAQUINA JOGAR E GANHAR DEMORA
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		primeiro <= '0';
		start <= '1';
		wait for 2 ns;
		posicao <= "0001";--1
		joga <= '1';
		wait for 4 ns;
		posicao <= "0011";--3
		joga <= '1';
		wait for 4 ns;
		posicao <= "1000";--8
		joga <= '1';
		wait for 4 ns;
		posicao <= "0110";--6
		joga <= '1';
		wait for 4 ns;
		posicao <= "0111";--7-naoehpossivel
		joga <= '1';
		wait for 4 ns;
		posicao <= "0100";--4--lugar que sobrou
		joga <= '1';
		wait for 4 ns;--EMPATE
		--wait for 2 ns;--ESPERAR FINALIZAR
		reset <= '1';
		wait for 2 ns;
		wait for 2 ns;--ESPERAR FINALIZAR
		reset <= '0';
		primeiro <= '0';
		start <= '1';
		wait for 2 ns;
		posicao <= "0111";--7
		joga <= '1';
		wait for 4 ns;
		posicao <= "0011";--3
		joga <= '1';
		wait for 4 ns;
		posicao <= "0001";--1
		joga <= '1';
		wait for 4 ns;
		posicao <= "0100";--4 AE GANHOU
		joga <= '1';
		wait for 4 ns;
	end process;


	

end architecture;