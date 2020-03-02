/*
Host:  lindseyfry.lmu.build
Username: lindseyf_dba
Password: sql_2020
*/

/*
3. Create a table named nyt_article with a column for each of these JSON keys in the API result
*/
CREATE TABLE nyt_article(
    _id INT(11) NOT NULL AUTO_INCREMENT,
    web_url VARCHAR(255) NOT NULL,
    main VARCHAR(255) NOT NULL,
    document_type VARCHAR(255) NOT NULL,
    pub_date VARCHAR(255) NOT NULL,
    word_count INT(11) NOT NULL,
    type_of_material VARCHAR(255) NOT NULL,
    PRIMARY KEY (nyt_article_id),
    UNIQUE KEY (web_url)
    ) ENGINE=InnoDB;

/*
5. How many articles were published between December 1, 2019 and December 25, 2019 in the nyt_article table?
*/
SELECT COUNT(DISTINCT _id), pub_date
FROM nyt_article
WHERE pub_date BETWEEN '2019-12-1' AND '2019-12-25';

/*
6. What is the average word count per article for articles published on and after November 2, 2019 in the nyt_article table?
*/
SELECT AVG(word_count), pub_date, _id
FROM nyt_article
WHERE pub_date >= '2019-11-2';
--Add GROUP BY?

/*
7. What is the minimum and maximum pub_date for articles published between October 1, 2019 and October 31, 2019 in the nyt_article table?
*/
SELECT MIN(pub_date), MAX(pub_date)
FROM nyt_article
WHERE pub_date BETWEEN '2019-10-01' AND '2019-10-31';
--Check Logic?

/*
8.How many total words were published for articles published in November 2019 in the nyt_article table?
*/
SELECT SUM(word_count)
FROM `nyt_article`
WHERE pub_date BETWEEN '2019-11-01' AND '2019-11-30';

/*
9. Display the agents' full name as a single column and the engagement dates they booked where the negotiated price is over $1k.
Sort the results by the booking start date from oldest to newest.
*/
SELECT CONCAT(Agents.AgtFirstName, ' ', Agents.AgtLastName) AS AgentFullName, Engagements.StartDate, ContractPrice
FROM Agents
JOIN Engagements
  ON Agents.AgentID = Engagements.AgentID
ORDER BY Engagements.StartDate;

/*
10. List the customers (full name) and the entertainers they booked from the 98052 zip code.
*/
SELECT CONCAT(Customers.CustFirstName, ' ', Customers.CustLastName) AS CustomerFullName, Entertainers.EntStageName, Entertainers.EntZipCode
FROM Customers
JOIN Engagements
  ON Customers.CustomerID = Engagements.CustomerID
JOIN Entertainers
  ON Entertainers.EntertainerID = Engagements.EntertainerID
WHERE Entertainers.EntZipCode = 98052;

/*
11. Find agent(s) who have yet to book an entertainer.
*/
SELECT CONCAT(Agents.AgtFirstName, ' ', Agents.AgtLastName) AS AgentFullName, Entertainers.EntertainerID, Entertainers.EntStageName
FROM Agents
LEFT JOIN Engagements
  ON Agents.AgentID = Engagements.AgentID
LEFT JOIN Entertainers
  ON Entertainers.EntertainerID = Engagements.EntertainerID
WHERE Entertainers.EntertainerID IS NULL;

--Check. Only received one Agent

/*
12. Name the entertainer(s) who have never been booked.
*/
SELECT Entertainers.EntStageName, Engagements.AgentID, Engagements.EngagementNumber
FROM Entertainers
LEFT JOIN Engagements
  ON Entertainers.EntertainerID = Engagements.EntertainerID
WHERE Engagements.AgentID IS NULL;

--Check. Only received one Entertainer

/*
13. SQL - Display a combined list of customers and entertainers. Be sure the number of columns lines up. Identify if the row is a Customer or Entertainer.
*/
SELECT CONCAT(CustFirstName, CustLastName) AS CustomerFullName, 'Customers' AS PersonType
FROM Customers
UNION
SELECT EntStageName, 'Entertainers'
FROM Entertainers;

/*
14. Without using a JOIN and only using subqueries, list the entertainers who played engagements for the customer, Sarah Thompson.
*/
--Find CustomerID for Sarah Thompson
SELECT CustomerID, CustFirstName, CustLastName
FROM Customers
WHERE CustFirstName = 'Sarah' AND CustLastName = 'Thompson';

--Find the entertainers who have performed for Sarah Thompson
SELECT EntStageName
FROM Entertainers
WHERE EntertainerID IN
 (
     SELECT EntertainerID
     FROM Engagements
     WHERE CustomerID = 10009
 );

/*
15. Find the customer full name with the most engagements booked. The end result should only contain 1 row.
*/
SELECT COUNT(*) AS EngagementsBooked, CustFirstName, CustLastName
FROM Customers
WHERE CustomerID IN
	(
        SELECT CustomerID
        FROM Engagements
    )

--Alternate method
SELECT COUNT(DISTINCT Engagements.CustomerID), Customers.CustFirstName, Customers.CustLastName
FROM Engagements
LEFT JOIN Customers
    ON Engagements.CustomerID = Customers.CustomerID;


