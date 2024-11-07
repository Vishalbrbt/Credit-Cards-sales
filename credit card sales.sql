CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Email VARCHAR(100)
);

CREATE TABLE CreditCards (
    CardID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    CardType VARCHAR(50),
    IssueDate DATE,
    ExpiryDate DATE
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    CardID INT FOREIGN KEY REFERENCES CreditCards(CardID),
    SaleAmount DECIMAL(10, 2),
    SaleDate DATE
);
-- Inserting sample customers
INSERT INTO Customers (CustomerID, Name, Age, Gender, Email)
VALUES
(1, 'John Doe', 30, 'Male', 'john.doe@example.com'),
(2, 'Jane Smith', 25, 'Female', 'jane.smith@example.com');

-- Inserting sample credit cards
INSERT INTO CreditCards (CardID, CustomerID, CardType, IssueDate, ExpiryDate)
VALUES
(101, 1, 'Visa', '2022-01-15', '2026-01-15'),
(102, 2, 'MasterCard', '2023-03-20', '2027-03-20');

-- Inserting sample sales data
INSERT INTO Sales (SaleID, CardID, SaleAmount, SaleDate)
VALUES
(1, 101, 250.75, '2024-01-10'),
(2, 102, 450.50, '2024-02-15');
SELECT C.CardType, SUM(S.SaleAmount) AS TotalSales
FROM Sales S
JOIN CreditCards C ON S.CardID = C.CardID
GROUP BY C.CardType;
SELECT CASE
        WHEN C.Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN C.Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN C.Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE '46+'
       END AS AgeGroup,
       AVG(S.SaleAmount) AS AverageSale
FROM Sales S
JOIN CreditCards C ON S.CardID = C.CardID
GROUP BY CASE
           WHEN C.Age BETWEEN 18 AND 25 THEN '18-25'
           WHEN C.Age BETWEEN 26 AND 35 THEN '26-35'
           WHEN C.Age BETWEEN 36 AND 45 THEN '36-45'
           ELSE '46+'
         END;
SELECT TOP 5 C.Name, SUM(S.SaleAmount) AS TotalSpent
FROM Sales S
JOIN CreditCards CC ON S.CardID = CC.CardID
JOIN Customers C ON CC.CustomerID = C.CustomerID
GROUP BY C.Name
ORDER BY TotalSpent DESC;

SELECT MONTH(S.SaleDate) AS SaleMonth, C.CardType, SUM(S.SaleAmount) AS TotalSales
FROM Sales S
JOIN CreditCards C ON S.CardID = C.CardID
GROUP BY MONTH(S.SaleDate), C.CardType
ORDER BY SaleMonth, C.CardType;

SELECT C.Name, COUNT(S.SaleID) AS NumberOfTransactions
FROM Sales S
JOIN CreditCards CC ON S.CardID = CC.CardID
JOIN Customers C ON CC.CustomerID = C.CustomerID
GROUP BY C.Name
ORDER BY NumberOfTransactions DESC;
