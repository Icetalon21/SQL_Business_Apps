/*
Host: lindseyfry.lmu.build
Username: lindseyf_dba
Password: sql_2020
*/

/*
1. Select all columns from the film table for PG-rated films
*/
SELECT *
FROM film
WHERE rating = 'PG';

/*
2. Select the customer_id, first_name, and last_name for the active customers (0 means inactive). Sort the customers by their last name and restrict the results to 10 customers.
*/

SELECT customer_id, first_name, last_name, active
FROM customer
WHERE active = 1
ORDER BY last_name
LIMIT 10;

--Check query
SELECT active
FROM customer
WHERE active = 1
ORDER BY last_name
LIMIT 10;

/*
3. Select customer_id, first_name, and last_name for all customers where the last name is Clark.
*/

SELECT customer_id, first_name, last_name
FROM customer
WHERE last_name = "Clark";

/*
4. Select film_id, title, rental_duration, and description for films with a rental duration of 3 days
*/

SELECT film_id, title, rental_duration, description
FROM film
WHERE rental_duration = 3;

/*
5. Select film_id, title, rental_rate, and rental_duration for films that can be rented for more than 1 day and at a cost of $0.99 or more.
Sort the results by rental_rate then rental_duration.
*/

SELECT film_id, title, rental_rate, rental_duration
FROM film
WHERE rental_duration > 1
	AND rental_rate >= 0.99
ORDER BY rental_rate, rental_duration;

/*
6. Select film_id, title, replacement_cost, and length for films that cost 9.99 or 10.99 to replace and have a running time of 60 minutes or more.
*/

SELECT film_id, title, replacement_cost, length
FROM film
WHERE (replacement_cost = 9.99 OR replacement_cost = 10.99)
	AND length >= 60;

/*
7. Select film_id, title, replacement_cost, and rental_rate for films that cost $20 or more to replace and the cost to rent is less than a dollar.
*/

SELECT film_id, title, replacement_cost, rental_rate
FROM film
WHERE replacement_cost >= 20.00
	AND rental_rate < 1.00;

/*
8. Select film_id, title, and rating for films that do not have a G, PG, and PG-13 rating.  Do not use the OR logical operator.
*/

SELECT film_id, title, rating
FROM film
WHERE rating NOT IN ('G', 'PG', 'PG-13');

/*
9. How many films can be rented for 5 to 7 days? Your query should only return 1 row. (2 points)
*/

SELECT film_id, title, rental_duration
FROM film
WHERE rental_duration BETWEEN 5 AND 7
LIMIT 1;

/*
10. INSERT your favorite movie into the film table.
You can arbitrarily set the column values as long as they are related to the column.
Only assign values to columns that are not automatically handled by MySQL. (2 points)
*/

INSERT INTO film
(title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features)
VALUES
('Little Women', 'Film based on the original novel.', 2019, 1, NULL, 6, 4.99, 90, 20.99, 'PG', 'Trailers,Deleted Scenes');

--Check query
SELECT *
FROM film
WHERE title = 'Little Women';

/*
11. INSERT your two favorite actors/actresses into the actor table with a single SQL statement. (2 points)
*/
INSERT INTO actor
(first_name, last_name)
VALUES
('JENNIFER', 'LOPEZ'),
('JENNIFER', 'ANISTON');

--Check query
SELECT *
FROM actor
WHERE first_name = 'JENNIFER';

/*
12. The address2 column in the address table inconsistently defines what it means to not have an address2 associated with an address. UPDATE the address2 column to an empty string where the address2 value is currently null. (2 points)
*/

UPDATE address
SET address2 = ' '
WHERE address2 IS NULL;

/*
13. For rated G films less than an hour long, update the special_features column to replace Commentaries with Audio Commentary.
Be sure the other special features are not removed. (2 points)
*/

UPDATE film
SET special_features = REPLACE(special_features, 'Commentaries', 'Audio Commentary')
WHERE rating = 'G'
  AND length < 60;

/*
14. Create a new database named LinkedIn. Provide the SQL. You will still need to use LMU.build to create the database.
*/

CREATE DATABASE LinkedIn;

/*
15. Create a user table to store LinkedIn users.
The table must include 5 columns minimum with the appropriate data type and a primary key.
One of the columns should be Email and must be a unique value.
*/

CREATE TABLE User(
    UserID INT(11) NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(255) NOT NULL,
    CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID),
    UNIQUE KEY (Email)
    ) ENGINE=InnoDB;

--Check query
SELECT *
FROM User;

