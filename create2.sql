-- create2.sql
-- Versão final do esquema relacional do aeroporto (BCNF),
-- baseada em relationalDesignWithAI.md e ajustada para SQLite.
-- Relational schema refinado com apoio de IA por ChatGPT – GPT-5.1 Thinking.

PRAGMA foreign_keys = ON;

-----------------------------------------------------------------------
-- DROP TABLES (em ordem inversa de dependências)
-----------------------------------------------------------------------

DROP TABLE IF EXISTS Manutencao;
DROP TABLE IF EXISTS Equipamento;
DROP TABLE IF EXISTS Bagagem;
DROP TABLE IF EXISTS CartaoEmbarque;
DROP TABLE IF EXISTS CheckIn;
DROP TABLE IF EXISTS Bilhete;
DROP TABLE IF EXISTS Voo;
DROP TABLE IF EXISTS Aviao;
DROP TABLE IF EXISTS CompanhiaAerea;
DROP TABLE IF EXISTS Seguranca;
DROP TABLE IF EXISTS FuncionarioAeroporto;
DROP TABLE IF EXISTS Comissario;
DROP TABLE IF EXISTS Piloto;
DROP TABLE IF EXISTS Tripulacao;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Passageiro;
DROP TABLE IF EXISTS Pessoa;

-----------------------------------------------------------------------
-- TABELAS BASE (Pessoa e especializações)
-----------------------------------------------------------------------

CREATE TABLE Pessoa (
    idPessoa        INTEGER PRIMARY KEY,
    nome            TEXT    NOT NULL,
    nif             TEXT    NOT NULL UNIQUE,
    dataNascimento  TEXT    NOT NULL, -- formato recomendado: 'YYYY-MM-DD'
    contacto        TEXT
);

CREATE TABLE Passageiro (
    idPessoa        INTEGER PRIMARY KEY,
    numPassaporte   TEXT    NOT NULL UNIQUE,
    FOREIGN KEY (idPessoa)
        REFERENCES Pessoa(idPessoa)
        ON DELETE CASCADE
);

CREATE TABLE Funcionario (
    idPessoa    INTEGER PRIMARY KEY,
    salario     REAL    NOT NULL CHECK (salario >= 0),
    horario     TEXT    NOT NULL,
    FOREIGN KEY (idPessoa)
        REFERENCES Pessoa(idPessoa)
        ON DELETE CASCADE
);

CREATE TABLE Tripulacao (
    idPessoa        INTEGER PRIMARY KEY,
    certificacoes   TEXT,
    idiomasFalados  TEXT,
    disponibilidade TEXT,
    FOREIGN KEY (idPessoa)
        REFERENCES Funcionario(idPessoa)
        ON DELETE CASCADE
);

CREATE TABLE Piloto (
    idPessoa            INTEGER PRIMARY KEY,
    numLicenca          TEXT    NOT NULL UNIQUE,
    validadeLicenca     TEXT,           -- 'YYYY-MM-DD'
    nivelCertificacao   TEXT,
    FOREIGN KEY (idPessoa)
        REFERENCES Tripulacao(idPessoa)
        ON DELETE CASCADE
);

CREATE TABLE Comissario (
    idPessoa    INTEGER PRIMARY KEY,
    funcaoBordo TEXT    NOT NULL,
    FOREIGN KEY (idPessoa)
        REFERENCES Tripulacao(idPessoa)
        ON DELETE CASCADE
);

CREATE TABLE FuncionarioAeroporto (
    idPessoa    INTEGER PRIMARY KEY,
    turno       TEXT    NOT NULL,
    FOREIGN KEY (idPessoa)
        REFERENCES Funcionario(idPessoa)
        ON DELETE CASCADE
);

CREATE TABLE Seguranca (
    idPessoa                    INTEGER PRIMARY KEY,
    idSecao                     INTEGER NOT NULL UNIQUE,
    resultadoVerificacaoPadrao  TEXT,
    FOREIGN KEY (idPessoa)
        REFERENCES FuncionarioAeroporto(idPessoa)
        ON DELETE CASCADE
);

-----------------------------------------------------------------------
-- COMPANHIA, AVIÃO, VOO
-----------------------------------------------------------------------

CREATE TABLE CompanhiaAerea (
    idCompanhia INTEGER PRIMARY KEY,
    nome        TEXT NOT NULL UNIQUE
);

CREATE TABLE Aviao (
    idAviao                 INTEGER PRIMARY KEY,
    idCompanhia             INTEGER NOT NULL,
    modelo                  TEXT    NOT NULL,
    capacidade              INTEGER NOT NULL CHECK (capacidade > 0),
    velocidadeMaxima        REAL,
    numMotores              INTEGER,
    peso                    REAL,
    combustivelDepositado   REAL,
    horasVoo                REAL,
    FOREIGN KEY (idCompanhia)
        REFERENCES CompanhiaAerea(idCompanhia)
        ON DELETE RESTRICT
);

