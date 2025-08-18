-- criação da database
create database oficina_mecanica;
use oficina_mecanica;

-- tabela Cliente
create table Cliente (
    idCliente int auto_increment primary key,
    Nome varchar(45) not null,
    Telefone varchar(45),
    Endereco varchar(100)
);

-- tabela Veículo
create table Veiculo (
    Placa varchar(10) primary key,
    Modelo varchar(45),
    Marca varchar(45),
    Ano int,
    Cliente_idCliente int,
    foreign key (Cliente_idCliente) references Cliente(idCliente)
);

-- tabela Equipe Mecânicos
create table Equipe_Mecanicos (
    idEquipe int auto_increment primary key
);

-- tabela Mecânico
create table Mecanico (
    idMecanico int auto_increment primary key,
    Nome varchar(45),
    Endereco varchar(100),
    Especialidade varchar(45),
    Equipe_Mecanicos_idEquipe int,
    foreign key (Equipe_Mecanicos_idEquipe) references Equipe_Mecanicos(idEquipe)
);

-- tabela Ordem de Serviço
create table Ordem_Servico (
    Num_OS int auto_increment primary key,
    Data_emissao date,
    Data_conclusao date,
    Valor_total decimal(10,2),
    Status varchar(45),
    Veiculo_Placa varchar(10),
    Equipe_Mecanicos_idEquipe int,
    foreign key (Veiculo_Placa) references Veiculo(Placa),
    foreign key (Equipe_Mecanicos_idEquipe) references Equipe_Mecanicos(idEquipe)
);

-- tabela Peça
create table Peca (
    idPeca int auto_increment primary key,
    Descricao varchar(100),
    Valor decimal(10,2)
);

-- tabela Serviço
create table Servico (
    idServico int auto_increment primary key,
    Descricao varchar(100),
    Valor_mao_obra decimal(10,2)
);

-- tabela Item_Peca (N:N entre Ordem de Serviço e Peça)
create table Item_Peca (
    Ordem_Servico_Num_OS int,
    Peca_idPeca int,
    Quantidade int,
    Subtotal decimal(10,2),
    primary key (Ordem_Servico_Num_OS, Peca_idPeca),
    foreign key (Ordem_Servico_Num_OS) references Ordem_Servico(Num_OS),
    foreign key (Peca_idPeca) references Peca(idPeca)
);

-- tabela Item_Servico (N:N entre Ordem de Serviço e Serviço)
create table Item_Servico (
    Ordem_Servico_Num_OS int,
    Servico_idServico int,
    Valor decimal(10,2),
    Subtotal decimal(10,2),
    primary key (Ordem_Servico_Num_OS, Servico_idServico),
    foreign key (Ordem_Servico_Num_OS) references Ordem_Servico(Num_OS),
    foreign key (Servico_idServico) references Servico(idServico)
);

-- clientes
insert into Cliente (Nome, Telefone, Endereco) values
('João Silva', '11999998888', 'Rua A, 123'),
('Maria Souza', '21988887777', 'Rua B, 456');

-- veículos
insert into Veiculo (Placa, Modelo, Marca, Ano, Cliente_idCliente) values
('ABC1234', 'Civic', 'Honda', 2018, 1),
('XYZ9876', 'Corolla', 'Toyota', 2020, 2);

-- equipes
insert into Equipe_Mecanicos values (1), (2);

-- mecânicos
insert into Mecanico (Nome, Endereco, Especialidade, Equipe_Mecanicos_idEquipe) values
('Carlos Mec', 'Rua das Oficinas, 10', 'Motor', 1),
('Ana Tec', 'Rua das Oficinas, 20', 'Elétrica', 1),
('Pedro Fun', 'Rua das Oficinas, 30', 'Funilaria', 2);

-- peças
insert into Peca (Descricao, Valor) values
('Filtro de óleo', 50.00),
('Pneu aro 16', 400.00),
('Bateria 60Ah', 350.00);

-- serviços
insert into Servico (Descricao, Valor_mao_obra) values
('Troca de óleo', 120.00),
('Alinhamento', 150.00),
('Revisão elétrica', 200.00);

-- ordem de serviço
insert into Ordem_Servico (Data_emissao, Data_conclusao, Valor_total, Status, Veiculo_Placa, Equipe_Mecanicos_idEquipe) values
('2025-08-01', '2025-08-02', 520.00, 'Concluída', 'ABC1234', 1),
('2025-08-10', null, null, 'Em andamento', 'XYZ9876', 2);

-- item_peça
insert into Item_Peca (Ordem_Servico_Num_OS, Peca_idPeca, Quantidade, Subtotal) values
(1, 1, 1, 50.00),
(1, 2, 1, 400.00);

-- item_serviço
insert into Item_Servico (Ordem_Servico_Num_OS, Servico_idServico, Valor, Subtotal) values
(1, 1, 120.00, 120.00),
(2, 3, 200.00, 200.00);

-- Listar ordens de serviço com cliente e veículo
select os.Num_OS, c.Nome as Cliente, v.Modelo, v.Marca, os.Status, os.Valor_total
from Ordem_Servico os
join Veiculo v on os.Veiculo_Placa = v.Placa
join Cliente c on v.Cliente_idCliente = c.idCliente;

-- Listar peças usadas em cada ordem de serviço
select os.Num_OS, p.Descricao, ip.Quantidade, ip.Subtotal
from Item_Peca ip
join Peca p on ip.Peca_idPeca = p.idPeca
join Ordem_Servico os on ip.Ordem_Servico_Num_OS = os.Num_OS;

-- Listar serviços executados em cada ordem
select os.Num_OS, s.Descricao, isv.Subtotal
from Item_Servico isv
join Servico s on isv.Servico_idServico = s.idServico
join Ordem_Servico os on isv.Ordem_Servico_Num_OS = os.Num_OS;

-- Equipes e seus mecânicos
select e.idEquipe, m.Nome, m.Especialidade
from Equipe_Mecanicos e
join Mecanico m on m.Equipe_Mecanicos_idEquipe = e.idEquipe;

-- Valor total de cada ordem (somando peças e serviços)
select os.Num_OS, 
       coalesce(sum(ip.Subtotal),0) + coalesce(sum(isv.Subtotal),0) as Total_Calculado
from Ordem_Servico os
left join Item_Peca ip on os.Num_OS = ip.Ordem_Servico_Num_OS
left join Item_Servico isv on os.Num_OS = isv.Ordem_Servico_Num_OS
group by os.Num_OS;
