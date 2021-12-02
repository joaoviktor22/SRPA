library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity maquina is
	port(
		clk     : in std_logic; -- clock
		confirmar   : in std_logic; -- botao de finalização da compra
		colocando : in std_logic; -- botao de escolhida a bebida
		nota: in std_logic_vector(7 downto 0);-- nota do dinheiro colocado(1,2,5,10 ou 20)
		valor : in std_logic_vector(7 downto 0); -- valor da bebida escolhida(6,9,11,13 ou 14)
		retorno: out std_logic_vector(7 downto 0); -- troco ou retorno do dinheiro se não foi possível comprar
		saiu_bebida: out std_logic -- se saiu bebida ou não, se aceitou ou não a compra
    );
end maquina;

architecture basic of maquina is

	type my_state is (Parado, Comprando, Conta);
	signal estadoAtual   : my_state;
	signal proximoEstado : my_state;
	
	signal  troco : unsigned(7 downto 0); -- troco ou retorno do dinheiro
	signal  controle : std_logic_vector(1 downto 0); --controle dos botões
	signal  dinheiro: unsigned(7 downto 0); --dinheiro colocado(nota do dinheiro)
	signal  preco: unsigned(7 downto 0); --preco da bebida escolhida
	signal  bebida: std_logic;-- se recebeu a bebida ou não,se aceitou ou não a compra

begin
	controle <= colocando & confirmar;
	dinheiro <= unsigned(nota);
	preco <= unsigned(valor);
	saiu_bebida <= bebida;
	retorno <= std_logic_vector(troco);

	process(clk)
	variable teve : std_logic; -- variavel para confirmar se 'teve' troco
	variable banco_atual : unsigned(7 downto 0) := "00000000"; --variavel para ver quanto o usuário colocou de dinheiro
	variable banco : unsigned(7 downto 0) := "00000000"; --lucro total da máquina,dinheiro total inserido por pessoas
	variable money : unsigned(7 downto 0) := "00000000"; --variavel para retorno de dinheiro se houver troco
	variable diferenca : unsigned(7 downto 0):= "00000000"; -- diferenca do dinheiro colocado do preco da bebida(troco)
	variable um : unsigned(5 downto 0):= "000100";--quantas notas de um dentro da máquina(começa com 4)
	variable dois : unsigned(5 downto 0):= "000100";--quantas notas de dois dentro da máquina(começa com 4)
	variable cinco : unsigned(5 downto 0):= "000100";--quantas notas de cinco dentro da máquina(começa com 4)
	variable dez : unsigned(5 downto 0):= "000100";--quantas notas de dez dentro da máquina(começa com 4)
	variable vinte : unsigned(5 downto 0):= "000100";--quantas notas de vinte dentro da máquina(começa com 4)
	begin
		if rising_edge(clk) then
			estadoAtual <= proximoEstado;
			case estadoAtual is
				when Parado => -- fazer nada,máquina parada
						troco <= to_unsigned(0,troco'length);
						banco_atual := to_unsigned(0,banco_atual'length);
						bebida <= '0';
				when Comprando => --usuario colocando dinheiro na máquina
						troco <= to_unsigned(0,troco'length);
						bebida <= '0';
						case dinheiro is
							when "00000001" =>
								um := incrementa(um);
								banco := banco + dinheiro;
								banco_atual := banco_atual + dinheiro;
							when "00000010" =>
								dois := incrementa(dois);
								banco := banco + dinheiro;
								banco_atual := banco_atual + dinheiro;
							when "00000101" =>
								cinco := incrementa(cinco);
								banco := banco + dinheiro;
								banco_atual := banco_atual + dinheiro;
							when "00001010" =>
								dez := incrementa(dez);
								banco := banco + dinheiro;
								banco_atual := banco_atual + dinheiro;
							when "00010100" =>
								vinte := incrementa(vinte);
								banco := banco + dinheiro;
								banco_atual := banco_atual + dinheiro;
							when others =>
								bebida<= '0';
							end case;
				when Conta => --máquina calculando troco e se é possível a compra da bebida
						if(banco_atual >= preco) then --colocou mais/igual dinheiro da bebida escolhida
							diferenca := banco_atual - preco;
							if(diferenca = 0) then --colocou quantia exata do preço da bebida
								troco <= to_unsigned(0,troco'length);
								bebida <= '1';
								banco_atual := to_unsigned(0,banco_atual'length);
							else	--colocou mais dinheiro que necessário,precisa de troco
								money := diferenca;
								while(diferenca > 0) loop
									teve := '0';
									if (diferenca >= 20) then
										while(diferenca >= 20) loop
											if(vinte > 0) then
												diferenca := diferenca - 20;
												vinte := vinte - 1;
												teve := '1';
											else
												exit;
											end if;
										end loop;
									end if;
									if (diferenca >= 10) then
										while(diferenca >= 10) loop
											if(dez > 0) then
												diferenca := diferenca - 10;
												dez := dez - 1;
												teve := '1';
											else
												exit;
											end if;
										end loop;
									end if;
									if (diferenca >= 5) then
										while(diferenca >= 5) loop
											if(cinco > 0) then
												diferenca := diferenca - 5;
												cinco := cinco - 1;
												teve := '1';
											else
												exit;
											end if;
										end loop;
									end if;
									if (diferenca >= 2) then
										while(diferenca >= 2) loop
											if(dois > 0) then
												diferenca := diferenca - 2;
												dois := dois - 1;
												teve := '1';
											else
												exit;
											end if;
										end loop;
									end if;
									if (diferenca >= 1) then
										while(diferenca >= 1) loop
											if(um > 0) then
												diferenca := diferenca - 1;
												um := um - 1;
												teve := '1';
											else
												exit;
											end if;
										end loop;
									end if;
									if(teve = '0') then
										exit;
									end if;
								end loop;
							end if;
							if(diferenca = 0) then --é possível realizar a compra com troco
								troco <= money;
								bebida <= '1';
								banco := banco - money;
								banco_atual := to_unsigned(0,banco_atual'length);
							else -- não é possivel realizar a compra,retorno total do dinheiro
								troco <= banco_atual;
								bebida <= '0';
								banco := banco - banco_atual;
								banco_atual := to_unsigned(0,banco_atual'length);						
							end if;
						else --colocou menos dinheiro que o preço da bebida
							troco <= banco_atual;
							bebida <= '0';
							banco := banco - banco_atual;
							banco_atual := to_unsigned(0,banco_atual'length);		
						end if;
			end case;
		end if;
	end process;

	process(controle)
	begin
		case controle is
			when "00" => -- comprando=0 e confirmar=0, máquina parada
					proximoEstado <= Parado;
			when "10" => -- comprando=1 e confirmar=0 , botão de bebida escolhida
					proximoEstado <= Comprando;
			when "01" => -- comprando=0 e confirmar=1, botão de compra finalizada
					proximoEstado <= Conta;
			when "11" => -- comprando=1 e confirmar=1, não é para acontecer, mas se acontecer,finalizar a compra  
					proximoEstado <= Conta;
			when others => proximoEstado <= estadoAtual;-- nao entendi o erro,fala que tem 81 opcoes de 'controle' mas são 2 bits,não entendi
		end case;
	end process;
end basic;
