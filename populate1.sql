-- populate1.sql
-- Script de povoamento simples para o esquema de aeroporto (create2.sql)
-- Respeita todas as dependências de chaves estrangeiras e constraints

PRAGMA foreign_keys = ON;

-----------------------------------------------------------------------
-- PESSOAS E ESPECIALIZAÇÕES
-----------------------------------------------------------------------

-- Inserir Pessoas (base para todas as especializações)
INSERT INTO Pessoa (idPessoa, nome, nif, dataNascimento, contacto) VALUES
(1, 'João Silva', '123456789', '1985-03-15', '912345678'),
(2, 'Maria Santos', '234567890', '1990-07-22', '923456789'),
(3, 'Pedro Costa', '345678901', '1982-11-10', '934567890'),
(4, 'Ana Oliveira', '456789012', '1988-05-18', '945678901'),
(5, 'Carlos Ferreira', '567890123', '1995-09-30', '956789012'),
(6, 'Sofia Rodrigues', '678901234', '1992-02-14', '967890123'),
(7, 'Miguel Alves', '789012345', '1987-12-25', '978901234'),
(8, 'Rita Pereira', '890123456', '1993-06-08', '989012345'),
(9, 'Tiago Martins', '901234567', '1991-04-03', '990123456'),
(10, 'Inês Sousa', '012345678', '1989-08-17', '901234567');

-- Passageiros (pessoas 1-4)
INSERT INTO Passageiro (idPessoa, numPassaporte) VALUES
(1, 'PT123456'),
(2, 'PT234567'),
(3, 'PT345678'),
(4, 'PT456789');

-- Funcionários (pessoas 5-10)
INSERT INTO Funcionario (idPessoa, salario, horario) VALUES
(5, 2500.00, '09:00-17:00'),
(6, 3500.00, '08:00-16:00'),
(7, 3000.00, '10:00-18:00'),
(8, 2800.00, '14:00-22:00'),
(9, 2200.00, '06:00-14:00'),
(10, 2600.00, '22:00-06:00');

-- Tripulação (funcionários 5-7)
INSERT INTO Tripulacao (idPessoa, certificacoes, idiomasFalados, disponibilidade) VALUES
(5, 'ATPL, Type Rating A320', 'Português, Inglês, Espanhol', 'Disponível'),
(6, 'ATPL, Type Rating B737', 'Português, Inglês, Francês', 'Disponível'),
(7, 'Cabin Crew Safety', 'Português, Inglês', 'Disponível');

-- Pilotos (tripulação 5-6)
INSERT INTO Piloto (idPessoa, numLicenca, validadeLicenca, nivelCertificacao) VALUES
(5, 'PIL-2019-0001', '2026-12-31', 'Capitão'),
(6, 'PIL-2020-0042', '2027-06-30', 'Primeiro Oficial');

-- Comissário (tripulação 7)
INSERT INTO Comissario (idPessoa, funcaoBordo) VALUES
(7, 'Chefe de Cabine');

-- Funcionários de Aeroporto (funcionários 8-10)
INSERT INTO FuncionarioAeroporto (idPessoa, turno) VALUES
(8, 'Manhã'),
(9, 'Tarde'),
(10, 'Noite');

-- Segurança (funcionário aeroporto 8)
INSERT INTO Seguranca (idPessoa, idSecao, resultadoVerificacaoPadrao) VALUES
(8, 101, 'Aprovado');

-----------------------------------------------------------------------
-- COMPANHIAS AÉREAS E AVIÕES
-----------------------------------------------------------------------

INSERT INTO CompanhiaAerea (idCompanhia, nome) VALUES
(1, 'TAP Air Portugal'),
(2, 'Ryanair'),
(3, 'EasyJet');

INSERT INTO Aviao (idAviao, idCompanhia, modelo, capacidade, velocidadeMaxima, numMotores, peso, combustivelDepositado, horasVoo) VALUES
(1, 1, 'Airbus A320', 180, 840.0, 2, 73500.0, 24210.0, 15000.0),
(2, 1, 'Airbus A330', 277, 871.0, 2, 120000.0, 139090.0, 22000.0),
(3, 2, 'Boeing 737-800', 189, 842.0, 2, 79010.0, 26020.0, 18500.0),
(4, 3, 'Airbus A319', 156, 830.0, 2, 64000.0, 23860.0, 12000.0);

