-- ======================================================
-- Question 1: Achieving 1NF (First Normal Form)
-- ======================================================
-- Objective: Eliminate repeating groups (multiple products in a single field)
-- Strategy: Split each product in the 'Products' column into a separate row

-- Step 1: Create the original unnormalized table
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255) -- comma-separated product list
);

-- Step 2: Insert the provided unnormalized data
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 3: Create a normalized table for 1NF where each product is in a separate row
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50)
);

-- Step 4: Use SQL to separate comma-separated products into individual rows
-- (Note: Actual implementation may vary depending on the RDBMS — this example uses MySQL syntax)
-- Assuming use of a helper function or support for JSON_TABLE or STRING_SPLIT for splitting strings

-- For systems that support STRING_SPLIT (SQL Server):
-- INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
-- SELECT OrderID, CustomerName, TRIM(value)
-- FROM ProductDetail
-- CROSS APPLY STRING_SPLIT(Products, ',');

-- Simulated Manual Inserts (for demonstration):
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Laptop');
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Mouse');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Tablet');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Keyboard');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Mouse');
INSERT INTO ProductDetail_1NF VALUES (103, 'Emily Clark', 'Phone');

-- ======================================================
-- Question 2: Achieving 2NF (Second Normal Form)
-- ======================================================
-- Objective: Eliminate partial dependencies
-- Strategy: Separate data into multiple tables so non-key columns depend on the whole key

-- Step 1: Original OrderDetails table
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(50),
    Quantity INT
);

-- Step 2: Insert the provided data
INSERT INTO OrderDetails VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Step 3: Create normalized tables
-- Customer Table: Separate out customer information
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100)
);

-- Orders Table: Reference customers by ID, store OrderID
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Products Table: Contains unique products (optional normalization)
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(50)
);

-- OrderItems Table: Junction table for OrderID and Product with quantity
CREATE TABLE OrderItems (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Step 4: Insert normalized data manually (for demo purposes)
-- Customers
INSERT INTO Customers (CustomerName) VALUES ('John Doe'), ('Jane Smith'), ('Emily Clark');

-- Orders
INSERT INTO Orders (OrderID, CustomerID) VALUES
(101, 1),
(102, 2),
(103, 3);

-- Products
INSERT INTO Products (ProductName) VALUES ('Laptop'), ('Mouse'), ('Tablet'), ('Keyboard'), ('Phone');

-- OrderItems (assuming ProductID mapping: Laptop-1, Mouse-2, Tablet-3, Keyboard-4, Phone-5)
INSERT INTO OrderItems VALUES
(101, 1, 2),
(101, 2, 1),
(102, 3, 3),
(102, 4, 1),
(102, 2, 2),
(103, 5, 1);
-- ======================================================
-- Question 3: Achieving 3NF (Third Normal Form)
-- ======================================================
-- 3NF removes transitive dependencies. Our structure already satisfies this:
-- - CustomerName moved to Customers (no dependency on non-key fields)
-- - ProductName in Products table (no transitive dependency)
-- - OrderItems contains only foreign keys and quantity

-- Final structure already normalized to 3NF. No further changes needed.

-- Example query to view a full order with JOINs:
SELECT 
    o.OrderID,
    c.CustomerName,
    p.ProductName,
    oi.Quantity
FROM OrderItems oi
JOIN Orders o ON oi.OrderID = o.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON oi.ProductID = p.ProductID;
