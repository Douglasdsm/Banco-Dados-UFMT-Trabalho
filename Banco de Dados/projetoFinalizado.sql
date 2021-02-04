#drop database engenharia;
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
    ON DELETE CASCADE
    
    ;
  
  
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

alter table equipe alter numero_participantes set default 0;
     
delimiter $
create trigger op_cliente after insert
on Cliente
for each row
begin
    if(new.Tipo_Cliente = 'PJ')
    then
        insert into Pessoa_Juridica values('00.000.000/0000-0','Default',new.cod_Cliente);
         
    else
        insert into Pessoa_Fisica values(new.cod_Cliente,'000.000.000-00',curdate());
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
    insert into Historico_de_Comissao values(new.fk_Consultor_Cod,new.orcamento * 0.03,new.cod_p);
     
end $
delimiter ;

delimiter $
create trigger atualizacao_projeto before update
on projeto
for each row
begin
	if(old.orcamento <> new.orcamento) then
        update historico_de_comissao set comissao = new.orcamento*0.03 where  cod_hist = new.cod_p;
	end if;
    if(old.fk_consultor_cod <> new.fk_consultor_cod) then
		delete from historico_de_comissao where cod_hist = new.cod_p;
		insert into historico_de_comissao values(new.fk_consultor_cod,new.orcamento*0.03,new.cod_p);
	end if;
end $
delimiter ;

delimiter $
create trigger atualizacao_consultor_comissao before update
on Historico_de_comissao
for each row
begin
	if(old.comissao <> new.comissao) then
		update consultor set comissao = consultor.comissao - old.comissao + new.comissao where cod_consultor = new.fk_consultor;
	end if;
end $
delimiter ;

delimiter $
create trigger exclucao_orcamento before delete
on projeto
for each row
begin 
	
	delete from historico_de_comissao where old.cod_p = cod_hist;
    
end $
delimiter ;

delimiter $
create trigger exclucao_historico before delete
on historico_de_comissao
for each row
begin 
	update consultor set comissao = comissao - old.comissao where old.fk_consultor = cod_consultor;
end $
delimiter ;

delimiter $
create trigger atualizacao_comicao_historico after insert
on historico_de_comissao
for each row
begin 
	update consultor set comissao = comissao + new.comissao where new.fk_consultor = cod_consultor;
end $
delimiter ;

delimiter $
create trigger entegrantes_equipe after insert
on funcionario_equipe
for each row
begin
    update equipe set numero_participantes = numero_participantes + 1 where cod_eq = new.fk_equipe_cod_f;
end $
delimiter ;

delimiter $
create trigger delete_entegrantes_equipe before delete
on funcionario_equipe
for each row
begin
    update equipe set numero_participantes = numero_participantes - 1 where cod_eq = old.fk_equipe_cod_f;
end $
delimiter ;

delimiter $
create trigger updade_entegrantes_equipe before update
on funcionario_equipe
for each row
begin
	update equipe set numero_participantes = numero_participantes + 1 where cod_eq = new.fk_equipe_cod_f;
    update equipe set numero_participantes = numero_participantes - 1 where cod_eq = old.fk_equipe_cod_f;
end $
delimiter ;



#selects
select * from historico_de_comissao;
select * from consultor;
select * from projeto ;
select*from cliente;
select * from equipe;
select * from funcionario_equipe;
#delets
delete from projeto where cod_p = 3;
delete from funcionario_equipe where fk_funcionario_cod_f = 1 and fk_equipe_cod_f = 1 ;
delete from funcionario_equipe where fk_equipe_cod_f =1;

