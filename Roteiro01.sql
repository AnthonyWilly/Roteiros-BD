--Roteiro sobre a implementação de um Banco de Dados para uma seguradora de veículos

--Questão 2
CREATE TABLE automovel(
   modelo VARCHAR(50),
   marca VARCHAR(50),
   ano DATE,
   cpf_dono CHAR(11),
   cor_primaria VARCHAR(50),
   placa CHAR(7),
   categoria VARCHAR(3)
);


CREATE TABLE segurado(
   placa CHAR(7),
   cpf CHAR(7),
   aquisicao_seguro DATE,
   nascimento DATE,
   tipo_de_seguro TEXT,
   nome TEXT
);


CREATE TABLE perito(
   nome TEXT,
   cpf CHAR(11),
   id_oficina VARCHAR(50)
);


CREATE TABLE oficina(
   id_oficina VARCHAR(50),
   localizacao VARCHAR(255)
);


CREATE TABLE seguro(
   segurado_cpf CHAR(11),
   tipo TEXT,
   data_aquisicao DATE
);


CREATE TABLE sinistro(
   placa_veiculo CHAR(7),
   tipo TEXT,
   perdas TEXT
);


CREATE TABLE pericia(
   cpf_segurado CHAR(11),
   placa_veiculo CHAR(7),
   perdas TEXT,
   seguro_cobre BOOLEAN,
   decisao BOOLEAN,
   id_oficina VARCHAR(50)
);


CREATE TABLE reparo(
   id_oficina VARCHAR(50),
   placa_veiculo CHAR(7),
   segurado_cpf CHAR(11),
   custo NUMERIC --valor de custo para a seguradora
);


--Questão 3


ALTER TABLE automovel ALTER COLUMN ano TYPE INTEGER;
ALTER TABLE segurado ALTER COLUMN cpf TYPE CHAR(11);
ALTER TABLE reparo ALTER COLUMN custo TYPE NUMERIC(10, 2);


ALTER TABLE automovel ADD PRIMARY KEY (placa);
ALTER TABLE segurado ADD PRIMARY KEY (cpf);
ALTER TABLE perito ADD PRIMARY KEY (cpf);
ALTER TABLE oficina ADD PRIMARY KEY (id_oficina);
ALTER TABLE seguro ADD PRIMARY KEY (segurado_cpf, data_aquisicao);


ALTER TABLE sinistro ADD COLUMN data_acidente DATE;
ALTER TABLE sinistro ADD PRIMARY KEY (placa_veiculo, data_acidente);


ALTER TABLE pericia ADD COLUMN data_sinistro DATE;
ALTER TABLE pericia ADD COLUMN perito_nome TEXT;
ALTER TABLE pericia ADD COLUMN data_pericia DATE;
ALTER TABLE pericia ADD PRIMARY KEY (placa_veiculo, data_pericia);


ALTER TABLE reparo ADD COLUMN data_conserto DATE;
ALTER TABLE reparo ADD PRIMARY KEY (placa_veiculo, data_conserto);


--Questão 4
ALTER TABLE segurado DROP COLUMN placa;
ALTER TABLE segurado DROP COLUMN tipo_de_seguro;
ALTER TABLE segurado DROP COLUMN aquisicao_seguro;


ALTER TABLE perito ADD COLUMN nascimento DATE;
ALTER TABLE perito ADD CONSTRAINT perito_id_oficina_fkey FOREIGN KEY (id_oficina) REFERENCES oficina (id_oficina);


ALTER TABLE seguro ADD COLUMN placa_veiculo_segurado CHAR(7);
ALTER TABLE seguro ADD CONSTRAINT seguro_segurado_cpf_fkey FOREIGN KEY (segurado_cpf) REFERENCES segurado (cpf);
ALTER TABLE seguro ADD CONSTRAINT seguro_placa_veiculo_segurado_fkey FOREIGN KEY (placa_veiculo_segurado) REFERENCES automovel (placa);


