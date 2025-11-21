-- =============================================================================
-- create1.sql
-- Implementaçao do SQL para a primeira versao do desing relacional
-- Ainda sem modificaçoes ou sugestoes de IA
-- =============================================================================

-- Ativar foreign keys no SQLite
PRAGMA foreign_keys = ON;

-- =============================================================================
-- DROP TABLES (em ordem reversa de dependências)
-- =============================================================================

DROP TABLE IF EXISTS Bagagem;
DROP TABLE IF EXISTS CartaoEmbarque;
DROP TABLE IF EXISTS CheckIn;
DROP TABLE IF EXISTS Bilhete;
DROP TABLE IF EXISTS TripulacaoNoVoo;
DROP TABLE IF EXISTS PilotoDoAviao;
DROP TABLE IF EXISTS Aviao;
DROP TABLE IF EXISTS Voo;
DROP TABLE IF EXISTS Comissario;
DROP TABLE IF EXISTS Piloto;
DROP TABLE IF EXISTS FuncionarioAeroporto;
DROP TABLE IF EXISTS Tripulacao;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Passageiro;
DROP TABLE IF EXISTS CompanhiaAerea;
DROP TABLE IF EXISTS Pessoa;

-- =============================================================================
-- TABELA: Pessoa
-- Base para todos os indivíduos no sistema (passageiros e funcionários)
-- =============================================================================
CREATE TABLE Pessoa (
    numeroCC TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    dataNascimento DATE NOT NULL,
    infoContacto TEXT
);

