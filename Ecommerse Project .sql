DROP DATABASE IF EXISTS Ecommerce;
CREATE DATABASE Ecommerce;
USE Ecommerce;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    total_sales DECIMAL(10,2),
    order_date DATE,
    payment_method VARCHAR(50),
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers (customer_name, city, state) VALUES 
('Aman Sharma', 'Indore', 'MP'),
('Rahul Verma', 'Bhopal', 'MP'),
('Sonal Jain', 'Mumbai', 'Maharashtra'),
('Amit Patel', 'Ahmedabad', 'Gujarat'),
('Priya Nair', 'Bangalore', 'Karnataka'),
('Vikram Singh', 'Delhi', 'Delhi'),
('Neha Gupta', 'Jaipur', 'Rajasthan'),
('Rohit Das', 'Kolkata', 'West Bengal'),
('Rohan Mehta', 'Indore', 'MP'),
('Anjali Tiwari', 'Lucknow', 'UP');

INSERT INTO Products (product_name, category, brand, price) VALUES 
('iPhone 15', 'Electronics', 'Apple', 79999.00),
('MacBook Air M2', 'Electronics', 'Apple', 99999.00),
('Running Shoes', 'Footwear', 'Nike', 4999.00),
('Air Max', 'Footwear', 'Nike', 8999.00),
('501 Original Jeans', 'Clothing', 'Levi\'s', 2499.00),
('Casual Denim Shirt', 'Clothing', 'Levi\'s', 1999.00),
('Galaxy S24', 'Electronics', 'Samsung', 74999.00),
('Wireless Earbuds', 'Electronics', 'Sony', 5999.00),
('Trimmer', 'Electronics', 'Philips', 1899.00),
('Slim Fit Trousers', 'Clothing', 'Zara', 3499.00);


INSERT INTO Orders (customer_id, product_id, quantity, total_sales, order_date, payment_method, status) VALUES 
(1, 1, 1, 79999.00, '2026-06-01', 'UPI', 'Delivered'),
(2, 3, 2, 9998.00, '2026-06-02', 'COD', 'Delivered'),
(3, 5, 1, 2499.00, '2026-06-02', 'Credit Card', 'Delivered'),
(4, 2, 1, 99999.00, '2026-06-03', 'Net Banking', 'Delivered'),
(5, 4, 1, 8999.00, '2026-06-04', 'UPI', 'Delivered'),
(1, 6, 2, 3998.00, '2026-06-05', 'UPI', 'Delivered'),
(6, 7, 1, 74999.00, '2026-06-06', 'Credit Card', 'Delivered'),
(7, 9, 1, 1899.00, '2026-06-07', 'COD', 'Returned'),
(8, 8, 2, 11998.00, '2026-06-08', 'UPI', 'Delivered'),
(9, 3, 1, 4999.00, '2026-06-09', 'UPI', 'Delivered'),
(10, 10, 1, 3499.00, '2026-06-10', 'Credit Card', 'Delivered'),
(2, 5, 2, 4998.00, '2026-06-11', 'UPI', 'Delivered'),
(3, 1, 1, 79999.00, '2026-06-12', 'Net Banking', 'Cancelled'),
(5, 4, 2, 17998.00, '2026-06-13', 'UPI', 'Delivered'),
(6, 6, 1, 1999.00, '2026-06-14', 'COD', 'Delivered');

select * from Customers;
select * from Products;
select * from Orders;

-- Top Performing Brands 

SELECT 
    p.brand, 
    COUNT(o.order_id) AS Total_Orders, 
    SUM(o.quantity) AS Total_Products_Sold,
    SUM(o.total_sales) AS Total_Revenue
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
WHERE o.status LIKE '%Delivered%'
GROUP BY p.brand
ORDER BY Total_Revenue DESC;

-- Customer Spending board

SELECT 
    c.customer_name,
    c.city,
    SUM(o.total_sales) AS Total_Spent,
    COUNT(o.order_id) AS Total_Orders_Placed,
    DENSE_RANK() OVER (ORDER BY SUM(o.total_sales) DESC) AS Customer_Rank
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.city;


-- Payment Method & Return Rate 
SELECT 
    o.payment_method,
    COUNT(o.order_id) AS Total_Orders,
    SUM(o.total_sales) AS Total_Sales_Amount,
    ROUND(COUNT(CASE WHEN o.status = 'Returned' THEN 1 END) * 100.0 / COUNT(o.order_id), 2) AS Return_Rate_Percentage
FROM Orders o
GROUP BY o.payment_method
ORDER BY Total_Sales_Amount DESC;