ALTER TABLE sinistro ADD CONSTRAINT sinistro_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa);


ALTER TABLE pericia ADD CONSTRAINT pericia_cpf_segurado_fkey FOREIGN KEY (cpf_segurado) REFERENCES segurado (cpf);
ALTER TABLE pericia ADD CONSTRAINT pericia_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa);
ALTER TABLE pericia ADD CONSTRAINT pericia_id_oficina_fkey FOREIGN KEY (id_oficina) REFERENCES oficina (id_oficina);


ALTER TABLE reparo ADD CONSTRAINT reparo_id_oficina_fkey FOREIGN KEY (id_oficina) REFERENCES oficina (id_oficina);
ALTER TABLE reparo ADD CONSTRAINT reparo_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa);
ALTER TABLE reparo ADD CONSTRAINT reparo_segurado_cpf_fkey FOREIGN KEY (segurado_cpf) REFERENCES segurado (cpf);


--Questão 6
DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE perito;
DROP TABLE automovel;
DROP TABLE segurado;
DROP TABLE oficina;


--Questão 7


CREATE TABLE oficina(
   id_oficina VARCHAR(50) PRIMARY KEY,
   localizacao VARCHAR(255) NOT NULL
);


CREATE TABLE segurado(
   cpf CHAR(11) PRIMARY KEY,
   nascimento DATE NOT NULL,
   nome TEXT NOT NULL
);


CREATE TABLE automovel(
   placa CHAR(7) PRIMARY KEY,
   modelo VARCHAR(50) NOT NULL,
   marca VARCHAR(50) NOT NULL,
   ano INTEGER NOT NULL,
   cpf_dono CHAR(11) NOT NULL REFERENCES segurado(cpf),
   cor_primaria VARCHAR(50),
   categoria VARCHAR(3)
);


CREATE TABLE perito(
   cpf CHAR(11) PRIMARY KEY,
   nome TEXT NOT NULL,
   nascimento DATE,
   id_oficina VARCHAR(50) NOT NULL REFERENCES oficina(id_oficina)
);


CREATE TABLE seguro(
   segurado_cpf CHAR(11) NOT NULL REFERENCES segurado(cpf),
   data_aquisicao DATE NOT NULL,
   tipo TEXT NOT NULL,
   placa_veiculo_segurado CHAR(7) NOT NULL REFERENCES automovel(placa),
   PRIMARY KEY (segurado_cpf, data_aquisicao)
);


CREATE TABLE sinistro(
   placa_veiculo CHAR(7) NOT NULL REFERENCES automovel(placa),
   data_acidente DATE NOT NULL,
   tipo TEXT NOT NULL,
   perdas TEXT,
   PRIMARY KEY (placa_veiculo, data_acidente)
);


CREATE TABLE pericia(
   placa_veiculo CHAR(7) NOT NULL REFERENCES automovel(placa),
   data_pericia DATE NOT NULL,
   cpf_segurado CHAR(11) NOT NULL REFERENCES segurado(cpf),
   data_sinistro DATE,
   perito_nome TEXT,
   perdas TEXT,
   seguro_cobre BOOLEAN,
   decisao BOOLEAN,
   id_oficina VARCHAR(50) REFERENCES oficina(id_oficina),
   PRIMARY KEY (placa_veiculo, data_pericia)
);


CREATE TABLE reparo(
   placa_veiculo CHAR(7) NOT NULL REFERENCES automovel(placa),
   data_conserto DATE NOT NULL,
   id_oficina VARCHAR(50) NOT NULL REFERENCES oficina(id_oficina),
   segurado_cpf CHAR(11) NOT NULL REFERENCES segurado(cpf),
   custo NUMERIC(10, 2) NOT NULL,
   PRIMARY KEY (placa_veiculo, data_conserto)
);


--Questão 9
DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE perito;
DROP TABLE automovel;
DROP TABLE segurado;
DROP TABLE oficina;





