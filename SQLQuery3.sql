
CREATE DATABASE DataWarehouseDB;
GO

USE DataWarehouseDB;
GO


CREATE TABLE FactOrders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL
);


CREATE TABLE FactClientesAtendidos (
    CustomerID INT NOT NULL,
    AtencionFecha DATE NOT NULL,
    NumeroPedidos INT NOT NULL,
    PRIMARY KEY (CustomerID, AtencionFecha)
);


CREATE TABLE FactOrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    TotalPrice AS (Quantity * UnitPrice) PERSISTED
);


CREATE TABLE StagingOrders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(18, 2) NOT NULL
);


CREATE TABLE StagingClientesAtendidos (
    CustomerID INT NOT NULL,
    AtencionFecha DATE NOT NULL,
    OrderID INT NOT NULL
);

CREATE TABLE StagingOrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL
);


INSERT INTO StagingOrders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES 
(1, 101, '2024-11-01', 100.50),
(2, 102, '2024-11-02', 200.75),
(3, 103, '2024-11-03', 150.00);


INSERT INTO StagingClientesAtendidos (CustomerID, AtencionFecha, OrderID)
VALUES 
(101, '2024-11-01', 1),
(102, '2024-11-02', 2),
(103, '2024-11-03', 3),
(101, '2024-11-01', 1);


INSERT INTO StagingOrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 201, 2, 25.00),
(2, 2, 202, 1, 200.75),
(3, 3, 203, 3, 50.00);


TRUNCATE TABLE FactOrderDetails;
TRUNCATE TABLE FactOrders;
TRUNCATE TABLE FactClientesAtendidos;


INSERT INTO FactOrders (OrderID, CustomerID, OrderDate, TotalAmount)
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM StagingOrders;


INSERT INTO FactClientesAtendidos (CustomerID, AtencionFecha, NumeroPedidos)
SELECT CustomerID, AtencionFecha, COUNT(OrderID)
FROM StagingClientesAtendidos
GROUP BY CustomerID, AtencionFecha;


INSERT INTO FactOrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
SELECT OrderDetailID, OrderID, ProductID, Quantity, UnitPrice
FROM StagingOrderDetails;


SELECT * FROM FactOrders;


SELECT * FROM FactClientesAtendidos;


SELECT * FROM FactOrderDetails;






