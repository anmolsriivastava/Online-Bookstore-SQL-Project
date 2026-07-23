CREATE DATABASE OnlineBookstore;
USE OnlineBookstore;

DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;

CREATE TABLE Books(
	Book_ID	INT AUTO_INCREMENT PRIMARY KEY ,
	Title VARCHAR(100),
	Author VARCHAR(50),
	Genre VARCHAR(50),
	Published_Year INT,
	Price DECIMAL(10,2),	
	Stock INT	
);

CREATE TABLE Customers(
	Customer_ID	INT AUTO_INCREMENT PRIMARY KEY,
	Name VARCHAR(100),	
	Email VARCHAR(100),	
	Phone VARCHAR(15),
	City VARCHAR(100),	
	Country	VARCHAR(150)	
);

CREATE TABLE Orders (
	Order_ID INT AUTO_INCREMENT PRIMARY KEY,
	Customer_ID	INT ,	
	Book_ID	INT ,
	Order_Date DATE,	
	Quantity INT,	
	Total_Amount DECIMAL(10,2),
    
    FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers(Customer_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(Book_ID)
);
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books 
WHERE genre = 'Fiction';

-- 2) Find books published after the year 1950:

SELECT * FROM Books WHERE Published_year > 1950;

-- 3) List all customers from the Canada:

SELECT * FROM Customers WHERE COUNTRY = 'Canada';

-- 4) Show orders placed in November 2023:

SELECT * FROM Orders WHERE Order_date 
BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(Stock) AS TOTAL_STOCK 
FROM Books;

-- 6) Find the details of the most expensive book:

SELECT * FROM books 
Order by Price desc limit 1;

SELECT * FROM books 
WHERE Price = (SELECT MAX(Price) FROM Books);    -- whth max
-- 7) Show all customers who ordered more than 1 quantity of a book:

SELECT * FROM orders 
WHERE Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:

SELECT * FROM Orders 
WHERE Total_amount > 20;

-- 9) List all genres available in the Books table:

SELECT DISTINCT Genre FROM books;

SELECT Genre FROM Books 
GROUP BY Genre;

-- 10) Find the book with the lowest stock:

SELECT * FROM Books 
ORDER BY stock
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:

SELECT SUM(TOTAL_AMOUNT) AS Total_Revenue 
FROM Orders;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT b.Genre ,SUM(o.Quantity) AS Total_Book_Sold
FROM Books b 
JOIN orders o ON b.book_id = o.Book_id
GROUP BY B.GENRE;


-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(PRICE) AS AVERAGE_PRICE FROM BOOKS 
WHERE GENRE = 'FANTASY';

-- 3) List customers who have placed at least 2 orders:

SELECT Customer_id ,COUNT(ORDER_ID) AS TOTAL_ORDERS 
FROM ORDERS
GROUP BY Customer_id 
HAVING COUNT(ORDER_ID) >= 2;

SELECT  O.CUSTOMER_ID, C.NAME, COUNT(O.ORDER_ID) AS ORDER_COUNT     -- WITH NAME
FROM ORDERS O
JOIN CUSTOMERS C ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY O.CUSTOMER_ID, C.NAME
HAVING COUNT(O.ORDER_ID) >= 2;

-- 4) Find the most frequently ordered book:

SELECT O.BOOK_ID, B.TITLE, COUNT(O.CUSTOMER_ID) AS ORDER_COUNT
FROM BOOKS B
JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY O.BOOK_ID ,B.TITLE ORDER BY ORDER_COUNT DESC LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM BOOKS 
WHERE GENRE = 'FANTASY' 
ORDER BY PRICE DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT B.AUTHOR, SUM(O.QUANTITY) AS TOTAL_BOOKS_SOLD
FROM BOOKS B
JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.AUTHOR;

-- 7) List the cities where customers who spent over $30 are located:

SELECT C.CITY,C.NAME, SUM(O.TOTAL_AMOUNT) AS AMOUNT
FROM ORDERS O
JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.CITY, C.NAME
HAVING SUM(O.TOTAL_AMOUNT) > 30;

-- 8) Find the customer who spent the most on orders:

SELECT C.NAME, SUM(O.TOTAL_AMOUNT) AS TOTAL_AMOUNT
FROM ORDERS O 
JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, C.NAME 
ORDER BY TOTAL_AMOUNT DESC LIMIT 5;

-- 9) Calculate the stock remaining after fulfilling all orders:
SELECT * FROM ORDERS;
SELECT B.BOOK_ID, B.TITLE, B.STOCK, COALESCE(SUM(O.QUANTITY),0) AS ORDER_QUANTITY,
B.STOCK - COALESCE(SUM(O.QUANTITY),0) AS REMANING_QUANTITY
FROM BOOKS B
LEFT JOIN ORDERS O ON B.BOOK_ID = O.BOOK_ID
GROUP BY B.BOOK_ID;