/*
16. Generate a list of entertainer names with their number of booked engagements, lowest contract price, highest contract price, contract price total, and contract price average.
*/
SELECT Entertainers.EntStageName, COUNT(DISTINCT Engagements.EngagementNumber) AS NumberOfBookedEngagements, MIN(Engagements.ContractPrice) AS LowestContractPrice, MAX(Engagements.ContractPrice) AS HighestContractPrice, SUM(Engagements.ContractPrice) AS ContractPriceTotal, AVG(Engagements.ContractPrice) AS ContractPriceAverage
FROM Engagements
JOIN Entertainers
  ON Entertainers.EntertainerID = Engagements.EntertainerID
GROUP BY Entertainers.EntStageName;

/*
17. Name the agents who booked more than $1,000 worth of business in November 2017.
*/
SELECT Agents.AgentID, Agents.AgtFirstName, Agents.AgtLastName
FROM Agents
JOIN
  (
    SELECT Engagements.AgentID, Engagements.ContractPrice, Engagements.EndDate
    FROM Engagements
    WHERE (MONTH(EndDate) = 11 AND YEAR(EndDate) = 2017) AND ContractPrice >1000
  ) AS OrderSum
	ON Agents.AgentID = OrderSum.AgentID;

/*
18. Query for each agent’s full name,
the sum of the contract price for the engagements booked,
and the agent’s total commission for agents whose total commission is more than $500.
Consider the columns required to calculate the commission.
The grouped results will be filtered by a calculated value.
*/
SELECT Agents.AgtFirstName, Agents.AgtLastName, (Agents.CommissionRate * Engagements.ContractPrice) AS TotalCommission, SUM(Engagements.ContractPrice) AS SumContractPrice
FROM Agents, Engagements
WHERE (Agents.CommissionRate * Engagements.ContractPrice) >500
GROUP BY (Agents.CommissionRate * Engagements.ContractPrice);

--Alternative (only returns one result)
SELECT Agents.AgtFirstName, Agents.AgtLastName, (Agents.CommissionRate * Engagements.ContractPrice) AS TotalCommission, SUM(Engagements.ContractPrice) AS SumContractPrice
FROM Engagements
JOIN Agents
	ON Agents.AgentID = Engagements.AgentID
WHERE (Agents.CommissionRate * Engagements.ContractPrice)>500

/*
20. Create a table named simplyhired_job with a column for each job component
*/
CREATE TABLE simplyhired_job(
    simplyhired_job_id INT(11) NOT NULL AUTO_INCREMENT,
    job_title VARCHAR(255) NOT NULL,
    job_company VARCHAR(255) NOT NULL,
    job_location VARCHAR(255) NOT NULL,
    job_link VARCHAR(255) NOT NULL,
    PRIMARY KEY (simplyhired_job_id)
    ) ENGINE=InnoDB;

/*
# Data Request 1
Question: What is the membership status of each Entertainer?

Business Justification: This allows the business to evaluate the purpose of the membership.
                        With this information, they can add benefits and incentives to the membership status.
                        They can also market more toward the entertainers who do not have a membership.
*/
SELECT Entertainer_Members.Status, Entertainers.EntertainerID, Entertainers.EntStageName
FROM Entertainer_Members
JOIN Entertainers
	ON Entertainer_Members.EntertainerID = Entertainers.EntertainerID
GROUP BY Entertainers.EntertainerID;

/*
# Data Request 2
Question: What are the music styles customers want to order AND what music styles do we have entertainers for?

Business Justification: This allows the company to understand the demand of entertainers.
                        With this information, they can hire more entertainers to meet the demand.
*/
SELECT Customers.CustomerID, Customers.CustFirstName, Customers.CustLastName, Musical_Styles.StyleName
FROM Customers
JOIN Musical_Preferences
	ON Customers.CustomerID = Musical_Preferences.CustomerID
JOIN Musical_Styles
	ON Musical_Preferences.StyleID = Musical_Styles.StyleID
ORDER BY Musical_Styles.StyleName;

SELECT Entertainers.EntertainerID, Entertainers.EntStageName, Musical_Styles.StyleName
FROM Entertainers
JOIN Entertainer_Styles
	ON Entertainers.EntertainerID = Entertainer_Styles.EntertainerID
JOIN Musical_Styles
	ON Entertainer_Styles.StyleID = Musical_Styles.StyleID
ORDER BY Musical_Styles.StyleName;

/*agent with the most entertainers*/
SELECT CONCAT(Agents.AgtFirstName, ' ', Agents.AgtLastName) AS AgentFullName, COUNT(Entertainers.EntertainerID) AS EntertainerCount
FROM Agents
LEFT JOIN Engagements
  ON Agents.AgentID = Engagements.AgentID
LEFT JOIN Entertainers
  ON Entertainers.EntertainerID = Engagements.EntertainerID
GROUP BY Agents.AgentID
ORDER BY EntertainerCount DESC

/*Which entertainer has the most engagments*/
SELECT Entertainers.EntStageName, Engagements.AgentID, Engagements.EngagementNumber
FROM Entertainers
LEFT JOIN Engagements
  ON Entertainers.EntertainerID = Engagements.EntertainerID
ORDER BY Engagements.EngagementNumber DESC
