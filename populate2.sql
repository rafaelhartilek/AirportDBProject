-- populate2.sql
-- Versão final do script de povoamento para o esquema de aeroporto (create2.sql)
-- Baseado em populate1.sql, no esquema refinado em BCNF (relationalDesignWithAI.md)
-- e nas especificações do Project Description.
-- Gerado com apoio de IA por ChatGPT – GPT-5.1 Thinking.

PRAGMA foreign_keys = ON;

-----------------------------------------------------------------------
-- PESSOAS E ESPECIALIZAÇÕES
-----------------------------------------------------------------------

-- Pessoas (base para todas as especializações)
INSERT INTO Pessoa (idPessoa, nome, nif, dataNascimento, contacto) VALUES
(1,  'João Silva',       '111111111', '1985-03-15', '912345678'),
(2,  'Maria Santos',     '222222222', '1990-07-22', '923456789'),
(3,  'Pedro Costa',      '333333333', '1982-11-10', '934567890'),
(4,  'Ana Oliveira',     '444444444', '1988-05-18', '945678901'),
(5,  'Carlos Pereira',   '555555555', '1975-01-09', '956789012'),
(6,  'Sofia Almeida',    '666666666', '1983-09-30', '967890123'),
(7,  'Luís Rocha',       '777777777', '1979-06-21', '978901234'),
(8,  'Marta Gomes',      '888888888', '1992-02-14', '989012345'),
(9,  'Paulo Ferreira',   '999999999', '1980-12-03', '990123456'),
(10, 'Rita Marques',     '101010101', '1995-09-30', '901234567');

-- Passageiros (subclasse de Pessoa)
INSERT INTO Passageiro (idPessoa, numPassaporte) VALUES
(1, 'PT123456'),
(2, 'PT234567'),
(3, 'PT345678'),
(4, 'PT456789');

-- Funcionários (subclasse de Pessoa)
INSERT INTO Funcionario (idPessoa, salario, horario) VALUES
(5,  4500.00, '06:00-14:00'),
(6,  4300.00, '14:00-22:00'),
(7,  2800.00, '08:00-16:00'),
(8,  2200.00, '07:00-15:00'),
(9,  2300.00, '15:00-23:00'),
(10, 2400.00, '23:00-07:00');

-- Tripulação (subclasse de Funcionario)
INSERT INTO Tripulacao (idPessoa, certificacoes, idiomasFalados, disponibilidade) VALUES
(5, 'ATPL, IFR',                   'Português, Inglês',              'Disponível'),
(6, 'CPL, IFR',                    'Português, Inglês, Espanhol',    'Disponível'),
(7, 'Cabin Crew Safety',           'Português, Inglês, Francês',     'Disponível');

-- Pilotos (subclasse de Tripulacao)
INSERT INTO Piloto (idPessoa, numLicenca, validadeLicenca, nivelCertificacao) VALUES
(5, 'PIL-2018-0001', '2027-03-31', 'Comandante'),
(6, 'PIL-2020-0042', '2028-06-30', 'Primeiro Oficial');

-- Comissários (subclasse de Tripulacao)
INSERT INTO Comissario (idPessoa, funcaoBordo) VALUES
(7, 'Chefe de Cabine');

-- Funcionários de aeroporto (subclasse de Funcionario)
INSERT INTO FuncionarioAeroporto (idPessoa, turno) VALUES
(8, 'Manhã'),
(9, 'Tarde'),
(10,'Noite');

-- Segurança (subclasse de FuncionarioAeroporto)
INSERT INTO Seguranca (idPessoa, idSecao, resultadoVerificacaoPadrao) VALUES
(8, 101, 'Aprovado'),
(9, 102, 'Aprovado');

-----------------------------------------------------------------------
-- COMPANHIAS, AVIÕES E VOOS
-----------------------------------------------------------------------

INSERT INTO CompanhiaAerea (idCompanhia, nome) VALUES
(1, 'TAP Air Portugal'),
(2, 'Ryanair'),
(3, 'easyJet');

INSERT INTO Aviao (
    idAviao, idCompanhia, modelo, capacidade,
    velocidadeMaxima, numMotores, peso,
    combustivelDepositado, horasVoo
) VALUES
(1, 1, 'Airbus A320', 180, 840.0, 2, 73500.0, 24000.0, 12000.0),
(2, 1, 'Airbus A321', 200, 830.0, 2, 89000.0, 26000.0,  9500.0),
(3, 2, 'Boeing 737-800', 189, 842.0, 2, 79015.0, 23800.0, 10000.0),
(4, 3, 'Airbus A319', 144, 828.0, 2, 75500.0, 22000.0,  8000.0);

