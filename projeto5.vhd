library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my_package.all;

entity jogodavelha is
	port(
		clk     : in std_logic; --clock
		reset   : in std_logic; --botao de reset,tem prioridade 
		start : in std_logic; -- botao para começar
		primeiro : in std_logic; -- primeiro = 0 o jogador começa,primeiro = 1 => maquina começa
		posicao: in std_logic_vector(3 downto 0); --posicao no jogo da velha(1 a 9)
		joga : in std_logic; --botao para jogador jogar
		maquina: out std_logic_vector(3 downto 0);--saida mostrando oq a maquina jogou
		fim: out std_logic;--saida que mostra que jogo acabou
		win: out std_logic_vector(1 downto 0)-- 01 => jogador ganhou, 10 => maquina ganhou, 11 >= empate
    );
end jogodavelha;

architecture basic of jogodavelha is

	type my_state is (Parado, Jogando, Final);
	signal estadoAtual   : my_state;
	signal proximoEstado : my_state;
	
	signal  controle : std_logic_vector(2 downto 0); --controle dos botões
	signal comeco: std_logic;
	signal position: std_logic_vector(3 downto 0);
	signal jogar: std_logic;
	signal f: std_logic;-- variavel se a partida acabou pois esse VHDL nao aceita saida(fim) no controle

