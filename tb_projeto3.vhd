library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_timer is

end entity;

architecture sim of tb_timer is
	component dut_timer is
		port(
			clk     : in std_logic;
			reset   : in std_logic;
			enable  : in std_logic;
			updown  : in std_logic;
			contagem: out std_logic_vector(5 downto 0)
    		);
	end component;	

	signal clk   : std_logic;
	signal reset : std_logic;
	signal enable: std_logic;
	signal updown: std_logic;
	signal contagem: std_logic_vector(5 downto 0);

begin
my_timer: dut_timer
	port map(
		clk => clk,
		reset => reset,
		enable => enable,
		updown => updown,
		contagem => contagem
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
		-- zera e desabilita a contagem
		reset <= '1';
		enable <= '0';
		updown <= '0';
		wait for 6 ns;
		reset <= '0';
		enable <= '1';
		updown <= '0';
		wait for 32 ns;
		reset <= '0';
		enable <= '0';
		updown <= '0';
		wait for 16 ns;
		reset <= '0';
		enable <= '1';
		updown <= '1';
		wait for 16 ns;
		reset <= '0';
		enable <= '1';
		updown <= '0';
		wait for 8 ns;
		reset <= '1';
		enable <= '1';
		updown <= '1';
		wait for 6 ns;
		reset <= '0';
		enable <= '1';
		updown <= '0';
		wait for 130 ns;
		reset <= '0';
		enable <= '1';
		updown <= '1';
		wait for 130 ns;
		wait;		

	end process;


	

end architecture;