CREATE TABLE Voo (
    idVoo           INTEGER PRIMARY KEY,
    idAviao         INTEGER NOT NULL,
    origem          TEXT    NOT NULL,
    destino         TEXT    NOT NULL,
    horaPartida     TEXT    NOT NULL, -- 'YYYY-MM-DD HH:MM'
    horaChegada     TEXT    NOT NULL, -- 'YYYY-MM-DD HH:MM'
    duracao         INTEGER NOT NULL, -- em minutos, por exemplo
    FOREIGN KEY (idAviao)
        REFERENCES Aviao(idAviao)
        ON DELETE RESTRICT,
    CHECK (origem <> destino)
);

-----------------------------------------------------------------------
-- BILHETE, CHECK-IN, CARTÃO DE EMBARQUE
-----------------------------------------------------------------------

CREATE TABLE Bilhete (
    idBilhete   INTEGER PRIMARY KEY,
    idPessoa    INTEGER NOT NULL,  -- Passageiro
    idVoo       INTEGER NOT NULL,
    numLugar    TEXT    NOT NULL,
    classeVoo   TEXT    NOT NULL,
    preco       REAL    NOT NULL CHECK (preco >= 0),
    FOREIGN KEY (idPessoa)
        REFERENCES Passageiro(idPessoa)
        ON DELETE RESTRICT,
    FOREIGN KEY (idVoo)
        REFERENCES Voo(idVoo)
        ON DELETE RESTRICT,
    -- Um mesmo lugar num voo não deve ser vendido duas vezes
    UNIQUE (idVoo, numLugar)
);

CREATE TABLE CheckIn (
    idCheckIn   INTEGER PRIMARY KEY,
    idBilhete   INTEGER NOT NULL UNIQUE, -- um check-in por bilhete
    data        TEXT    NOT NULL,        -- 'YYYY-MM-DD'
    hora        TEXT    NOT NULL,        -- 'HH:MM'
    local       TEXT    NOT NULL,
    estado      TEXT    NOT NULL CHECK (estado IN ('valido', 'invalido')),
    numMalas    INTEGER NOT NULL CHECK (numMalas >= 0),
    observacoes TEXT,
    FOREIGN KEY (idBilhete)
        REFERENCES Bilhete(idBilhete)
        ON DELETE CASCADE
);

CREATE TABLE CartaoEmbarque (
    idCartao        INTEGER PRIMARY KEY,
    idCheckIn       INTEGER NOT NULL UNIQUE, -- um cartão por check-in
    idVoo           INTEGER NOT NULL,
    portaEmbarque   TEXT    NOT NULL,
    horaEmbarque    TEXT    NOT NULL,        -- 'HH:MM' (no dia do voo)
    FOREIGN KEY (idCheckIn)
        REFERENCES CheckIn(idCheckIn)
        ON DELETE CASCADE,
    FOREIGN KEY (idVoo)
        REFERENCES Voo(idVoo)
        ON DELETE RESTRICT
);

-----------------------------------------------------------------------
-- BAGAGEM
-----------------------------------------------------------------------

CREATE TABLE Bagagem (
    idBagagem       INTEGER PRIMARY KEY,
    idCheckIn       INTEGER NOT NULL,
    idSecao         INTEGER NOT NULL,
    peso            REAL    NOT NULL CHECK (peso >= 0),
    estadoValidacao TEXT    NOT NULL,
    destino         TEXT    NOT NULL,
    FOREIGN KEY (idCheckIn)
        REFERENCES CheckIn(idCheckIn)
        ON DELETE CASCADE,
    FOREIGN KEY (idSecao)
        REFERENCES Seguranca(idSecao)
        ON DELETE RESTRICT
);

-----------------------------------------------------------------------
-- EQUIPAMENTO E MANUTENÇÃO
-----------------------------------------------------------------------

CREATE TABLE Equipamento (
    idEquipamento   INTEGER PRIMARY KEY,
    idPessoa        INTEGER NOT NULL, -- FuncionarioAeroporto responsável
    tipo            TEXT    NOT NULL,
    estado          TEXT    NOT NULL,
    emUso           INTEGER NOT NULL CHECK (emUso IN (0, 1)),
    FOREIGN KEY (idPessoa)
        REFERENCES FuncionarioAeroporto(idPessoa)
        ON DELETE RESTRICT
);

CREATE TABLE Manutencao (
    idManutencao    INTEGER PRIMARY KEY,
    idAviao         INTEGER NOT NULL,
    idPessoa        INTEGER NOT NULL, -- FuncionarioAeroporto que executa
    data            TEXT    NOT NULL, -- 'YYYY-MM-DD'
    tipo            TEXT    NOT NULL,
    custo           REAL    NOT NULL CHECK (custo >= 0),
    FOREIGN KEY (idAviao)
        REFERENCES Aviao(idAviao)
        ON DELETE CASCADE,
    FOREIGN KEY (idPessoa)
        REFERENCES FuncionarioAeroporto(idPessoa)
        ON DELETE RESTRICT
);

-- Fim do ficheiro create2.sql
-- Relational schema refinado com apoio de IA por ChatGPT – GPT-5.1 Thinking.