begin
	controle <= reset & start & f;
	comeco <= primeiro;
	position <= posicao;
	jogar <= joga;
	process(clk)
	variable jogador : std_logic := comeco;--variavel para ver quem vai jogar: maquina ou jogador
	variable jamarcado : std_logic; --variavel que ve se a posical colocadad já foi jogada ou não
	variable velha_jog : std_logic_vector(8 downto 0);--jogo da velha do jogador
	variable velha_maq : std_logic_vector(8 downto 0);--jogo da velha da maquina
	begin
		if rising_edge(clk) then
			estadoAtual <= proximoEstado;
			case estadoAtual is
				when Parado =>--reseta tudo
						jogador := comeco;
						velha_jog := std_logic_vector(to_unsigned(0, velha_jog'length));
						velha_maq := std_logic_vector(to_unsigned(0, velha_maq'length));
						f <= '0';
						fim <=  f;
						win <= std_logic_vector(to_unsigned(0, win'length));
				when Jogando => --meio do jogo
						if(jogador = '0') then --jogador jogando
							if(jogar = '1') then -- esta disponivel ele jogar
								jamarcado := '0';
								case position is --verifica se a posição esta dispponivel jogar e joga
									when "0001" => 
										if(velha_jog(0) = '0' and velha_maq(0) = '0') then
											velha_jog(0) := '1';
										else
											jamarcado := '1';
										end if;
									when "0010" => 
										if(velha_jog(1) = '0' and velha_maq(1) = '0') then
											velha_jog(1) := '1';
										else
											jamarcado := '1';
										end if;
									when "0011" => 
										if(velha_jog(2) = '0' and velha_maq(2) = '0') then
											velha_jog(2) := '1';
										else
											jamarcado := '1';
										end if;
									when "0100" => 
										if(velha_jog(3) = '0' and velha_maq(3) = '0') then
											velha_jog(3) := '1';
										else
											jamarcado := '1';
										end if;
									when "0101" => 
										if(velha_jog(4) = '0' and velha_maq(4) = '0') then
											velha_jog(4) := '1';
										else
											jamarcado := '1';
										end if;
									when "0110" => 
										if(velha_jog(5) = '0' and velha_maq(5) = '0') then
											velha_jog(5) := '1';
										else
											jamarcado := '1';
										end if;
									when "0111" => 
										if(velha_jog(6) = '0' and velha_maq(6) = '0') then
											velha_jog(6) := '1';
										else
											jamarcado := '1';
										end if;
									when "1000" => 
										if(velha_jog(7) = '0' and velha_maq(7) = '0') then
											velha_jog(7) := '1';
										else
											jamarcado := '1';
										end if;
									when "1001" => 
										if(velha_jog(8) = '0' and velha_maq(8) = '0') then
											velha_jog(8) := '1';
										else
											jamarcado := '1';
										end if;
									when others =>
											jamarcado := '1';
								end case;
								if(jamarcado = '1') then --se ja tiver marcado,faz nada
									maquina <= std_logic_vector(to_unsigned(0, maquina'length));
									f <= '0';
									fim <=  f;
									win <= std_logic_vector(to_unsigned(0, win'length));
								else --se nao tiver marcado,joga e confere se jogo acabou
									jogador := '1';
									maquina <= std_logic_vector(to_unsigned(0, maquina'length));
									win <= std_logic_vector(to_unsigned(0, win'length));
									f <= (conferindo(velha_jog) or conferindo(velha_maq));
									fim <=  f;
									if((velha_jog OR velha_maq) = "111111111") then
										f <=  '1';
										fim <=  f;
									end if;
								end if;
							else --nao esta disponivel jogar, jogar = 0
								maquina <= std_logic_vector(to_unsigned(0, maquina'length));
								f <= '0';
								fim <=  f;
								win <= std_logic_vector(to_unsigned(0, win'length));
							end if;
						else--maquina jogando--IA da maquina--começa sempre tentando ganhar se der, depois tenta não perder se der e depois algumas jogadas pre definidas que são de inicio de jogo ou fim de partida(empate)
							if(velha_maq(0) = '1' and velha_maq(1) = '1' and velha_jog(2) = '0' and velha_maq(2) = '0') then--linha1--ganhando
								velha_maq(2) := '1';
								maquina <= std_logic_vector(to_unsigned(3, maquina'length));
							elsif(velha_maq(0) = '1' and velha_maq(2) = '1' and velha_jog(1) = '0' and velha_maq(1) = '0') then
								velha_maq(1) := '1';
								maquina <= std_logic_vector(to_unsigned(2, maquina'length));
							elsif(velha_maq(1) = '1' and velha_maq(2) = '1' and velha_jog(0) = '0' and velha_maq(0) = '0') then
								velha_maq(0) := '1';
								maquina <= std_logic_vector(to_unsigned(1, maquina'length));
							elsif(velha_maq(3) = '1' and velha_maq(4) = '1' and velha_jog(5) = '0' and velha_maq(5) = '0') then--linha2
								velha_maq(5) := '1';
								maquina <= std_logic_vector(to_unsigned(6, maquina'length));
							elsif(velha_maq(3) = '1' and velha_maq(5) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_maq(4) = '1' and velha_maq(5) = '1' and velha_jog(3) = '0' and velha_maq(3) = '0') then
								velha_maq(3) := '1';
								maquina <= std_logic_vector(to_unsigned(4, maquina'length));
							elsif(velha_maq(6) = '1' and velha_maq(7) = '1' and velha_jog(8) = '0' and velha_maq(8) = '0') then--linha3
								velha_maq(8) := '1';
								maquina <= std_logic_vector(to_unsigned(9, maquina'length));
							elsif(velha_maq(6) = '1' and velha_maq(8) = '1' and velha_jog(7) = '0' and velha_maq(7) = '0') then
								velha_maq(7) := '1';
								maquina <= std_logic_vector(to_unsigned(8, maquina'length));
							elsif(velha_maq(7) = '1' and velha_maq(8) = '1' and velha_jog(6) = '0' and velha_maq(6) = '0') then
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_maq(0) = '1' and velha_maq(3) = '1' and velha_jog(6) = '0' and velha_maq(6) = '0') then--coluna1
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_maq(0) = '1' and velha_maq(6) = '1' and velha_jog(3) = '0' and velha_maq(3) = '0') then
								velha_maq(3) := '1';
								maquina <= std_logic_vector(to_unsigned(4, maquina'length));
							elsif(velha_maq(3) = '1' and velha_maq(6) = '1' and velha_jog(0) = '0' and velha_maq(0) = '0') then
								velha_maq(0) := '1';
								maquina <= std_logic_vector(to_unsigned(1, maquina'length));
							elsif(velha_maq(1) = '1' and velha_maq(4) = '1' and velha_jog(7) = '0' and velha_maq(7) = '0') then--coluna2
								velha_maq(7) := '1';
								maquina <= std_logic_vector(to_unsigned(8, maquina'length));
							elsif(velha_maq(1) = '1'and velha_maq(7) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_maq(4) = '1' and velha_maq(7) = '1' and velha_jog(1) = '0' and velha_maq(1) = '0') then
								velha_maq(1) := '1';
								maquina <= std_logic_vector(to_unsigned(2, maquina'length));
							elsif(velha_maq(2) = '1' and velha_maq(5) = '1' and velha_jog(8) = '0' and velha_maq(8) = '0') then--coluna3
								velha_maq(8) := '1';
								maquina <= std_logic_vector(to_unsigned(9, maquina'length));
							elsif(velha_maq(2) = '1' and velha_maq(8) = '1' and velha_jog(5) = '0' and velha_maq(5) = '0') then
								velha_maq(5) := '1';
								maquina <= std_logic_vector(to_unsigned(6, maquina'length));
							elsif(velha_maq(5) = '1' and velha_maq(8) = '1' and velha_jog(2) = '0' and velha_maq(2) = '0') then
								velha_maq(2) := '1';
								maquina <= std_logic_vector(to_unsigned(3, maquina'length));
							elsif(velha_maq(0) = '1' and velha_maq(4) = '1' and velha_jog(8) = '0' and velha_maq(8) = '0') then--diagonal1
								velha_maq(8) := '1';
								maquina <= std_logic_vector(to_unsigned(9, maquina'length));
							elsif(velha_maq(0) = '1' and velha_maq(8) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_maq(4) = '1' and velha_maq(8) = '1' and velha_jog(0) = '0' and velha_maq(0) = '0') then
								velha_maq(0) := '1';
								maquina <= std_logic_vector(to_unsigned(1, maquina'length));
							elsif(velha_maq(2) = '1' and velha_maq(4) = '1' and velha_jog(6) = '0' and velha_maq(6) = '0') then--diagonal2
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_maq(2) = '1' and velha_maq(6) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_maq(4) = '1' and velha_maq(6) = '1' and velha_jog(2) = '0' and velha_maq(2) = '0') then
								velha_maq(2) := '1';
								maquina <= std_logic_vector(to_unsigned(3, maquina'length));
							elsif(velha_jog(0) = '1' and velha_jog(1) = '1' and velha_jog(2) = '0' and velha_maq(2) = '0') then--linha1--naoperdendo
								velha_maq(2) := '1';
								maquina <= std_logic_vector(to_unsigned(3, maquina'length));
							elsif(velha_jog(0) = '1' and velha_jog(2) = '1' and velha_jog(1) = '0' and velha_maq(1) = '0') then
								velha_maq(1) := '1';
								maquina <= std_logic_vector(to_unsigned(2, maquina'length));
							elsif(velha_jog(1) = '1' and velha_jog(2) = '1' and velha_jog(0) = '0' and velha_maq(0) = '0') then
								velha_maq(0) := '1';
								maquina <= std_logic_vector(to_unsigned(1, maquina'length));
							elsif(velha_jog(3) = '1' and velha_jog(4) = '1' and velha_jog(5) = '0' and velha_maq(5) = '0') then--linha2
								velha_maq(5) := '1';
								maquina <= std_logic_vector(to_unsigned(6, maquina'length));
							elsif(velha_jog(3) = '1' and velha_jog(5) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_jog(4) = '1' and velha_jog(5) = '1' and velha_jog(3) = '0' and velha_maq(3) = '0') then
								velha_maq(3) := '1';
								maquina <= std_logic_vector(to_unsigned(4, maquina'length));
							elsif(velha_jog(6) = '1' and velha_jog(7) = '1' and velha_jog(8) = '0' and velha_maq(8) = '0') then--linha3
								velha_maq(8) := '1';
								maquina <= std_logic_vector(to_unsigned(9, maquina'length));
							elsif(velha_jog(6) = '1' and velha_jog(8) = '1' and velha_jog(7) = '0' and velha_maq(7) = '0') then
								velha_maq(7) := '1';
								maquina <= std_logic_vector(to_unsigned(8, maquina'length));
							elsif(velha_jog(7) = '1' and velha_jog(8) = '1' and velha_jog(6) = '0' and velha_maq(6) = '0') then
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_jog(0) = '1' and velha_jog(3) = '1' and velha_jog(6) = '0' and velha_maq(6) = '0') then--coluna1
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_jog(0) = '1' and velha_jog(6) = '1' and velha_jog(3) = '0' and velha_maq(3) = '0') then
								velha_maq(3) := '1';
								maquina <= std_logic_vector(to_unsigned(4, maquina'length));
							elsif(velha_jog(3) = '1' and velha_jog(6) = '1' and velha_jog(0) = '0' and velha_maq(0) = '0') then
								velha_maq(0) := '1';
								maquina <= std_logic_vector(to_unsigned(1, maquina'length));
							elsif(velha_jog(1) = '1' and velha_jog(4) = '1' and velha_jog(7) = '0' and velha_maq(7) = '0') then--coluna2
								velha_maq(7) := '1';
								maquina <= std_logic_vector(to_unsigned(8, maquina'length));
							elsif(velha_jog(1) = '1' and velha_jog(7) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_jog(4) = '1' and velha_jog(7) = '1' and velha_jog(1) = '0' and velha_maq(1) = '0') then
								velha_maq(1) := '1';
								maquina <= std_logic_vector(to_unsigned(2, maquina'length));
							elsif(velha_jog(2) = '1' and velha_jog(5) = '1' and velha_jog(8) = '0' and velha_maq(8) = '0') then--coluna3
								velha_maq(8) := '1';
								maquina <= std_logic_vector(to_unsigned(9, maquina'length));
							elsif(velha_jog(2) = '1' and velha_jog(8) = '1' and velha_jog(5) = '0' and velha_maq(5) = '0') then
								velha_maq(5) := '1';
								maquina <= std_logic_vector(to_unsigned(6, maquina'length));
							elsif(velha_jog(5) = '1' and velha_jog(8) = '1' and velha_jog(2) = '0' and velha_maq(2) = '0') then
								velha_maq(2) := '1';
								maquina <= std_logic_vector(to_unsigned(3, maquina'length));
							elsif(velha_jog(0) = '1' and velha_jog(4) = '1' and velha_jog(8) = '0' and velha_maq(8) = '0') then--diagonal1
								velha_maq(8) := '1';
								maquina <= std_logic_vector(to_unsigned(9, maquina'length));
							elsif(velha_jog(0) = '1' and velha_jog(8) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_jog(4) = '1' and velha_jog(8) = '1' and velha_jog(0) = '0' and velha_maq(0) = '0') then
								velha_maq(0) := '1';
								maquina <= std_logic_vector(to_unsigned(1, maquina'length));
							elsif(velha_jog(2) = '1' and velha_jog(4) = '1' and velha_jog(6) = '0' and velha_maq(6) = '0') then--diagonal2
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_jog(2) = '1' and velha_jog(6) = '1' and velha_jog(4) = '0' and velha_maq(4) = '0') then
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_jog(4) = '1' and velha_jog(6) = '1' and velha_jog(2) = '0' and velha_maq(2) = '0') then
								velha_maq(2) := '1';
								maquina <= std_logic_vector(to_unsigned(3, maquina'length));
							elsif(velha_jog = std_logic_vector(to_unsigned(0, velha_jog'length)) and velha_jog(6) = '0' and velha_maq(6) = '0') then--iniciodojogo--qualquer canto
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_maq = std_logic_vector(to_unsigned(0, velha_maq'length)) and velha_jog(4) = '0' and velha_maq(4) = '0') then--se nao for o inicio,sempre meio se possivel
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_jog(2) = '0' and velha_maq(2) = '0') then--nao eh primeira jogada ou comecaram com meio
								velha_maq(2) := '1';
								maquina <= std_logic_vector(to_unsigned(3, maquina'length));
							elsif(velha_jog(4) = '0' and velha_maq(4) = '0') then--ir meio se der
								velha_maq(4) := '1';
								maquina <= std_logic_vector(to_unsigned(5, maquina'length));
							elsif(velha_jog(6) = '0' and velha_maq(6) = '0') then--pontas primeiro
								velha_maq(6) := '1';
								maquina <= std_logic_vector(to_unsigned(7, maquina'length));
							elsif(velha_jog(8) = '0' and velha_maq(8) = '0') then
								velha_maq(8) := '1';
								maquina <= std_logic_vector(to_unsigned(9, maquina'length));
							elsif(velha_jog(0) = '0' and velha_maq(0) = '0') then
								velha_maq(0) := '1';
								maquina <= std_logic_vector(to_unsigned(1, maquina'length));
							elsif(velha_jog(1) = '0' and velha_maq(1) = '0') then--lados
								velha_maq(1) := '1';
								maquina <= std_logic_vector(to_unsigned(2, maquina'length));
							elsif(velha_jog(3) = '0' and velha_maq(3) = '0') then
								velha_maq(3) := '1';
								maquina <= std_logic_vector(to_unsigned(4, maquina'length));
							elsif(velha_jog(5) = '0' and velha_maq(5) = '0') then
								velha_maq(5) := '1';
								maquina <= std_logic_vector(to_unsigned(6, maquina'length));
							elsif(velha_jog(7) = '0' and velha_maq(7) = '0') then
								velha_maq(7) := '1';
								maquina <= std_logic_vector(to_unsigned(8, maquina'length));
							else
								maquina <= std_logic_vector(to_unsigned(0, maquina'length));
							end if;
							jogador := '0';
							win <= std_logic_vector(to_unsigned(0, win'length));
							f <= conferindo(velha_jog) or conferindo(velha_maq);--confere se alguem ganhou
							fim <=  f;
							if(std_logic_vector(unsigned(velha_jog) + unsigned(velha_maq)) = "111111111") then
								f <= '1';
								fim <= f;
							end if;
						end if;
				when Final => --acabou a partida
						if(conferindo(velha_jog) = '1') then--jogador ganhou
							maquina <= std_logic_vector(to_unsigned(0, maquina'length));
							win <= std_logic_vector(to_unsigned(1, win'length));
							fim <= '1';
						elsif(conferindo(velha_maq) = '1') then--maquina ganhou
							maquina <= std_logic_vector(to_unsigned(0, maquina'length));
							win <= std_logic_vector(to_unsigned(2, win'length));
							fim <= '1';
						else --empate
							maquina <= std_logic_vector(to_unsigned(0, maquina'length));
							win <= std_logic_vector(to_unsigned(3, win'length));
							fim <= '1';
						end if;	
			end case;
		end if;
	end process;

	process(controle)
	begin
		case controle is
			when "000" => --reset & start & f => f é se a partida acabou
					proximoEstado <= estadoAtual;
			when "100" => 
					proximoEstado <= Parado;
			when "101" => 
					proximoEstado <= Parado;
			when "110" => 
					proximoEstado <= Parado;
			when "111" => 
					proximoEstado <= Parado;
			when "010" => 
					proximoEstado <= Jogando;
			when "001" => 
					proximoEstado <= Final;
			when "011" => 
					proximoEstado <= Final;
			when others => proximoEstado <= estadoAtual;
		end case;
	end process;
end basic;