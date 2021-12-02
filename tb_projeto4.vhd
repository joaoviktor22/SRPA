library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_projeto4 is

end entity;

architecture sim of tb_projeto4 is
	component maquina is
		port(
		clk     : in std_logic;
		confirmar   : in std_logic;
		colocando : in std_logic;
		nota: in std_logic_vector(7 downto 0);
		valor : in std_logic_vector(7 downto 0);
		retorno: out std_logic_vector(7 downto 0);
		saiu_bebida: out std_logic
    		);
	end component;	

		signal clk     : std_logic;
		signal confirmar   : std_logic;
		signal colocando : std_logic;
		signal nota: std_logic_vector(7 downto 0);
		signal valor : std_logic_vector(7 downto 0);
		signal retorno: std_logic_vector(7 downto 0);
		signal saiu_bebida: std_logic;

begin
projeto4: maquina
	port map(
		clk => clk,
		confirmar => confirmar,
		colocando => colocando,
		nota => nota,
		valor => valor,
		retorno => retorno,
		saiu_bebida => saiu_bebida
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
		confirmar <= '0';
		colocando <= '0';
		wait for 2 ns;
		-- tempo para apertar botao da bebida(escolher a bebida)
		valor <= std_logic_vector(to_unsigned(9, valor'length));
		confirmar <= '0';
		colocando <= '1';
		wait for 2 ns;
		-- tempo para colocar dinheiro
		nota <= std_logic_vector(to_unsigned(20, nota'length));
		wait for 2 ns;
		-- tempo para confirmar a finalizacao da compra
		nota <= std_logic_vector(to_unsigned(0, nota'length));--PRECISA ZERAR A NOTA
		confirmar <= '1';
		colocando <= '0';
		wait for 2 ns;
		confirmar <= '0';
		colocando <= '0';
		-- FUNCIONA PARA COLOCANDO 1 NOTA
		wait for 2 ns;
		valor <= std_logic_vector(to_unsigned(14, valor'length));
		confirmar <= '0';
		colocando <= '1';
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(5, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(10, nota'length));
		wait for 2 ns;
		confirmar <= '1';
		colocando <= '0';
		nota <= std_logic_vector(to_unsigned(0, nota'length));
		wait for 2 ns;
		confirmar <= '0';
		colocando <= '0';
		-- FUNCIONA PARA COLOCANDO 2 NOTAS
		wait for 2 ns;
		valor <= std_logic_vector(to_unsigned(6, valor'length));
		confirmar <= '0';
		colocando <= '1';
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(20, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(10, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(5, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(0, nota'length));
		confirmar <= '1';
		colocando <= '0';
		wait for 2 ns;
		confirmar <= '0';
		colocando <= '0';
		-- COLOCANDO MENOS DINHEIRO QUE O PRECO DA BEBIDA
		wait for 2 ns;
		valor <= std_logic_vector(to_unsigned(14, valor'length));
		confirmar <= '0';
		colocando <= '1';
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(10, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(0, nota'length));
		confirmar <= '1';
		colocando <= '0';
		wait for 2 ns;
		confirmar <= '0';
		colocando <= '0';
		-- COMPRAR ATÉ NAO TER TROCO
		wait for 2 ns;
		valor <= std_logic_vector(to_unsigned(14, valor'length));
		confirmar <= '0';
		colocando <= '1';
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(10, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(5, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(0, nota'length));
		confirmar <= '1';
		colocando <= '0';
		wait for 2 ns;
		confirmar <= '0';
		colocando <= '0';
		wait for 2 ns;
		valor <= std_logic_vector(to_unsigned(14, valor'length));
		confirmar <= '0';
		colocando <= '1';
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(10, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(5, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(0, nota'length));
		confirmar <= '1';
		colocando <= '0';
		wait for 2 ns;
		confirmar <= '0';
		colocando <= '0';
		wait for 2 ns;
		valor <= std_logic_vector(to_unsigned(14, valor'length));
		confirmar <= '0';
		colocando <= '1';
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(10, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(5, nota'length));
		wait for 2 ns;
		nota <= std_logic_vector(to_unsigned(0, nota'length));
		confirmar <= '1';
		colocando <= '0';
		wait for 2 ns;
		confirmar <= '0';
		colocando <= '0';
		wait;		

	end process;


	

end architecture;