#inserts
#funcionario
insert into funcionario values(1,'Felipe Dilon Aurora','engenheiro de computação','987.654.321-21','5000.00','1997-09-17');
insert into funcionario values(2,'Roberto Carlos','engenheiro de Produção','123.456.789.10','5000.00','1998-09-17');
insert into funcionario values(3,'Carlos Alberto de Nobrega','engenheiro de Pesca','865.128.545.99','5000.00','1996-09-17');
#enderecofuncionario
insert into  enderecofuncionario values(1,'Jorge Teixeira','Boa Esperança','558955',24,'CASA','Ji-Paraná','Rondônia','Brasil',1);
insert into  enderecofuncionario values(2,'Rua Dom Paquim','CPA','558955',24,'APART','Cuiabá','Mato Grosso','Brasil',2);
insert into  enderecofuncionario values(3,'Rua da Crisma','Vila Nova','558955',69,'KitNer','Ji-Paraná','Rondônia','Brasil',3);
#telefonefuncionario
insert into  telefonefuncionario values(1,'(12)5551515',1);
insert into  telefonefuncionario values(2,'(15)2158215',2);
insert into  telefonefuncionario values(3,'(69)5551515',3);
#equipe
insert into equipe values(1,default,'Juntos Somos Mais');
insert into equipe values(2,default,'sempre em frente');
#funcionario_equipe
insert into funcionario_equipe values(1,1);
insert into funcionario_equipe values(1,2);
insert into funcionario_equipe values(2,2);
#tipo
insert into tipo values(1,'Asfaltamento','Aplicação de uma camaeda de piche sobre o chão');
insert into tipo values(2,'nivelamento','Planificação do chão');
#cliente
insert into cliente values(1,'Esmael Fonseca','umdemocratacristao@gmail.com','PF');
insert into cliente values(2,'Neymar Junior','nagila@gmail.com','PJ');
insert into cliente values(3,'Ronaldo Nazario','trans@gmail.com','PF');
#clienteTelefone
insert into clienteTelefone values(1,'(69)515155151',1);
insert into clienteTelefone values(2,'(55)515155151',2);
insert into clienteTelefone values(3,'(11)515155151',3);

#endereco
insert into  enderecocliente values(1,'Jorge Teixeira','Boa Esperança','558955',24,'CASA','Ji-Paraná','Rondônia','Brasil',1);
insert into  enderecocliente values(2,'Rua Dom Paquim','CPA','558955',24,'APART','Cuiabá','Mato Grosso','Brasil',2);
insert into  enderecocliente values(3,'Rua da Crisma','Vila Nova','558955',69,'KitNer','Ji-Paraná','Rondônia','Brasil',3);
#consultor
insert into consultor values(1,'Michael Nunes','25.555.555./555',default);
insert into consultor values(2,'Doug Martins','24.242.224./242',default);
insert into consultor values(3,'Luiz Inacio Lula da Silva','11.11.111./111',default);

#projeto
insert into projeto values(1,'rua 9',1500000.00,'Terraplanagem',1,'bora arruma essa rua',curdate(),'2019-12-12',1);
insert into projeto values(2,'rua 47',800000.00,'Constução da Igreja Matriz',1,'simbora',curdate(),'2019-12-12',1);
insert into projeto values(3,'rua 69',3158000.00,'Correção de dutos',1,'Agora vai',curdate(),'2019-12-12',1);
#tipoprojeto
insert into tipo_projeto values(1,1);
insert into tipo_projeto values(2,2);
insert into tipo_projeto values(2,3);


/*
select*from tipo_projeto;
insert into projeto values(5,'rua 9',500.00,'salva',1,'aqauele',curdate(),'2019-12-12',2);
insert into consultor values(3,'bolsonaro2018','1234572',default);
insert into consultor values(default,'Marcelinho','12345678',default);
insert into projeto values(1,'rua 9',1000.00,'salva',1,'aqauele',curdate(),'2019-12-12',1);
insert into Cliente values(default,'Douglas','douglas@gmail.com','PF'); 
insert into equipe values(2,0,'sempre em frente');
insert into funcionario values(3,'marcos','engenheiro de computação','033.154.482-21','5000.00','1997-09-17');
insert into funcionario_equipe values(3,2);
insert into equipe values(1,0,'Juntos Somos Mais');


##updates
update projeto set fk_consultor_cod = 3 where cod_p = 2 and fk_cliente_cod_cliente = 1; 
update projeto set orcamento = 500.00 where cod_p =1;
update funcionario_equipe set fk_equipe_cod_f=1 where fk_funcionario_cod_f =3;




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
#select* from Pessoa_Fisica;*/
