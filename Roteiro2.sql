
CREATE TYPE estado AS ENUM ('MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'SE', 'BA');
CREATE TYPE cargo AS ENUM ('administrador', 'farmaceutico', 'vendedor', 'entregador', 'caixa');


CREATE TABLE farmacias(
    bairro VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    estado estado NOT NULL,
    sede BOOLEAN NOT NULL,
    PRIMARY KEY (bairro),
    CONSTRAINT bairro_cidade UNIQUE (bairro, cidade)
);


CREATE UNIQUE INDEX idx_unica_sede ON farmacias (sede) WHERE sede = TRUE;


CREATE TABLE funcionarios(
    nome VARCHAR(255) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    CHECK (LENGTH(cpf) = 11),
    cargo cargo NOT NULL,
    bairro_farmacia VARCHAR(255) NOT NULL, 
    gerencia_farmacia VARCHAR(255), 
    PRIMARY KEY (cpf),

    CONSTRAINT chk_gerente_cargo CHECK (
        (gerencia_farmacia IS NULL) OR
        (cargo IN ('administrador', 'farmaceutico'))
    )
);


ALTER TABLE funcionarios ADD CONSTRAINT fk_bairro_farmacia FOREIGN KEY (bairro_farmacia) REFERENCES farmacias (bairro);

ALTER TABLE funcionarios ADD CONSTRAINT fk_gerencia_farmacia FOREIGN KEY (gerencia_farmacia) REFERENCES farmacias (bairro);



CREATE TABLE medicamentos(
    nome VARCHAR(255),
    marca VARCHAR(255),
    receita BOOLEAN,
    id SERIAL UNIQUE,
    preco NUMERIC,
    PRIMARY KEY (id)
);


CREATE TABLE clientes(
    cpf CHAR(11) UNIQUE NOT NULL,
    CHECK (LENGTH(cpf) = 11),
    data_nascimento DATE,
    CHECK (EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) >= 18),
    endereco TEXT,
    PRIMARY KEY (cpf)
);


CREATE TABLE vendas(
    vendedor_cpf CHAR(11) NOT NULL,
    CHECK (LENGTH(vendedor_cpf) = 11),
    vendedor_cargo cargo NOT NULL,
    CHECK (vendedor_cargo = 'vendedor'),
    cliente_cpf CHAR(11),
    CHECK (LENGTH(cliente_cpf) = 11 OR cliente_cpf IS NULL),
    id_medicamento INT NOT NULL,
    venda_exclusiva BOOLEAN,
    id_venda SERIAL UNIQUE,
    PRIMARY KEY (id_venda),
    CONSTRAINT chk_receita_cliente_cadastrado CHECK (NOT (venda_exclusiva IS TRUE AND cliente_cpf IS NULL)),
    CONSTRAINT vendedor_cargo_fk FOREIGN KEY (vendedor_cpf, vendedor_cargo) REFERENCES funcionarios (cpf, cargo) ON DELETE RESTRICT
);

ALTER TABLE vendas ADD CONSTRAINT vendas_id_medicamento_fkey FOREIGN KEY (id_medicamento) REFERENCES medicamentos (id) ON DELETE RESTRICT;
ALTER TABLE vendas ADD CONSTRAINT vendas_cliente_cpf_fkey FOREIGN KEY (cliente_cpf) REFERENCES clientes (cpf);


CREATE TABLE entregas(
    cliente_cpf CHAR(11) NOT NULL,
    CHECK (LENGTH(cliente_cpf) = 11),
    id_venda INT NOT NULL,
    PRIMARY KEY (cliente_cpf, id_venda),
    id_entrega SERIAL UNIQUE
);

ALTER TABLE entregas ADD CONSTRAINT entregas_id_venda_fkey FOREIGN KEY (id_venda) REFERENCES vendas (id_venda);
ALTER TABLE entregas ADD CONSTRAINT entregas_cliente_cpf_fkey FOREIGN KEY (cliente_cpf) REFERENCES clientes (cpf);

INSERT INTO farmacias (bairro, cidade, estado, sede) VALUES
('Centro', 'Campina Grande', 'PB', TRUE),
('Bodocongó', 'Campina Grande', 'PB', FALSE),
('Catolé', 'Campina Grande', 'PB', FALSE),
('Tambia', 'João Pessoa', 'PB', TRUE),
('Bessa', 'João Pessoa', 'PB', FALSE);

INSERT INTO funcionarios (nome, cpf, cargo, bairro_farmacia, gerencia_farmacia) VALUES
('Carlos Mendes', '11122233344', 'administrador', 'Centro', 'Centro'),
('Mariana Lima', '22233344455', 'farmaceutico', 'Bodocongó', 'Bodocongó'),
('Rafael Costa', '33344455566', 'vendedor', 'Centro', NULL),
('Paula Ramos', '44455566677', 'caixa', 'Catolé', NULL),
('Fernando Dantas', '55566677788', 'entregador', 'Bodocongó', NULL),
('Lucas Oliveira', '77788899900', 'farmaceutico', 'Catolé', NULL);

INSERT INTO medicamentos (nome, marca, receita, preco) VALUES
('Amoxicilina', 'Genérico', TRUE, 15.50),
('Paracetamol', 'Neosaldina', FALSE, 8.25),
('Dipirona', 'Novalgina', FALSE, 12.00),
('Sinvastatina', 'Medley', TRUE, 30.75),
('Omeprazol', 'Aché', FALSE, 22.90);

INSERT INTO clientes (cpf, data_nascimento, endereco) VALUES
('00011122233', '1985-03-10', 'Rua das Flores, 123, Centro, Campina Grande-PB'),
('99988877766', '1992-07-25', 'Avenida Principal, 45, Catolé, Campina Grande-PB'),
('12345678900', '1970-11-01', 'Travessa da Paz, 78, Bodocongó, Campina Grande-PB');

INSERT INTO vendas (vendedor_cpf, vendedor_cargo, cliente_cpf, id_medicamento, venda_exclusiva) VALUES
('33344455566', 'vendedor', '00011122233', 1, TRUE),
('33344455566', 'vendedor', '99988877766', 2, FALSE),
('33344455566', 'vendedor', NULL, 3, FALSE),
('33344455566', 'vendedor', '12345678900', 4, TRUE);

INSERT INTO entregas (cliente_cpf, id_venda) VALUES
('00011122233', 1),
('99988877766', 2),
('12345678900', 4);