INSERT INTO Voo (
    idVoo, idAviao, origem, destino,
    horaPartida,          horaChegada,         duracao
) VALUES
(1, 1, 'Lisboa',  'Porto',  '2025-11-20 08:00', '2025-11-20 08:50',  50),
(2, 1, 'Porto',   'Faro',   '2025-11-20 10:00', '2025-11-20 11:05',  65),
(3, 3, 'Lisboa',  'Londres','2025-11-20 14:00', '2025-11-20 16:40', 160),
(4, 4, 'Porto',   'Madrid', '2025-11-21 06:00', '2025-11-21 07:45', 105),
(5, 2, 'Faro',    'Lisboa', '2025-11-22 17:00', '2025-11-22 17:45',  45);

-----------------------------------------------------------------------
-- BILHETES, CHECK-IN E CARTÕES DE EMBARQUE
-----------------------------------------------------------------------

INSERT INTO Bilhete (
    idBilhete, idPessoa, idVoo,
    numLugar, classeVoo, preco
) VALUES
(1, 1, 1, '12A', 'Económica',  80.00),
(2, 2, 1, '12B', 'Económica',  80.00),
(3, 3, 3, '3C',  'Executiva', 350.00),
(4, 4, 4, '20D', 'Económica', 120.00),
(5, 1, 5, '5A',  'Económica',  70.00);

INSERT INTO CheckIn (
    idCheckIn, idBilhete, data, hora,
    local,       estado,   numMalas, observacoes
) VALUES
(1, 1, '2025-11-20', '06:30', 'Balcão 10', 'valido',   1, NULL),
(2, 2, '2025-11-20', '06:45', 'Balcão 10', 'valido',   0, 'Passageiro sem bagagem'),
(3, 3, '2025-11-20', '12:00', 'Online',    'valido',   1, 'Check-in online'),
(4, 4, '2025-11-21', '04:45', 'Balcão 5',  'valido',   2, NULL),
(5, 5, '2025-11-22', '16:10', 'Online',    'invalido', 0, 'Pagamento pendente');

INSERT INTO CartaoEmbarque (
    idCartao, idCheckIn, idVoo,
    portaEmbarque, horaEmbarque
) VALUES
(1, 1, 1, 'Gate 15', '07:30'),
(2, 2, 1, 'Gate 15', '07:30'),
(3, 3, 3, 'Gate 7',  '13:30'),
(4, 4, 4, 'Gate 2',  '06:15');

-----------------------------------------------------------------------
-- BAGAGEM
-----------------------------------------------------------------------

INSERT INTO Bagagem (
    idBagagem, idCheckIn, idSecao,
    peso,  estadoValidacao, destino
) VALUES
(1, 1, 101, 18.5, 'Aprovado',  'Porto'),
(2, 1, 101,  9.2, 'Aprovado',  'Porto'),
(3, 3, 102, 21.0, 'Aprovado',  'Londres'),
(4, 4, 101, 23.0, 'Reprovado', 'Madrid'),
(5, 4, 102, 19.2, 'Aprovado',  'Madrid');

-----------------------------------------------------------------------
-- EQUIPAMENTO
-----------------------------------------------------------------------

INSERT INTO Equipamento (
    idEquipamento, idPessoa,
    tipo,                   estado,       emUso
) VALUES
(1, 8,  'Scanner de Raio-X', 'Operacional', 1),
(2, 8,  'Detetor de Metais', 'Operacional', 1),
(3, 9,  'Veículo de Rampa',  'Manutenção',  0),
(4, 10, 'Esteira de Bagagem','Operacional', 1),
(5, 10, 'Trator de Bagagem', 'Operacional', 1);

-----------------------------------------------------------------------
-- MANUTENÇÃO
-----------------------------------------------------------------------

INSERT INTO Manutencao (
    idManutencao, idAviao, idPessoa,
    data,        tipo,                 custo
) VALUES
(1, 1, 9,  '2025-11-15', 'Inspeção de Rotina',    2500.00),
(2, 2, 9,  '2025-11-10', 'Troca de Óleo',         1800.00),
(3, 3, 10, '2025-11-12', 'Verificação de Pneus',   950.00),
(4, 1, 10, '2025-11-18', 'Inspeção Pré-Voo',       500.00),
(5, 4, 9,  '2025-11-16', 'Manutenção Preventiva', 3200.00);

-- Fim do ficheiro populate2.sql
-- Script final de povoamento elaborado com apoio de IA (ChatGPT – GPT-5.1 Thinking).
