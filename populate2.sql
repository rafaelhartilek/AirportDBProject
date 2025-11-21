-- =============================================================================
-- populate2.sql
-- Script de povoamento revisto para o esquema de aeroporto (create2.sql)
-- Garante dados em todas as tabelas do esquema, com valores realistas.
--
-- Produzido com apoio de ChatGPT (OpenAI),
-- modelo GPT-5.1 Thinking, novembro de 2025.
-- =============================================================================

PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

-- =============================================================================
-- PESSOA
-- =============================================================================
INSERT INTO Pessoa (numeroCC, nome, dataNascimento, infoContacto) VALUES 
  ('111111111', 'Joao Silva',    '1980-01-01', 'joao.silva@example.com'),
  ('222222222', 'Maria Costa',   '1988-03-22', 'maria.costa@example.com'),
  ('333333333', 'Ana Pereira',   '1995-07-10', 'ana.pereira@example.com'),
  ('444444444', 'Carlos Sousa',  '1975-11-05', 'carlos.sousa@example.com'),
  ('555555555', 'Laura Martins', '1992-09-18', 'laura.martins@example.com'),
  ('666666666', 'Pedro Gomes',   '1983-02-14', 'pedro.gomes@example.com'),
  ('777777777', 'Rita Almeida',  '1990-12-30', 'rita.almeida@example.com');

-- =============================================================================
-- PASSAGEIRO
-- (quatro pessoas são passageiros)
-- =============================================================================
INSERT INTO Passageiro (numeroCC, numeroPassaporte) VALUES
  ('111111111', 'PT1234567'),
  ('222222222', 'PT9876543'),
  ('333333333', 'BR4455667'),
  ('777777777', 'ES7654321');

-- =============================================================================
-- COMPANHIAAEREA
-- =============================================================================
INSERT INTO CompanhiaAerea (nome) VALUES
  ('TAP Air Portugal'),   -- idCompanhia = 1
  ('Lufthansa'),          -- idCompanhia = 2
  ('Ryanair'),            -- idCompanhia = 3
  ('easyJet');            -- idCompanhia = 4

-- =============================================================================
-- AVIAO
-- (pelo menos um aviao por algumas companhias)
-- =============================================================================
INSERT INTO Aviao (
    modelo, numMotores, status, capacidade, peso,
    depositoGasolina, consumoMedio, velocidadeMax, tempoUsoTotal, idCompanhia
) VALUES
  ('Airbus A320neo',    2, 'operacional', 174, 42000,  8000, 2200, 840, 9500, 1), -- TAP
  ('Boeing 737-800',    2, 'operacional', 189, 45000,  8200, 2300, 850, 8700, 3), -- Ryanair
  ('Airbus A321-200',   2, 'operacional', 214, 47000,  9000, 2400, 870, 7600, 2), -- Lufthansa
  ('Airbus A319',       2, 'manutencao',  144, 40000,  7800, 2100, 820, 5000, 4); -- easyJet

-- IDs esperados: Aviao 1..4

-- =============================================================================
-- VOO
-- Cada voo referencia uma companhia e um aviao
-- =============================================================================
INSERT INTO Voo (
    horaPartida, horaChegada, origem, destino, data,
    duracao, lugaresDisponiveis, idCompanhia, idAviao
) VALUES
  ('07:00', '07:55', 'OPO', 'LIS', '2025-12-01',  55, 170, 1, 1), -- TAP, A320neo
  ('09:30', '11:15', 'LIS', 'FNC', '2025-12-01', 105, 165, 1, 1), -- TAP, A320neo
  ('12:30', '16:15', 'LIS', 'FRA', '2025-12-02', 225, 200, 2, 3), -- Lufthansa, A321
  ('18:00', '21:00', 'OPO', 'STN', '2025-12-03', 180, 185, 3, 2); -- Ryanair, B737-800

-- IDs esperados: Voo 1..4

-- =============================================================================
-- FUNCIONARIO
-- 5 funcionarios: 3 tripulacao, 2 aeroporto
-- =============================================================================
INSERT INTO Funcionario (numeroCC, horario, salario) VALUES 
  ('444444444', '06:00-14:00', 3200.00), -- idFuncionario = 1 (piloto)
  ('555555555', '06:00-14:00', 2800.00), -- idFuncionario = 2 (copiloto)
  ('666666666', '06:00-14:00', 2300.00), -- idFuncionario = 3 (comissario)
  ('333333333', '09:00-17:00', 1800.00), -- idFuncionario = 4 (check-in)
  ('222222222', '14:00-22:00', 1900.00); -- idFuncionario = 5 (gate/embarque)

-- =============================================================================
-- TRIPULACAO
-- Funcionarios 1,2,3 são tripulantes
-- =============================================================================
INSERT INTO Tripulacao (idFuncionario, certificados) VALUES
  (1, 'ATPL; IFR; Airbus A320'),
  (2, 'Co-piloto; Airbus A320/B737'),
  (3, 'Comissario de bordo; Safety training');

-- =============================================================================
-- FUNCIONARIOAEROPORTO
-- Funcionarios 4 e 5 trabalham em terra
-- =============================================================================
INSERT INTO FuncionarioAeroporto (idFuncionario, departamento) VALUES
  (4, 'Check-in'),
  (5, 'Embarque e portoes');

