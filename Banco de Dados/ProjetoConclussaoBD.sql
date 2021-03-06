create database engenharia;

use engenharia;
CREATE TABLE Cliente (
    Cod_Cliente INTEGER PRIMARY KEY not null auto_increment,
    Nome VARCHAR(120) not null,
    Email VARCHAR(120) not null,
    Tipo_Cliente enum('PF','PJ') not null
);

CREATE TABLE Projeto (
    Cod_P INTEGER PRIMARY KEY not null auto_increment,
    Localizacao VARCHAR(80) not null,
    Orcamento DOUBLE not null,
    Descricao VARCHAR(120),
    fk_Cliente_Cod_Cliente INTEGER not null,
    Nome_Projeto VARCHAR(80) not null,
    DataInicio DATE not null,
    Prazo DATE not null,
    fk_Consultor_Cod INTEGER not null
);

CREATE TABLE Equipe (
    Cod_Eq INTEGER PRIMARY KEY not null auto_increment,
    Numero_Participantes INTEGER not null,
    Nome_Equipe VARCHAR(70) not null
);

CREATE TABLE Consultor (
    cod_Consultor INTEGER PRIMARY KEY not null auto_increment,
    Nome VARCHAR(120) not null,
    CNPJ VARCHAR(18) not null,
    Comissao DOUBLE not null default 0
);

CREATE TABLE Funcionario (
    Cod_F INTEGER PRIMARY KEY not null auto_increment,
    Nome VARCHAR(120) not null,
    Cargo VARCHAR(25) not null,
    CPF VARCHAR(14) not null,
    Salario DOUBLE not null,
    DataNasc DATE not null
);

CREATE TABLE Tipo (
    Cod_Tipo INTEGER PRIMARY KEY not null auto_increment,
    Nome VARCHAR(120) not null,
    Descricao VARCHAR(120) not null
);

CREATE TABLE Pessoa_Juridica (
    CNPJ VARCHAR(18),
    Razao_Social VARCHAR(120) ,
    Cod_cliente INTEGER  
);

CREATE TABLE Pessoa_Fisica (
    Cod_Cliente INTEGER not null ,
    CPF VARCHAR(14) ,
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
    Cod_F INTEGER not null ,
    Rua VARCHAR(100) not null,
    Bairro VARCHAR(40)not null,
    CEP VARCHAR(10)not null,
    Numero VARCHAR(5)not null,
    Referencia VARCHAR(60)not null,
    Cidade VARCHAR(70)not null,
    Estado VARCHAR(50)not null,
    Pais VARCHAR(30)not null,
    Cod_En INTEGER PRIMARY KEY not null auto_increment
);

CREATE TABLE TelefoneFuncionario (
    Cod_F INTEGER not null,
    Telefone VARCHAR(12) not null,
    Cod_T INTEGER PRIMARY KEY auto_increment not null
);

CREATE TABLE EnderecoCliente (
    Cod_C INTEGER not null,
    Rua VARCHAR(100) not null,
    Bairro VARCHAR(40) not null,
    CEP VARCHAR(10) not null,
    Numero VARCHAR(5) not null,
    Referencia VARCHAR(60) not null,
    Cidade VARCHAR(70) not null,
    Estado VARCHAR(50) not null,
    Pais VARCHAR(30) not null,
    Cod_En INTEGER PRIMARY KEY not null auto_increment
);

CREATE TABLE ClienteTelefone (
    Cod_C INTEGER not null,
    Telefone VARCHAR(12) not null,
    Cod_T INTEGER PRIMARY KEY not null auto_increment
);
CREATE TABLE Historico_de_Comissao (
    FK_Consultor INTEGER,
    Comissao DOUBLE,
    Cod_hist INTEGER PRIMARY KEY auto_increment
);
ALTER TABLE Projeto ADD CONSTRAINT FK_Projeto_2
    FOREIGN KEY (fk_Cliente_Cod_Cliente)
    REFERENCES Cliente (Cod_Cliente)
    ON DELETE CASCADE;
 
 
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
 
ALTER TABLE ClienteTelefone ADD CONSTRAINT FK_ClienteTelefone_1
    FOREIGN KEY (Cod_C)
    REFERENCES Cliente (Cod_Cliente);
    
ALTER TABLE Historico_de_Comissao ADD CONSTRAINT FK_Historico_de_Comissao_1
    FOREIGN KEY (FK_Consultor)
    REFERENCES Consultor (cod_Consultor);
    
ALTER TABLE Projeto ADD CONSTRAINT FK_Projeto_3
    FOREIGN KEY (fk_Consultor_Cod)
    REFERENCES Consultor (cod_Consultor);

    
    delimiter $
create trigger op_cliente after insert 
on Cliente
for each row
begin
	if(new.Tipo_Cliente = 'PJ')
	then 
		insert into Pessoa_Juridica(Cod_cliente) values(new.cod_Cliente);
        
	else
		insert into Pessoa_Fisica(Cod_cliente) values(new.cod_Cliente);
	end if;
end $
delimiter ;

delimiter $
create trigger tr_comicao_consultor after insert
on Projeto
for each row
begin
	update consultor 
    set comissao = comissao + (new.orcamento * 0.03) 
    where new.fk_Consultor_Cod = consultor.cod_Consultor;
end $
delimiter ; 

delimiter $
create trigger tr_comicao_Historico before insert
on Projeto
for each row
begin
    insert into Historico_de_Comissao values(new.fk_Consultor_Cod,new.orcamento * 0.03,default);
    
end $
delimiter ; 
/*
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
describe ClienteTelefone;
describe Historico_de_Comissao;

#select* from Cliente;
#select* from Pessoa_Fisica;
#insert into Cliente values(default,'Douglas','douglas@gmail.com','PF'); 
*/