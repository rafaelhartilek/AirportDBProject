-- create1.sql
-- Esquema da base de dados do aeroporto

PRAGMA foreign_keys = ON;

------------------------------------------------------------
-- Dropar tabelas se já existirem (ordem inversa das dependências)
------------------------------------------------------------

DROP TABLE IF EXISTS Manutencao;
DROP TABLE IF EXISTS Equipamento;
DROP TABLE IF EXISTS Bagagem;
DROP TABLE IF EXISTS CartaoEmbarque;
DROP TABLE IF EXISTS CheckIn;
DROP TABLE IF EXISTS Bilhete;
DROP TABLE IF EXISTS PermissaoPiloto;
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

------------------------------------------------------------
-- Tabela base: Pessoa
------------------------------------------------------------

CREATE TABLE Pessoa (
    idPessoa       INTEGER PRIMARY KEY,
    nome           TEXT    NOT NULL,
    nif            TEXT    NOT NULL,
    dataNascimento DATE    NOT NULL,
    contacto       TEXT
);

------------------------------------------------------------
-- Subclasses de Pessoa
------------------------------------------------------------

CREATE TABLE Passageiro (
    idPessoa      INTEGER PRIMARY KEY,
    numPassaporte TEXT    NOT NULL,
    FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
);

CREATE TABLE Funcionario (
    idPessoa      INTEGER PRIMARY KEY,
    idFuncionario INTEGER NOT NULL,
    salario       REAL    NOT NULL,
    horario       TEXT    NOT NULL,
    FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
);

------------------------------------------------------------
-- Subclasses de Funcionario
------------------------------------------------------------

CREATE TABLE Tripulacao (
    idPessoa        INTEGER PRIMARY KEY,
    certificacoes   TEXT,
    idiomasFalados  TEXT,
    disponibilidade TEXT,
    FOREIGN KEY (idPessoa) REFERENCES Funcionario(idPessoa)
);

CREATE TABLE Piloto (
    idPessoa          INTEGER PRIMARY KEY,
    numLicenca        TEXT    NOT NULL,
    validadeLicenca   DATE    NOT NULL,
    nivelCertificacao TEXT    NOT NULL,
    FOREIGN KEY (idPessoa) REFERENCES Tripulacao(idPessoa)
);

CREATE TABLE Comissario (
    idPessoa    INTEGER PRIMARY KEY,
    funcaoBordo TEXT    NOT NULL,
    FOREIGN KEY (idPessoa) REFERENCES Tripulacao(idPessoa)
);

CREATE TABLE FuncionarioAeroporto (
    idPessoa INTEGER PRIMARY KEY,
    turno    TEXT    NOT NULL,
    FOREIGN KEY (idPessoa) REFERENCES Funcionario(idPessoa)
);

------------------------------------------------------------
-- Segurança (subclasse / especialização de FuncionarioAeroporto)
------------------------------------------------------------

CREATE TABLE Seguranca (
    idPessoa                   INTEGER PRIMARY KEY,
    idSecao                    INTEGER NOT NULL,
    resultadoVerificacaoPadrao TEXT    NOT NULL,
    UNIQUE (idSecao),
    FOREIGN KEY (idPessoa) REFERENCES FuncionarioAeroporto(idPessoa)
);

------------------------------------------------------------
-- Companhia aérea, avião e voo
------------------------------------------------------------

CREATE TABLE CompanhiaAerea (
    idCompanhia INTEGER PRIMARY KEY,
    nome        TEXT    NOT NULL
);

CREATE TABLE Aviao (
    idAviao               INTEGER PRIMARY KEY,
    idCompanhia           INTEGER NOT NULL,
    modelo                TEXT    NOT NULL,
    capacidade            INTEGER NOT NULL,
    velocidadeMaxima      REAL,
    numMotores            INTEGER,
    peso                  REAL,
    combustivelDepositado REAL,
    horasVoo              INTEGER,
    FOREIGN KEY (idCompanhia) REFERENCES CompanhiaAerea(idCompanhia)
);