-----------------------------------------------------------------------
-- VOOS
-----------------------------------------------------------------------

INSERT INTO Voo (idVoo, idAviao, origem, destino, horaPartida, horaChegada, duracao) VALUES
(1, 1, 'Lisboa', 'Porto', '2025-11-20 08:00', '2025-11-20 09:00', 60),
(2, 2, 'Porto', 'Paris', '2025-11-20 10:30', '2025-11-20 13:45', 195),
(3, 3, 'Lisboa', 'Londres', '2025-11-20 14:00', '2025-11-20 16:40', 160),
(4, 4, 'Porto', 'Madrid', '2025-11-21 07:15', '2025-11-21 09:30', 135),
(5, 1, 'Lisboa', 'Faro', '2025-11-21 11:00', '2025-11-21 12:00', 60);

-----------------------------------------------------------------------
-- BILHETES
-----------------------------------------------------------------------

INSERT INTO Bilhete (idBilhete, idPessoa, idVoo, numLugar, classeVoo, preco) VALUES
(1, 1, 1, '12A', 'Económica', 89.99),
(2, 2, 2, '15C', 'Executiva', 450.00),
(3, 3, 3, '8B', 'Económica', 120.50),
(4, 4, 4, '22F', 'Económica', 95.00),
(5, 1, 5, '5A', 'Económica', 75.00);

-----------------------------------------------------------------------
-- CHECK-IN E CARTÕES DE EMBARQUE
-----------------------------------------------------------------------

INSERT INTO CheckIn (idCheckIn, idBilhete, data, hora, local, estado, numMalas, observacoes) VALUES
(1, 1, '2025-11-20', '06:30', 'Balcão 12', 'valido', 1, 'Check-in completo'),
(2, 2, '2025-11-20', '08:45', 'Balcão 8', 'valido', 2, 'Passageiro VIP'),
(3, 3, '2025-11-20', '12:15', 'Online', 'valido', 1, 'Check-in online'),
(4, 4, '2025-11-21', '05:30', 'Balcão 5', 'valido', 1, NULL);

INSERT INTO CartaoEmbarque (idCartao, idCheckIn, idVoo, portaEmbarque, horaEmbarque) VALUES
(1, 1, 1, 'Gate 12', '07:30'),
(2, 2, 2, 'Gate 8', '10:00'),
(3, 3, 3, 'Gate 15', '13:30'),
(4, 4, 4, 'Gate 6', '06:45');

-----------------------------------------------------------------------
-- BAGAGENS
-----------------------------------------------------------------------

INSERT INTO Bagagem (idBagagem, idCheckIn, idSecao, peso, estadoValidacao, destino) VALUES
(1, 1, 101, 18.5, 'Aprovado', 'Porto'),
(2, 2, 101, 23.0, 'Aprovado', 'Paris'),
(3, 2, 101, 20.5, 'Aprovado', 'Paris'),
(4, 3, 101, 15.0, 'Aprovado', 'Londres'),
(5, 4, 101, 19.2, 'Aprovado', 'Madrid');

-----------------------------------------------------------------------
-- EQUIPAMENTOS
-----------------------------------------------------------------------

INSERT INTO Equipamento (idEquipamento, idPessoa, tipo, estado, emUso) VALUES
(1, 9, 'Scanner de Raio-X', 'Operacional', 1),
(2, 9, 'Detector de Metais', 'Operacional', 1),
(3, 10, 'Esteira de Bagagem', 'Operacional', 1),
(4, 9, 'Veículo de Rampa', 'Manutenção', 0),
(5, 10, 'Trator de Bagagem', 'Operacional', 1);

-----------------------------------------------------------------------
-- MANUTENÇÃO
-----------------------------------------------------------------------

INSERT INTO Manutencao (idManutencao, idAviao, idPessoa, data, tipo, custo) VALUES
(1, 1, 9, '2025-11-15', 'Inspeção de Rotina', 2500.00),
(2, 2, 9, '2025-11-10', 'Troca de Óleo', 1800.00),
(3, 3, 10, '2025-11-12', 'Verificação de Pneus', 950.00),
(4, 1, 10, '2025-11-18', 'Inspeção Pré-Voo', 500.00),
(5, 4, 9, '2025-11-16', 'Manutenção Preventiva', 3200.00);

-- Fim do ficheiro populate1.sql