-- =============================================================================
-- PILOTO
-- Funcionarios 1 e 2 são pilotos
-- =============================================================================
INSERT INTO Piloto (idFuncionario, nLicenca) VALUES
  (1, 'TAP-PT-0001'),
  (2, 'TAP-PT-0101');

-- =============================================================================
-- COMISSARIO
-- Funcionario 3 é comissario de bordo
-- =============================================================================
INSERT INTO Comissario (idFuncionario, funcao) VALUES
  (3, 'Chefe de cabine');

-- =============================================================================
-- PILOTODOAVIAO
-- Relacao N:M entre pilotos e avioes
-- =============================================================================
INSERT INTO PilotoDoAviao (idAviao, idFuncionario) VALUES
  (1, 1), -- piloto 1 habilitado no A320neo
  (1, 2), -- copiloto 2 habilitado no A320neo
  (2, 2), -- copiloto 2 habilitado no B737-800
  (3, 1); -- piloto 1 habilitado no A321-200

-- =============================================================================
-- TRIPULACAONOVOO
-- Relacao N:M entre tripulacao e voos
-- =============================================================================
INSERT INTO TripulacaoNoVoo (idVoo, idFuncionario) VALUES
  -- Voo 1: OPO-LIS
  (1, 1), (1, 2), (1, 3),
  -- Voo 2: LIS-FNC
  (2, 1), (2, 2), (2, 3),
  -- Voo 3: LIS-FRA
  (3, 1), (3, 2), (3, 3),
  -- Voo 4: OPO-STN
  (4, 1), (4, 2), (4, 3);

-- =============================================================================
-- BILHETE
-- Bilhetes para vários voos e passageiros
-- =============================================================================
INSERT INTO Bilhete (numeroLugar, classe, preco, idVoo, numeroCCPassageiro) VALUES
  ('12A', 'economica',  89.99, 1, '111111111'), -- Joao, OPO-LIS
  ('12B', 'economica',  89.99, 1, '222222222'), -- Maria, OPO-LIS
  ('3C',  'economica', 149.50, 2, '333333333'), -- Ana, LIS-FNC
  ('14D', 'economica', 139.90, 2, '777777777'), -- Rita, LIS-FNC
  ('2A',  'executiva', 399.90, 3, '111111111'), -- Joao, LIS-FRA
  ('21F', 'economica',  79.90, 4, '222222222'); -- Maria, OPO-STN

-- =============================================================================
-- CHECKIN
-- Supondo IDs de CheckIn sequenciais (1..6)
-- =============================================================================
INSERT INTO CheckIn (
    data, hora, local, estado, nMalas, pesoTotal, observacoes, numeroCCPassageiro
) VALUES
  ('2025-12-01', '05:45', 'balcao 10', 'concluido', 1, 18.2, 'Bagagem de mao adicional', '111111111'), -- voo 1
  ('2025-12-01', '05:50', 'balcao 10', 'concluido', 1, 20.0, 'Nenhuma',                  '222222222'), -- voo 1
  ('2025-12-01', '08:15', 'balcao 15', 'concluido', 2, 32.5, 'Uma mala fragil',          '333333333'), -- voo 2
  ('2025-12-01', '08:20', 'balcao 15', 'concluido', 1, 17.8, 'Assento janela',           '777777777'), -- voo 2
  ('2025-12-02', '10:45', 'balcao 12', 'concluido', 1, 19.0, 'Conexao para FRA',         '111111111'), -- voo 3
  ('2025-12-03', '16:30', 'balcao 8',  'concluido', 1, 21.3, 'Bagagem de mao volumosa',  '222222222'); -- voo 4

-- =============================================================================
-- CARTAOEMBARQUE
-- Cada check-in gera no maximo um cartao
-- =============================================================================
INSERT INTO CartaoEmbarque (portaEmbarque, horaEmbarque, idCheckIn, idVoo) VALUES
  ('A12', '06:20', 1, 1), -- Joao, voo 1
  ('A12', '06:25', 2, 1), -- Maria, voo 1
  ('B07', '08:45', 3, 2), -- Ana,  voo 2
  ('B07', '08:50', 4, 2), -- Rita, voo 2
  ('C03', '11:15', 5, 3), -- Joao, voo 3
  ('D09', '17:15', 6, 4); -- Maria, voo 4

-- =============================================================================
-- BAGAGEM
-- Pelo menos uma bagagem por check-in (onde faz sentido)
-- =============================================================================
INSERT INTO Bagagem (peso, status, destinoFinal, idCheckIn) VALUES
  (18.2, 'despachada',  'LIS', 1),
  (20.0, 'despachada',  'LIS', 2),
  (18.0, 'despachada',  'FNC', 3),
  (14.5, 'despachada',  'FNC', 4),
  (19.0, 'em transito', 'FRA', 5),
  (21.3, 'despachada',  'STN', 6);

COMMIT;

-- =============================================================================
-- FIM DO SCRIPT (populate2.sql - versão revista com IA, com todas as tabelas populadas)
-- =============================================================================
