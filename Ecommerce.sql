-- new database ecommerce --

create database ecommerce;
use ecommerce;

-- criar tabelas cliente

create table Clients(
	idClient int auto_increment primary key,
    clientType enum('PJ', 'PF')not null,
    Fname varchar(20),
    Minit char(3),
    Lname varchar(20),
    CNPJ char(14),
    CPF char(11),
    Address varchar(50),  
    constraint unique_cpf_client unique(CPF),
	constraint check_client_type check (
		(clientType = 'PJ' AND Fname IS NOT NULL AND cnpj IS NOT NULL AND CPF IS NULL) OR
		(clientType = 'PF' AND Fname IS NULL AND cnpj IS NULL  AND CPF IS NOT NULL))
);


desc clients;

create table product(
	idProduct int auto_increment primary key,
    FPname varchar(40),
    Classification_kids bool,
    category enum('Eletrônico', 'Vestimenta','Brinquedos','Alimentos','Movéis'),	
    avaliação float,
    size varchar(10)
);

-- terminar a tabela e fazer conexão necessárias --
create table payments(
	idClient int,
    idPayment int,
    typePayment enum ('Boleto','Cartão','Pix','Dois Cartões') not null,
    limitAvailable float,
    primary key (idClient, idPayment)
);
create table orders(
	idOrders int auto_increment primary key,
    idOrderClient int,
    trackingCode varchar(60),
    orderStatus enum('Cancelado','Confirmado','Em Processamento') default 'Em Processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false,
    constraint fk_orders_client foreign key (idOrderClient) references Clients(idClient)
		on update cascade
);

desc orders;

create table productStorage(
	idProdStorage int auto_increment primary key,
	storageLocation varchar(45) not null,
    quantity int default 0
);

create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) default 0,
	constraint unique_suppiler unique(CNPJ)
);

desc supplier;

create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbsName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(100),
    contact char(11) default 0,
	constraint unique_CNPJ_seller unique(CNPJ),
	constraint unique_CPF_seller unique(CPF)
);


create table productInOrder(
	idProd_Order int,
    idOrder_Prod int,
    prodQuantity int not null default 1,
    prod_ordStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key(IdProd_Order, idOrder_Prod),
    constraint fk_product_order foreign key (idProd_Order) references product(idProduct),
    constraint fk_order_product foreign key (idOrder_Prod) references orders(idOrders)
);

create table storageLocation(
	idProduct_Loc int,
    idStorage_Loc int,
    location varchar(255),
    primary key(IdStorage_Loc, idProduct_Loc),
	constraint fk_product_storage_product foreign key (idProduct_Loc) references product(idProduct),
    constraint fk_product_location_storage foreign key (idStorage_Loc) references productStorage(idProdStorage)
);

create table productSeller(
	idProd_Seller int,
    idProduct int,
    prodQuantity int not null default 1,
    primary key(IdProd_Seller, idProduct),
    constraint fk_product_seller foreign key (idProd_Seller) references seller(IdSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

desc productSeller;

create table product_Supplier(
	idProd_Supplier int,
    idProduct int,
    quantity int not null default 1,
    primary key(IdProd_Supplier, idProduct),
    constraint fk_product_suppiler foreign key (idProd_Supplier) references supplier(IdSupplier),
    constraint fk_supplier_product foreign key (idProduct) references product(idProduct)
);

show tables;

-- Inserindo dados na tabela Clients
INSERT INTO Clients (clientType, Fname, Minit, Lname, CNPJ, CPF, Address)
VALUES 
-- Cliente PF
('PF', NULL, NULL, 'Doe', NULL, '12345678901', '123 Main Street'),
('PF', NULL, NULL, 'Smith', NULL, '98765432109', '456 Park Avenue'),
('PF', NULL, NULL, 'Johnson', NULL, '55555555555', '789 Elm Street'),
-- Cliente PJ
('PJ', 'Empresa ABC', NULL, 'LTDA', '11222333445566', NULL, '123 Sunset Boulevard'),
('PJ', 'Empresa XYZ', NULL, 'ME', '66778899001122', NULL, '456 Moonlight Street');


-- Inserindo dados na tabela Product
INSERT INTO Product (FPname, Classification_kids, category)
VALUES 
('Smartwatch', FALSE, 'Eletrônico'),
('RC Car', TRUE, 'Brinquedos'),
('Gaming Console', FALSE, 'Eletrônico'),
('Building Blocks', TRUE, 'Brinquedos');

INSERT INTO Orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
VALUES
(1, 'Confirmado', 'Compra de Smartwatch', 15.00, true),
(2, 'Em Processamento', 'Compra de Gaming Console', 20.00, false),
(3, 'Cancelado', 'Compra de RC Car', 10.00, false),
(4, 'Confirmado', 'Compra de Building Blocks', 25.00, true),
(5, 'Em Processamento', 'Compra de vários itens', 30.00, false);

SELECT * FROM Clients;
SELECT FPname, category 
	FROM Product
	WHERE category = 'Eletrônico';
    
SELECT idOrders, 
		orderDescription, 
		sendValue + 5 AS TotalWithTax
	FROM Orders;
    
SELECT idOrders, orderStatus, orderDescription
FROM Orders
ORDER BY orderStatus ASC, orderDescription ASC;

SELECT orderStatus, COUNT(*) AS StatusCount
FROM Orders
GROUP BY orderStatus
HAVING StatusCount > 1;

SELECT Clients.Fname, Clients.Lname, Orders.orderDescription, Orders.orderStatus
FROM Clients
JOIN Orders ON Clients.idClient = Orders.idOrderClient;

-- drop database ecommerce;