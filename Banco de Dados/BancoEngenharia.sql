create database engenharia;

use engenharia;
CREATE TABLE Cliente (
    Cod_Cliente INTEGER PRIMARY KEY,
    Nome VARCHAR(120),
    Email VARCHAR(120),
    Tipo_Cliente CHAR
);

CREATE TABLE Projeto (
    Cod_P INTEGER PRIMARY KEY,
    Localizacao VARCHAR(80),
    Orçamento DOUBLE,
    Descrição VARCHAR(120),
    fk_Cliente_Cod_Cliente INTEGER,
    Nome_Projeto VARCHAR(80),
    DataInicio DATE,
    Prazo DATE,
    fk_Consultor_Cod_cod_Consultor INTEGER
);

CREATE TABLE Equipe (
    Cod_Eq INTEGER PRIMARY KEY,
    Numero_Participantes INTEGER,
    Nome_Equipe VARCHAR(70)
);

CREATE TABLE Consultor (
    cod_Consultor INTEGER PRIMARY KEY,
    Nome VARCHAR(120),
    CNPJ VARCHAR(18),
    Comissão DOUBLE
);

CREATE TABLE Funcionario (
    Cod_F INTEGER PRIMARY KEY,
    Nome VARCHAR(120),
    Cargo VARCHAR(25),
    CPF VARCHAR(14),
    Salario DOUBLE,
    DataNasc DATE
);

CREATE TABLE Tipo (
    Cod_Tipo INTEGER PRIMARY KEY,
    Nome VARCHAR(120),
    Descricao VARCHAR(120)
);

CREATE TABLE Pessoa_Juridica (
    CNPJ VARCHAR(18),
    Razao_Social VARCHAR(120),
    Cod_cliente INTEGER
);

CREATE TABLE Pessoa_Fisica (
    Cod_Cliente INTEGER,
    CPF VARCHAR(14),
    DataNasc DATE
);

CREATE TABLE Funcionario_Equipe (
    fk_Funcionario_Cod_F INTEGER,
    fk_Equipe_Cod_F INTEGER
);

CREATE TABLE Tipo_Projeto (
    fk_Tipo_Cod_Tipo INTEGER,
    fk_Projeto_Cod_P INTEGER
);

CREATE TABLE EnderecoFuncionario (
    Cod_F INTEGER,
    Rua VARCHAR(100),
    Bairro VARCHAR(40),
    CEP VARCHAR(10),
    Numero VARCHAR(5),
    Referencia VARCHAR(60),
    Cidade VARCHAR(70),
    Estado VARCHAR(50),
    Pais VARCHAR(30),
    Cod_En INTEGER PRIMARY KEY
);

CREATE TABLE TelefoneFuncionario (
    Cod_F INTEGER,
    Telefone VARCHAR(12),
    Cod_T INTEGER PRIMARY KEY
);

CREATE TABLE EnderecoCliente (
    Cod_C INTEGER,
    Rua VARCHAR(100),
    Bairro VARCHAR(40),
    CEP VARCHAR(10),
    Numero VARCHAR(5),
    Referencia VARCHAR(60),
    Cidade VARCHAR(70),
    Estado VARCHAR(50),
    Pais VARCHAR(30),
    Cod_En INTEGER PRIMARY KEY
);

CREATE TABLE TabelaCliente (
    Cod_C INTEGER,
    Telefone VARCHAR(12),
    Cod_T INTEGER PRIMARY KEY
);
 
ALTER TABLE Projeto ADD CONSTRAINT FK_Projeto_2
    FOREIGN KEY (fk_Cliente_Cod_Cliente)
    REFERENCES Cliente (Cod_Cliente)
    ON DELETE CASCADE;
 
ALTER TABLE Projeto ADD CONSTRAINT FK_Projeto_3
    FOREIGN KEY (fk_Consultor_Cod_cod_Consultor)
    REFERENCES Consultor (cod_Consultor);
 
ALTER TABLE Pessoa_Juridica ADD CONSTRAINT FK_Pessoa_Juridica_1
    FOREIGN KEY (Cod_cliente)
    REFERENCES Cliente (Cod_Cliente);
 
ALTER TABLE Pessoa_Fisica ADD CONSTRAINT FK_Pessoa_Fisica_1
    FOREIGN KEY (Cod_Cliente)
    REFERENCES Cliente (Cod_Cliente);
 
ALTER TABLE Funcionario_Equipe ADD CONSTRAINT FK_Funcionario_Equipe_1
    FOREIGN KEY (fk_Funcionario_Cod_F)
    REFERENCES Funcionario (Cod_F)
    ON DELETE RESTRICT;
 
ALTER TABLE Funcionario_Equipe ADD CONSTRAINT FK_Funcionario_Equipe_2
    FOREIGN KEY (fk_Equipe_Cod_F)
    REFERENCES Equipe (Cod_Eq);
 
ALTER TABLE Tipo_Projeto ADD CONSTRAINT FK_Tipo_Projeto_1
    FOREIGN KEY (fk_Tipo_Cod_Tipo)
    REFERENCES Tipo (Cod_Tipo)
    ON DELETE RESTRICT;
 
ALTER TABLE Tipo_Projeto ADD CONSTRAINT FK_Tipo_Projeto_2
    FOREIGN KEY (fk_Projeto_Cod_P)
    REFERENCES Projeto (Cod_P)
    ON DELETE CASCADE;
 
ALTER TABLE EnderecoFuncionario ADD CONSTRAINT FK_EnderecoFuncionario_1
    FOREIGN KEY (Cod_F)
    REFERENCES Funcionario (Cod_F);
 
ALTER TABLE TelefoneFuncionario ADD CONSTRAINT FK_TelefoneFuncionario_1
    FOREIGN KEY (Cod_F)
    REFERENCES Funcionario (Cod_F);
 
ALTER TABLE EnderecoCliente ADD CONSTRAINT FK_EnderecoCliente_1
    FOREIGN KEY (Cod_C)
    REFERENCES Cliente (Cod_Cliente);
 
ALTER TABLE TabelaCliente ADD CONSTRAINT FK_TabelaCliente_1
    FOREIGN KEY (Cod_C)
    REFERENCES Cliente (Cod_Cliente);
    
describe Cliente;
describe Projeto;
describe Equipe;
describe Consultor;
describe Funcionario;
describe Tipo;
describe Pessoa_Juridica;
describe Pessoa_Fisica;
describe Funcionario_Equipe;
describe Tipo_Projeto;
describe EnderecoFuncionario;
describe TelefoneFuncionario;
describe EnderecoCliente;
describe TabelaCliente;
ALTER TABLE EnderecoCliente
CHANGE Cod_End Cod_C INTEGER;
