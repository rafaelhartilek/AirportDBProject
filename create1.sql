-- Drop all tables if exist (in reverse dependency order)
DROP TABLE IF EXISTS Seguranca;
DROP TABLE IF EXISTS FuncionarioAeroporto;
DROP TABLE IF EXISTS Comissario;
DROP TABLE IF EXISTS Piloto;
DROP TABLE IF EXISTS Tripulacao;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Passageiro;
DROP TABLE IF EXISTS CartaoEmbarque;
DROP TABLE IF EXISTS CheckIn;
DROP TABLE IF EXISTS Bilhete;
DROP TABLE IF EXISTS Voo;
DROP TABLE IF EXISTS Aviao;
DROP TABLE IF EXISTS CompanhiaAerea;
DROP TABLE IF EXISTS Bagagem;
DROP TABLE IF EXISTS Equipamento;
DROP TABLE IF EXISTS Manutencao;
DROP TABLE IF EXISTS Pessoa;

-- Pessoa
CREATE TABLE Pessoa (
  idPessoa INTEGER PRIMARY KEY,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT
);

-- Passageiro
CREATE TABLE Passageiro (
  idPassageiro INTEGER PRIMARY KEY,
  idPessoa INTEGER,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT,
  numPassaporte TEXT,
  FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
);

-- Funcionario
CREATE TABLE Funcionario (
  idFuncionario INTEGER PRIMARY KEY,
  idPessoa INTEGER,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT,
  salario REAL,
  horario TEXT,
  FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
);

-- Tripulacao
CREATE TABLE Tripulacao (
  idTripulacao INTEGER PRIMARY KEY,
  idFuncionario INTEGER,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT,
  salario REAL,
  horario TEXT,
  certificacoes TEXT,
  idiomasFalados TEXT,
  disponibilidade TEXT,
  FOREIGN KEY (idFuncionario) REFERENCES Funcionario(idFuncionario)
);

-- Piloto
CREATE TABLE Piloto (
  idPiloto INTEGER PRIMARY KEY,
  idTripulacao INTEGER,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT,
  salario REAL,
  horario TEXT,
  certificacoes TEXT,
  idiomasFalados TEXT,
  disponibilidade TEXT,
  idPessoa INTEGER,
  numLicenca TEXT,
  validadeLicenca DATE,
  nivelCertificacao TEXT,
  FOREIGN KEY (idTripulacao) REFERENCES Tripulacao(idTripulacao),
  FOREIGN KEY (idPessoa) REFERENCES Pessoa(idPessoa)
);

-- Comissario
CREATE TABLE Comissario (
  idComissario INTEGER PRIMARY KEY,
  idTripulacao INTEGER,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT,
  salario REAL,
  horario TEXT,
  certificacoes TEXT,
  idiomasFalados TEXT,
  disponibilidade TEXT,
  funcaoBordo TEXT,
  FOREIGN KEY (idTripulacao) REFERENCES Tripulacao(idTripulacao)
);

-- FuncionarioAeroporto
CREATE TABLE FuncionarioAeroporto (
  idFuncionarioAeroporto INTEGER PRIMARY KEY,
  idFuncionario INTEGER,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT,
  salario REAL,
  horario TEXT,
  turno TEXT,
  FOREIGN KEY (idFuncionario) REFERENCES Funcionario(idFuncionario)
);

-- Seguranca
CREATE TABLE Seguranca (
  idSeguranca INTEGER PRIMARY KEY,
  idFuncionarioAeroporto INTEGER,
  nome TEXT,
  nif TEXT,
  dataNascimento DATE,
  contacto TEXT,
  salario REAL,
  horario TEXT,
  turno TEXT,
  idSecao INTEGER,
  resultadoVerificacaoPadrao TEXT,
  FOREIGN KEY (idFuncionarioAeroporto) REFERENCES FuncionarioAeroporto(idFuncionarioAeroporto)
);

-- CompanhiaAerea
CREATE TABLE CompanhiaAerea (
  idCompanhiaAerea INTEGER PRIMARY KEY,
  idCompanhia INTEGER,
  nome TEXT
);

-- Aviao
CREATE TABLE Aviao (
  idAviao INTEGER PRIMARY KEY,
  modelo TEXT,
  capacidade INTEGER,
  velocidadeMaxima REAL,
  numMotores INTEGER,
  peso REAL,
  combustivelDepositado REAL,
  horasVoo REAL
);

-- Voo
CREATE TABLE Voo (
  idVoo INTEGER PRIMARY KEY,
  horaPartida DATETIME,
  horaChegada DATETIME,
  origem TEXT,
  destino TEXT,
  duracao INTEGER
);

-- Bilhete
CREATE TABLE Bilhete (
  idBilhete INTEGER PRIMARY KEY,
  idVoo INTEGER,
  numLugar TEXT,
  classeVoo TEXT,
  preco REAL,
  FOREIGN KEY (idVoo) REFERENCES Voo(idVoo)
);

-- CheckIn
CREATE TABLE CheckIn (
  idCheckIn INTEGER PRIMARY KEY,
  data DATE,
  hora TIME,
  local TEXT,
  estado TEXT,
  numMalas INTEGER,
  observacoes TEXT,
  idBilhete INTEGER,
  FOREIGN KEY (idBilhete) REFERENCES Bilhete(idBilhete)
);

-- CartaoEmbarque
CREATE TABLE CartaoEmbarque (
  idCartaoEmbarque INTEGER PRIMARY KEY,
  idCartao INTEGER,
  portaEmbarque TEXT,
  horaEmbarque TIME,
  FOREIGN KEY (idCartao) REFERENCES CheckIn(idCheckIn)
);

-- Bagagem
CREATE TABLE Bagagem (
  idBagagem INTEGER PRIMARY KEY,
  peso REAL,
  estadoValidacao TEXT,
  destino TEXT
);

-- Equipamento
CREATE TABLE Equipamento (
  idEquipamento INTEGER PRIMARY KEY,
  tipo TEXT,
  estado TEXT,
  emUso BOOLEAN
);

-- Manutencao
CREATE TABLE Manutencao (
  idManutencao INTEGER PRIMARY KEY,
  data DATE,
  tipo TEXT,
  custo REAL
);
