-- criação do banco de dados para o cenário de e-commerce

-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(15),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(50),
    Bdate date,
    constraint unique_cpf_client unique (CPF)
);
alter table clients auto_increment = 1;

-- criar tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(100),
    Classification_kids bool,
    Category enum('Eletrônicos', 'Vestuários', 'Brinquedos', 'Alimentos', 'Móveis','Livros') not null,
    Avaluation decimal(3,2) default 0,
    Size varchar(20)
);

-- criar tabela pagamentos
create table payments(
	idClient int,
    idPayment int,
    typePayment enum('Boleto', 'Cartão Débito', 'Cartão Crédito'),
    limitAvailable decimal(10,2),
    primary key(idClient, idPayment),
    constraint fk_payment_client foreign key (idClient) references clients(idClient)
);

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int null,
    orderStatus enum('Cancelado', 'Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
	sendValue decimal(10,2) default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade
        on delete set null
);

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0    
);

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(14) not null,
    contact char(15) not null,
    constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(14),
    CPF char(11),
    location varchar(255),
    contact char(15) not null,
    constraint unique_CNPJ_seller unique (CNPJ),
    constraint unique_CPF_seller unique(CPF)
);

-- criar tabela produto/vendedor
create table productSeller(
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

-- criar tabela produto/fornecedor
create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    Quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

-- criar tabela produto/pedido
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)
);

-- criar tabela localizações de estoque
create table storageLocation (
	idLproduct int,
    idLstorage int,
    location char(2),
    primary key (idLproduct, idLstorage),
    constraint fk_storage_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- ==============================
-- Inserts de teste
-- ==============================

insert into clients (Fname, Minit, Lname, CPF, Address) 
values ('Maria', 'M', 'Silva', '78945612300', 'rua 1, 20, Jesus das flores - cidade de deus'),
	   ('João', 'J', 'José', '12345678900', 'rua 2, 30, Jesus da cruz - cidade do vaticano'),
       ('Tadeu','T', 'Doido', '45678912300', 'rua 3, 40, Jesus do nascimento - cidade de roma');

insert into product (Pname, Classification_kids, Category, Avaluation, Size) values
	('Fone', false, 'Eletrônicos', 4, null),
    ('Barbie', true, 'Brinquedos', 3, null),
    ('Livro', true, 'Livros', 5, null),
    ('Câmera', false, 'Eletrônicos', 1, null),
    ('Sofá', false, 'Móveis', 3, '3x57x80');

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
	(1, default, 'compra via aplicativo', null, 1),
    (2, default, 'compra via aplicativo', 50, 0),
    (3, 'Confirmado', null, null, 1);

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
	(1, 1, 2, null),
    (2, 1, 1, null),
    (3, 2, 1, null);

insert into productStorage (storageLocation, quantity) values
	('Rio', 100),
    ('Rio', 500),
    ('São Paulo', 10),
    ('São Paulo', 20),
    ('Brasília', 30);

insert into storageLocation (idLproduct, idLstorage, location) values
	(1, 2, 'RJ'),
    (2, 3, 'SP');

insert into supplier (SocialName, CNPJ, contact) values
	('Almeida', '12345678912345', '789456123'),
    ('Jesus na cruz', '32165498732100', '789123456'),
    ('Jonas do Eletrônico','12378945600012', '654987321');

insert into productSupplier (idPsSupplier, idPsProduct, Quantity) values
	(1, 1, 500),
    (1, 2, 400),
    (2, 3, 200);

insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
	('Tech', null, '12345678912345', null, 'Rio', '456789123'),
    ('Tokio', null, null, '45678912300', 'Rio', '654987321'),
    ('Senegal', null, '45678912345678', null, 'São Paulo', '01136598');

insert into productSeller (idPseller, idProduct, prodQuantity) values
	(1, 1, 80),
    (2, 2, 10);