-- =============================================================================
-- TABELA: Passageiro
-- Especialização de Pessoa para clientes que viajam
-- =============================================================================
CREATE TABLE Passageiro (
    numeroCC TEXT PRIMARY KEY,
    numeroPassaporte TEXT UNIQUE NOT NULL,
    FOREIGN KEY (numeroCC) REFERENCES Pessoa(numeroCC) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: CompanhiaAerea
-- Empresas operadoras de voos
-- =============================================================================
CREATE TABLE CompanhiaAerea (
    idCompanhia INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT UNIQUE NOT NULL
);

-- =============================================================================
-- TABELA: Voo
-- Informações sobre voos programados
-- =============================================================================
CREATE TABLE Voo (
    idVoo INTEGER PRIMARY KEY AUTOINCREMENT,
    idAviao INTEGER,
    horaPartida TIME NOT NULL,
    horaChegada TIME NOT NULL,
    origem TEXT NOT NULL,
    destino TEXT NOT NULL,
    data DATE NOT NULL,
    duracao INTEGER NOT NULL, -- em minutos
    lugaresDisponiveis INTEGER NOT NULL CHECK (lugaresDisponiveis >= 0),
    idCompanhia INTEGER NOT NULL,
    FOREIGN KEY (idCompanhia) REFERENCES CompanhiaAerea(idCompanhia)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: Funcionario
-- Base para todos os funcionários do sistema
-- =============================================================================
CREATE TABLE Funcionario (
    numeroCC TEXT NOT NULL,
    idFuncionario INTEGER PRIMARY KEY AUTOINCREMENT,
    horario TEXT,
    salario REAL CHECK (salario > 0),
    FOREIGN KEY (numeroCC) REFERENCES Pessoa(numeroCC)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: Tripulacao
-- Funcionários que trabalham em voos (pilotos e comissários)
-- =============================================================================
CREATE TABLE Tripulacao (
    idFuncionario INTEGER PRIMARY KEY,
    certificados TEXT,
    FOREIGN KEY (idFuncionario) REFERENCES Funcionario(idFuncionario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: FuncionarioAeroporto
-- Funcionários que trabalham em terra no aeroporto
-- =============================================================================
CREATE TABLE FuncionarioAeroporto (
    idFuncionario INTEGER PRIMARY KEY,
    departamento TEXT NOT NULL,
    FOREIGN KEY (idFuncionario) REFERENCES Funcionario(idFuncionario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: Piloto
-- Tripulação habilitada para pilotar aeronaves
-- =============================================================================
CREATE TABLE Piloto (
    idFuncionario INTEGER PRIMARY KEY,
    nLicenca TEXT UNIQUE NOT NULL,
    FOREIGN KEY (idFuncionario) REFERENCES Tripulacao(idFuncionario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: Comissario
-- Tripulação responsável pelo atendimento aos passageiros
-- =============================================================================
CREATE TABLE Comissario (
    idFuncionario INTEGER PRIMARY KEY,
    funcao TEXT NOT NULL, -- ex: chefe de cabine, comissário sênior, etc.
    FOREIGN KEY (idFuncionario) REFERENCES Tripulacao(idFuncionario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: Aviao
-- Aeronaves da frota
-- =============================================================================
CREATE TABLE Aviao (
    idAviao INTEGER PRIMARY KEY AUTOINCREMENT,
    modelo TEXT NOT NULL,
    numMotores INTEGER NOT NULL CHECK (numMotores > 0),
    status TEXT NOT NULL, -- ex: 'operacional', 'manutenção', 'inativo'
    capacidade INTEGER NOT NULL CHECK (capacidade > 0),
    peso REAL NOT NULL CHECK (peso > 0), -- em kg
    depositoGasolina REAL NOT NULL CHECK (depositoGasolina > 0), -- em litros
    consumoMedio REAL NOT NULL CHECK (consumoMedio > 0), -- litros/hora
    velocidadeMax REAL NOT NULL CHECK (velocidadeMax > 0), -- km/h
    tempoUsoTotal INTEGER DEFAULT 0, -- em horas de voo
    idCompanhia INTEGER NOT NULL,
    idVoo INTEGER, -- voo atual (pode ser NULL se não estiver alocado)
    FOREIGN KEY (idCompanhia) REFERENCES CompanhiaAerea(idCompanhia)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (idVoo) REFERENCES Voo(idVoo)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: PilotoDoAviao
-- Relacionamento entre pilotos e aviões que estão autorizados a pilotar
-- =============================================================================
CREATE TABLE PilotoDoAviao (
    idAviao INTEGER NOT NULL,
    idFuncionario INTEGER NOT NULL,
    PRIMARY KEY (idAviao, idFuncionario),
    FOREIGN KEY (idAviao) REFERENCES Aviao(idAviao)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idFuncionario) REFERENCES Piloto(idFuncionario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: TripulacaoNoVoo
-- Atribuição de tripulantes a voos específicos
-- =============================================================================
CREATE TABLE TripulacaoNoVoo (
    idVoo INTEGER NOT NULL,
    idFuncionario INTEGER NOT NULL,
    PRIMARY KEY (idVoo, idFuncionario),
    FOREIGN KEY (idVoo) REFERENCES Voo(idVoo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idFuncionario) REFERENCES Tripulacao(idFuncionario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: Bilhete
-- Bilhetes/passagens comprados pelos passageiros
-- =============================================================================
CREATE TABLE Bilhete (
    idBilhete INTEGER PRIMARY KEY AUTOINCREMENT,
    numeroLugar TEXT NOT NULL,
    classe TEXT NOT NULL, -- ex: 'econômica', 'executiva', 'primeira classe'
    preco REAL NOT NULL CHECK (preco >= 0),
    idVoo INTEGER NOT NULL,
    numeroCCPassageiro TEXT NOT NULL,
    FOREIGN KEY (idVoo) REFERENCES Voo(idVoo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (numeroCCPassageiro) REFERENCES Passageiro(numeroCC)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    UNIQUE (idVoo, numeroLugar) -- cada lugar é único por voo
);

-- =============================================================================
-- TABELA: CheckIn
-- Processo de check-in realizado pelos passageiros
-- =============================================================================
CREATE TABLE CheckIn (
    idCheckIn INTEGER PRIMARY KEY AUTOINCREMENT,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    local TEXT NOT NULL, -- ex: 'balcão 5', 'online', 'quiosque 3'
    estado TEXT NOT NULL, -- ex: 'concluído', 'pendente', 'cancelado'
    nMalas INTEGER DEFAULT 0 CHECK (nMalas >= 0),
    pesoTotal REAL DEFAULT 0 CHECK (pesoTotal >= 0), -- em kg
    observacoes TEXT,
    numeroCCPassageiro TEXT NOT NULL,
    FOREIGN KEY (numeroCCPassageiro) REFERENCES Passageiro(numeroCC)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: CartaoEmbarque
-- Cartões de embarque emitidos após check-in
-- =============================================================================
CREATE TABLE CartaoEmbarque (
    idCartao INTEGER PRIMARY KEY AUTOINCREMENT,
    portaEmbarque TEXT NOT NULL,
    horaEmbarque TIME NOT NULL,
    idCheckIn INTEGER UNIQUE NOT NULL, -- cada check-in gera um cartão
    idVoo INTEGER NOT NULL,
    FOREIGN KEY (idCheckIn) REFERENCES CheckIn(idCheckIn)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idVoo) REFERENCES Voo(idVoo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =============================================================================
-- TABELA: Bagagem
-- Bagagens despachadas pelos passageiros
-- =============================================================================
CREATE TABLE Bagagem (
    idBagagem INTEGER PRIMARY KEY AUTOINCREMENT,
    peso REAL NOT NULL CHECK (peso > 0), -- em kg
    status TEXT NOT NULL, -- ex: 'despachada', 'em trânsito', 'entregue', 'extraviada'
    destinoFinal TEXT NOT NULL,
    idCheckIn INTEGER NOT NULL,
    FOREIGN KEY (idCheckIn) REFERENCES CheckIn(idCheckIn)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =============================================================================
-- FIM DO SCHEMA
-- =============================================================================