CREATE TABLE Voo (
    idVoo        INTEGER PRIMARY KEY,
    idAviao      INTEGER NOT NULL,
    origem       TEXT    NOT NULL,
    destino      TEXT    NOT NULL,
    horaPartida  TEXT    NOT NULL,   -- pode ser TIME ou DATETIME
    horaChegada  TEXT    NOT NULL,
    duracao      INTEGER NOT NULL,   -- por exemplo, em minutos
    FOREIGN KEY (idAviao) REFERENCES Aviao(idAviao)
);

------------------------------------------------------------
-- Permissão do piloto para voar um certo avião
------------------------------------------------------------

CREATE TABLE PermissaoPiloto (
    idPessoa   INTEGER NOT NULL,
    idAviao    INTEGER NOT NULL,
    autorizado INTEGER NOT NULL,   -- 0 = falso, 1 = verdadeiro
    restricao  TEXT,
    PRIMARY KEY (idPessoa, idAviao),
    FOREIGN KEY (idPessoa) REFERENCES Piloto(idPessoa),
    FOREIGN KEY (idAviao)  REFERENCES Aviao(idAviao)
);

------------------------------------------------------------
-- Bilhete, check-in, cartão de embarque
------------------------------------------------------------

CREATE TABLE Bilhete (
    idBilhete  INTEGER PRIMARY KEY,
    idPessoa   INTEGER NOT NULL,
    idVoo      INTEGER NOT NULL,
    numLugar   INTEGER NOT NULL,
    classeVoo  TEXT    NOT NULL,
    preco      REAL    NOT NULL,
    FOREIGN KEY (idPessoa) REFERENCES Passageiro(idPessoa),
    FOREIGN KEY (idVoo)    REFERENCES Voo(idVoo)
);

CREATE TABLE CheckIn (
    idCheckIn   INTEGER PRIMARY KEY,
    idBilhete   INTEGER NOT NULL,
    data        DATE    NOT NULL,
    hora        TEXT    NOT NULL,
    local       TEXT    NOT NULL,
    estado      TEXT    NOT NULL,   -- por ex.: 'valido' / 'invalido'
    numMalas    INTEGER NOT NULL,
    observacoes TEXT,
    FOREIGN KEY (idBilhete) REFERENCES Bilhete(idBilhete)
);

CREATE TABLE CartaoEmbarque (
    idCartao      INTEGER PRIMARY KEY,
    idCheckIn     INTEGER NOT NULL,
    idVoo         INTEGER NOT NULL,
    portaEmbarque TEXT    NOT NULL,
    horaEmbarque  TEXT    NOT NULL,
    FOREIGN KEY (idCheckIn) REFERENCES CheckIn(idCheckIn),
    FOREIGN KEY (idVoo)     REFERENCES Voo(idVoo)
);

------------------------------------------------------------
-- Bagagem
------------------------------------------------------------

CREATE TABLE Bagagem (
    idBagagem       INTEGER PRIMARY KEY,
    idCheckIn       INTEGER NOT NULL,
    idSecao         INTEGER NOT NULL,
    peso            REAL    NOT NULL,
    estadoValidacao TEXT    NOT NULL,
    destino         TEXT    NOT NULL,
    FOREIGN KEY (idCheckIn) REFERENCES CheckIn(idCheckIn),
    FOREIGN KEY (idSecao)   REFERENCES Seguranca(idSecao)
);

------------------------------------------------------------
-- Equipamento e manutenção
------------------------------------------------------------

CREATE TABLE Equipamento (
    idEquipamento INTEGER PRIMARY KEY,
    idPessoa      INTEGER NOT NULL,
    tipo          TEXT    NOT NULL,
    estado        TEXT    NOT NULL,
    emUso         INTEGER NOT NULL,  -- 0/1
    FOREIGN KEY (idPessoa) REFERENCES FuncionarioAeroporto(idPessoa)
);

CREATE TABLE Manutencao (
    idManutencao INTEGER PRIMARY KEY,
    idAviao      INTEGER NOT NULL,
    idPessoa     INTEGER NOT NULL,
    data         DATE    NOT NULL,
    tipo         TEXT    NOT NULL,
    custo        REAL,
    FOREIGN KEY (idAviao)  REFERENCES Aviao(idAviao),
    FOREIGN KEY (idPessoa) REFERENCES FuncionarioAeroporto(idPessoa)
);
