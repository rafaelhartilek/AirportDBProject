-- populate1.sql
-- Script de povoamento simples para o esquema de aeroporto (create2.sql)
-- Respeita todas as dependências de chaves estrangeiras e constraints

PRAGMA foreign_keys = ON;

-- Populando Pessoa
INSERT INTO Pessoa (numeroCC, nome, dataNascimento, infoContacto) VALUES 
  ('123456789', 'João Silva', '1980-01-01', 'joao@email.com'),
  ('987654321', 'Maria Costa', '1990-05-15', 'maria@email.com');

-- Populando Passageiro
INSERT INTO Passageiro (numeroCC, numeroPassaporte) VALUES
  ('123456789', 'P001234'),
  ('987654321', 'P009876');

-- Populando CompanhiaAerea
INSERT INTO CompanhiaAerea (nome) VALUES
  ('SkyBlue'),
  ('FlyFast');

-- Populando Aviao
INSERT INTO Aviao (modelo, numMotores, status, capacidade, peso, depositoGasolina, consumoMedio, velocidadeMax, tempoUsoTotal, idCompanhia) VALUES
  ('Boeing 737', 2, 'operacional', 180, 40000, 8000, 2000, 850, 120, 1),
  ('Airbus A320', 2, 'manutencao', 150, 38000, 7500, 1900, 830, 90, 2);

-- Populando Voo
INSERT INTO Voo (horaPartida, horaChegada, origem, destino, data, duracao, lugaresDisponiveis, idCompanhia, idAviao) VALUES
  ('08:00', '11:00', 'OPO', 'LIS', '2025-12-01', 180, 175, 1, 1),
  ('13:20', '15:50', 'LIS', 'MAD', '2025-12-02', 150, 145, 2, 2);

-- Populando Funcionario
INSERT INTO Funcionario (numeroCC, horario, salario) VALUES 
  ('123456789', '08:00-17:00', 2000.00);

-- Populando Tripulacao
INSERT INTO Tripulacao (idFuncionario, certificados) VALUES
  (1, 'piloto');

-- Populando Piloto
INSERT INTO Piloto (idFuncionario, nLicenca) VALUES
  (1, 'LIC001');

-- Populando PilotoDoAviao
INSERT INTO PilotoDoAviao (idAviao, idFuncionario) VALUES
  (1, 1);

-- Populando Bilhete
INSERT INTO Bilhete (numeroLugar, classe, preco, idVoo, numeroCCPassageiro) VALUES
  ('2A', 'economica', 99.99, 1, '123456789'),
  ('5F', 'economica', 120.00, 2, '987654321');

-- Populando CheckIn
INSERT INTO CheckIn (data, hora, local, estado, nMalas, pesoTotal, observacoes, numeroCCPassageiro) VALUES
  ('2025-12-01', '07:30', 'balcao 5', 'concluido', 1, 20.5, 'Nenhuma', '123456789');

-- Populando CartaoEmbarque
INSERT INTO CartaoEmbarque (portaEmbarque, horaEmbarque, idCheckIn, idVoo) VALUES
  ('12', '07:50', 1, 1);

-- Populando Bagagem
INSERT INTO Bagagem (peso, status, destinoFinal, idCheckIn) VALUES
  (20.5, 'despachada', 'LIS', 1);

-- Os demais relacionamentos (TripulacaoNoVoo, FuncionarioAeroporto, Comissario) podem ser populados similares,
-- sempre associando chaves válidas inseridas acima.