/*
16. Create a table to store a user's work experience.
The table must include a primary key, a foreign key column to the user table, and have at least 5 columns with the appropriate data type.
*/
CREATE TABLE UserWorkExperience(
  UserProfileID INT(11) NOT NULL AUTO_INCREMENT,
  WorkExperience VARCHAR(255) NOT NULL,
  Location VARCHAR(255) NOT NULL,
  Skills VARCHAR(255) NOT NULL,
  Bio VARCHAR(255) NOT NULL,
  UserID INT(11) NOT NULL,
  CreatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (UserProfileID),
  CONSTRAINT fk_UserWorkExperience_User_UserID FOREIGN KEY (UserID)
REFERENCES User(UserID)
) ENGINE=InnoDB;

--Check query
SELECT *
FROM UserWorkExperience;

/*
17. INSERT 1 user into the user table
*/

INSERT INTO User
(FirstName, LastName, Email, PhoneNumber)
VALUES
('Aimee', 'Bender', 'a.bender@gmail.com', '(858)234-5423');

--Check query
SELECT *
FROM User;

/*
18. INSERT 1 work experience entry for the user just inserted.
*/

INSERT INTO UserWorkExperience
(WorkExperience, Location, Skills, Bio, UserID)
VALUES
('Author', 'New York', 'Writing', 'Popular Author of new book', 1);

/*
19. The warehouse manager wants to know all of the products the company carries. Generate a list of all the products with all of the columns.
*/

SELECT *
FROM Products;

/*
20. The marketing department wants to run a direct mail marketing campaign to its American, Canadian, and Mexican customers.
Write a query to gather the data needed for a mailing label.
*/

SELECT CompanyName, ContactName, Address, City, PostalCode, Country
FROM Customers
WHERE Country IN ('USA', 'Canada', 'Mexico');

/*
21. HR wants to celebrate hire date anniversaries for the sales representatives in the USA office.
Develop a query that would give HR the information they need to coordinate hire date anniversary gifts.
Sort the data as you see best fit.
*/

SELECT HireDate, LastName, FirstName, Notes
FROM Employees
WHERE Title = 'Sales Representative'
	AND Country = 'USA'
ORDER BY HireDate, LastName;

--Check query returns 3 results
SELECT Country, Title
FROM Employees
WHERE Title = 'Sales Representative'
	AND Country = 'USA';

/*
22. What is the SQL command to show the structure for the Shippers table?
*/

DESCRIBE Shippers;

/*
23. Customer service noticed an increase in shipping errors for orders handled by the employee, Janet Leverling.
Return the OrderIDs handled by Janet so that the orders can be inspected for other errors.
*/

SELECT LastName, FirstName, EmployeeID
FROM Employees
WHERE LastName = 'Leverling'
	AND FirstName = 'Janet';

SELECT OrderID, EmployeeID
FROM Orders
WHERE EmployeeID = 3;

/*
24. The sales team wants to develop stronger supply chain relationships with its suppliers by reaching out to the managers who have the decision making power to create a just-in-time inventory arrangement.
Display the supplier's company name, contact name, title, and phone number for suppliers who have manager or mgr in their title.
*/

SELECT CompanyName, ContactName, ContactTitle, Phone
FROM Suppliers
WHERE ContactTitle LIKE '%Manager%'
	OR ContactTitle LIKE '%Mgr%';

/*
25. The warehouse packers want to label breakable products with a fragile sticker.
Identify the products with glasses, jars, or bottles and are not discontinued (0 = not discontinued).
*/

SELECT ProductName, Discontinued, QuantityPerUnit
FROM Products
WHERE (QuantityPerUnit LIKE '%glass%'
       OR QuantityPerUnit LIKE '%jar%'
       OR QuantityPerUnit LIKE '%bottle%')
       AND Discontinued = 0;

/*
26. How many customers are from Brazil and have a role in sales?
Your query should only return 1 row.
*/

SELECT ContactName, ContactTitle, Country
FROM Customers
WHERE ContactTitle LIKE '%Sale%'
	AND Country = 'Brazil'
LIMIT 1;

/*
27. Who is the oldest employee in terms of age? Your query should only return 1 row.
*/
SELECT *
FROM Employees
ORDER BY BirthDate
LIMIT 1;

/*
28. Calculate the total order price per order and product before and after the discount.
The products listed should only be for those where a discount was applied.
Alias the before discount and after discount expressions.
*/

SELECT UnitPrice * Quantity AS PriceBeforeDiscount, UnitPrice * Quantity * Discount AS PriceAfterDiscount
FROM OrderDetails
WHERE Discount > 0;

/*
29. To assist in determining the company's assets, find the total dollar value for all products in stock.
Your query should only return 1 row.
*/

SELECT ProductName, UnitPrice * UnitsInStock AS TotalDollarValue
FROM Products
WHERE UnitsInStock > 0
LIMIT 1;

/*
30. Supplier deliveries are confirmed via email and fax.
Create a list of suppliers with a missing fax number to help the warehouse receiving team identify who to contact to fill in the missing information.
*/

