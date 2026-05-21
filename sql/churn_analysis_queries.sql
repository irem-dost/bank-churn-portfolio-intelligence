-- Create the main database for our Bank Churn Analysis Project
CREATE DATABASE Bank_Churn_DB;
GO

-- Activate the database to ensure we are working inside it
USE Bank_Churn_DB;
GO



-- 1. Define the Primary Key for the Customers table
ALTER TABLE Customers
ALTER COLUMN Customer_ID INT NOT NULL;
GO
ALTER TABLE Customers
ADD CONSTRAINT PK_Customers PRIMARY KEY (Customer_ID);
GO

-- 2. Define the Primary Key for the Accounts table
ALTER TABLE Accounts
ALTER COLUMN Account_ID INT NOT NULL;
GO
ALTER TABLE Accounts
ADD CONSTRAINT PK_Accounts PRIMARY KEY (Account_ID);
GO

-- 3. Establish a Foreign Key relationship between Accounts and Customers
ALTER TABLE Accounts
ALTER COLUMN Customer_ID INT NOT NULL;
GO
ALTER TABLE Accounts
ADD CONSTRAINT FK_Accounts_Customers FOREIGN KEY (Customer_ID) 
REFERENCES Customers(Customer_ID);
GO

-- 4. Establish a Foreign Key relationship between Transactions and Accounts
ALTER TABLE Transactions
ALTER COLUMN Account_ID INT NOT NULL;
GO
ALTER TABLE Transactions
ADD CONSTRAINT FK_Transactions_Accounts FOREIGN KEY (Account_ID) 
REFERENCES Accounts(Account_ID);
GO



-- Query 1: High-Level Overview of Customers and Financial Portfolio
SELECT 
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    COUNT(a.Account_ID) AS Total_Accounts,
    SUM(a.Balance) AS Total_Bank_Balance,
    AVG(a.Balance) AS Average_Account_Balance
FROM Customers c
LEFT JOIN Accounts a ON c.Customer_ID = a.Customer_ID;



-- Query 2: Churn Rate and Total Balance Analysis by Gender
SELECT 
    c.Gender,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    SUM(CASE WHEN a.Balance < 0 THEN 1 ELSE 0 END) AS Potential_Churn_Accounts, -- Accounts with negative balance (potential churn)
    SUM(a.Balance) AS Total_Balance
FROM Customers c
LEFT JOIN Accounts a ON c.Customer_ID = a.Customer_ID
GROUP BY c.Gender;




-- Query 3: Top 10 Job Titles with the Highest Potential Churn Accounts
SELECT TOP 10
    c.Job_Title,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    SUM(CASE WHEN a.Balance < 0 THEN 1 ELSE 0 END) AS Potential_Churn_Accounts,
    SUM(a.Balance) AS Total_Balance
FROM Customers c
LEFT JOIN Accounts a ON c.Customer_ID = a.Customer_ID
GROUP BY c.Job_Title
ORDER BY Potential_Churn_Accounts DESC;



-- Query 4: Average Transaction Amount by Account Status (Positive vs Negative Balance)
SELECT 
    CASE WHEN a.Balance < 0 THEN 'Potential Churn (Negative)' ELSE 'Active (Positive)' END AS Account_Status,
    t.Transaction_Type,
    COUNT(t.Transaction_ID) AS Total_Transactions,
    AVG(t.Amount) AS Average_Transaction_Amount
FROM Accounts a
JOIN Transactions t ON a.Account_ID = t.Account_ID
GROUP BY 
    CASE WHEN a.Balance < 0 THEN 'Potential Churn (Negative)' ELSE 'Active (Positive)' END,
    t.Transaction_Type;




-- Query 5: Potential Churn and Financial Portfolio Analysis by Age Groups
SELECT 
    CASE 
        WHEN c.Age < 30 THEN 'Under 30 (Young)'
        WHEN c.Age BETWEEN 30 AND 50 THEN '30-50 (Middle Aged)'
        ELSE 'Over 50 (Senior)'
    END AS Age_Group,
    COUNT(DISTINCT c.Customer_ID) AS Total_Customers,
    SUM(CASE WHEN a.Balance < 0 THEN 1 ELSE 0 END) AS Potential_Churn_Accounts,
    SUM(a.Balance) AS Total_Balance
FROM Customers c
LEFT JOIN Accounts a ON c.Customer_ID = a.Customer_ID
GROUP BY 
    CASE 
        WHEN c.Age < 30 THEN 'Under 30 (Young)'
        WHEN c.Age BETWEEN 30 AND 50 THEN '30-50 (Middle Aged)'
        ELSE 'Over 50 (Senior)'
    END;