SELECT CompanyName, ContactName
FROM Suppliers
WHERE Fax IS NULL;

--Check query
SELECT Fax
FROM Suppliers
WHERE Fax IS NULL;

/*
31. The PR team wants to promote the company's global presence on the website.
Identify a unique and sorted list of countries where the company has customers.
*/

SELECT DISTINCT(Country)
FROM Customers
ORDER BY Country;

/*
32. List the products that need to be reordered from the supplier.
Know that you can use column names on the right-hand side of a comparison operator.
*/

SELECT ProductName, UnitsInStock, ReorderLevel
FROM Products
WHERE Discontinued = 0
AND UnitsInStock <= ReorderLevel;


/*
33. You're the newest hire.
INSERT yourself as an employee with the INSERT … SET method.
You can arbitrarily set the column values as long as they are related to the column.
Only assign values to columns that are not automatically handled by MySQL
*/

INSERT INTO Employees
SET LastName = 'Fry', FirstName = 'Lindsey', Title = 'Marketing Manager', TitleOfCourtesy = 'Ms.', BirthDate = '1998-06-04 00:00:00', HireDate = '2019-08-24 00:00:00', Address = '8601 Lincoln Blvd', City = 'Los Angeles', Region = 'CA', PostalCode = '90045', Country = 'USA', HomePhone = '(858) 254-3917', Extension = '2342', Notes = 'Education includes a BS in AIMS from LMU.', ReportsTo = 3, PhotoPath = 'http://accweb/emmployees/fry.bmp';

--Check query
SELECT *
FROM Employees
WHERE LastName = 'Fry';

/*
34. The supplier, Bigfoot Breweries, recently launched their website.
UPDATE their website to bigfootbreweries.com.
*/

--Find Bigfoot to see what is in the website slot
SELECT *
FROM Suppliers
WHERE CompanyName = 'Bigfoot Breweries';

--Conduct query
UPDATE Suppliers
SET HomePage = 'bigfootbreweries.com'
WHERE CompanyName = 'Bigfoot Breweries';

--Check query
SELECT *
FROM Suppliers
WHERE CompanyName = 'Bigfoot Breweries';

/*
35. The images on the employee profiles are broken.
The link to the employee headshot is missing the .com domain extension.
Fix the PhotoPath link so that the domain properly resolves.
Broken link example: http://accweb/emmployees/buchanan.bmp
*/

UPDATE Employees
SET PhotoPath = REPLACE(PhotoPath, '.bmp', '.com')
WHERE PhotoPath LIKE('%.bmp');

--Check query
SELECT PhotoPath
FROM Employees;

/*
Custom Data Requests
Create 6 data requests on the SpecialtyFood database. For each request,
1) write out a question to specify the required data
2) give a business justification. How can a manager use the data for better decision making?
3) Write the SQL used to produce the final data set.
4) Export the final data set to a CSV file then convert it to an Excel spreadsheet with a .xlsx file extension.
*/

/*
Data Request 1
Question: Which suppliers are outside of the United States?
Business Justification: The manager can use this data to determine which suppliers they would like to keep if there is a need to cut out any.
												This is helpful because shipping costs and phone call costs are higher in other countries.
*/
SELECT CompanyName, Country, Phone
FROM Suppliers
WHERE Country <> 'USA'
ORDER BY Country, CompanyName;

/*
Data Request #2
Question: Which customers have the most orders?
Business Justification: This will help managers see which customers are making the most orders.
												They can use this to market more strongly to these customers or give them discounts to keep their business.
*/

SELECT Orders.OrderID, Customers.CompanyName
FROM Orders, Customers
WHERE Orders.CustomerID = Customers.CustomerID
ORDER BY Customers.CompanyName;

/*
Data Request #3
Question: Which suppliers have supplied our various products?
Business Justification: This shows which suppliers supplied which products in addition to the categories those products are placed in.
												This is helpful because in the future, the company can decide which supplier to use based on the product or the category.
*/

SELECT ProductName, SupplierID, CategoryID
FROM Products
ORDER BY SupplierID, CategoryID;

/*
Data Request #4
Question: How much money have we made on each order?
Business Justification: Will show us which orders made us the most money. We can then go in a track which customers made which orders
*/

SELECT OrderID, (UnitPrice - (UnitPrice * Discount)) * Quantity AS AmountSpent
FROM OrderDetails
ORDER BY (UnitPrice - (UnitPrice * Discount)) * Quantity DESC, OrderID

--Query used to grab the company name
SELECT Orders.OrderID, Customers.CompanyName
FROM Orders, Customers
WHERE Orders.CustomerID = Customers.CustomerID
	AND Orders.OrderID = 10981;
