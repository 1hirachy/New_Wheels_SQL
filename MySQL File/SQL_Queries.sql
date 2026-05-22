-- Question 1:
-- Find the total number of customers who have placed orders. What is the distribution of the customers across states? 
-- Hint: For each state, count the number of customers

-- PART 1
SELECT 
	COUNT(DISTINCT C.CUSTOMER_ID) TOTAL_NUMBER_OF_CUSTOMERS -- USED DISTINCT TO COUNT ACTUAL NO OF CUSTOMERS OVER ONE CUSTOMERS MIGHT HAVE MORE THAN ONE ORDERS 
FROM CUSTOMER_T C
	JOIN ORDER_T O
	ON C.CUSTOMER_ID = O.CUSTOMER_ID;


-- PART 2
SELECT 
	C.STATE,
    COUNT(DISTINCT C.CUSTOMER_ID) NUMBER_OF_CUSTOMERS -- USED DISTINCT TO COUNT ACTUAL NO OF CUSTOMERS OVER ONE CUSTOMERS MIGHT HAVE MORE THAN ONE ORDERS 
FROM CUSTOMER_T C
	JOIN ORDER_T O
	ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY STATE
ORDER BY NUMBER_OF_CUSTOMERS DESC;




-- Question 2:
-- Which are the top 5 vehicle makers preferred by the customers? 
-- Hint: For each vehicle make what is the count of the customers.
SELECT 
	PT.VEHICLE_MAKER,
    COUNT(DISTINCT ORD.CUSTOMER_ID) AS NUMBER_OF_CUSTOMER
FROM PRODUCT_T PT
JOIN ORDER_T ORD
ON PT.PRODUCT_ID = ORD.PRODUCT_ID
GROUP BY VEHICLE_MAKER
ORDER BY NUMBER_OF_CUSTOMER DESC
LIMIT 5;




-- Question 3:
-- Which is the most preferred vehicle maker in each state? 
-- Hint: Use the window function RANK() to rank based on the count of customers for each state and vehicle maker. 
-- After ranking, take the vehicle maker whose rank is 1.

SELECT STATE, VEHICLE_MAKER, CUSTOMER_COUNT, RNK
FROM(
	SELECT
		CT.STATE AS STATE,
		PT.VEHICLE_MAKER AS VEHICLE_MAKER,
		COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMER_COUNT,
		RANK() OVER (PARTITION BY CT.STATE ORDER BY COUNT(DISTINCT CUSTOMER_ID) DESC) AS RNK
	FROM CUSTOMER_T CT
	JOIN ORDER_T OT
	USING (CUSTOMER_ID)
	JOIN PRODUCT_T PT
	USING (PRODUCT_ID)
	GROUP BY 1,2) AS RANKED_TABLE
 WHERE RNK = 1;
 
-- Alternative Solution 
SELECT         
	cust.state,         
	pro.vehicle_maker     
FROM product_t AS pro      
INNER JOIN order_t AS ord         
	ON pro.product_id = ord.product_id     
INNER JOIN customer_t AS cust         
	ON ord.customer_id = cust.customer_id     
GROUP BY 1,2     
ORDER BY COUNT(cust.customer_id) DESC;



-- Question 4:
-- Find the overall average rating given by the customers. What is the average rating in each quarter? [5 marks]
-- Consider the following mapping for ratings:
-- “Very Bad”: 1, “Bad”: 2, “Okay”: 3, “Good”: 4, “Very Good”: 5
-- Hint: Use subquery and assign numerical values to feedback categories using a CASE statement. 
-- Then, calculate the average feedback count per quarter. Use a subquery to convert feedback 
-- into numerical values and group by quarter_number to compute the average.

-- PART 1
WITH RATING_TABLE AS (
                        SELECT
                            QUARTER_NUMBER,
                            CASE
                                WHEN CUSTOMER_FEEDBACK = 'Very Bad' THEN 1
                                WHEN CUSTOMER_FEEDBACK = 'Bad' THEN 2
                                WHEN CUSTOMER_FEEDBACK = 'Okay' THEN 3
                                WHEN CUSTOMER_FEEDBACK = 'Good' THEN 4
                                WHEN CUSTOMER_FEEDBACK = 'Very Good' THEN 5
                            END AS Rating
                        FROM ORDER_T
                )
SELECT DISTINCT
AVG(Rating) AS OVERALL_AVG
FROM RATING_TABLE;


-- PART 2
WITH RATING_TABLE AS (
                        SELECT
                            QUARTER_NUMBER,
                            CASE
                                WHEN CUSTOMER_FEEDBACK = 'Very Bad' THEN 1
                                WHEN CUSTOMER_FEEDBACK = 'Bad' THEN 2
                                WHEN CUSTOMER_FEEDBACK = 'Okay' THEN 3
                                WHEN CUSTOMER_FEEDBACK = 'Good' THEN 4
                                WHEN CUSTOMER_FEEDBACK = 'Very Good' THEN 5
                            END AS Rating
                        FROM ORDER_T
                      )
SELECT DISTINCT
                QUARTER_NUMBER,
                AVG(Rating) OVER(PARTITION BY QUARTER_NUMBER) AS QUARTERLY_AVG
FROM RATING_TABLE
ORDER BY QUARTER_NUMBER;

-- Question 5:
-- Find the percentage distribution of feedback from the customers. Are customers getting more dissatisfied over time? [5 marks]
-- Hint: Calculate the percentage of each feedback type by using conditional aggregation. 
-- For each feedback category, use a CASE statement to count the occurrences and then divide by the total count of feedback for the quarter, multiplied by 100 to get the percentage. 
-- Finally, group by quarter_number and order the results to reflect the correct sequence.

SELECT 
	QUARTER_NUMBER,
    ROUND(COUNT(CASE WHEN CUSTOMER_FEEDBACK = 'Very Good' THEN 1 END) * 100.0 / COUNT(*), 2) AS PCT_VERY_GOOD,
	ROUND(COUNT(CASE WHEN CUSTOMER_FEEDBACK = 'Good' Then 1 END) * 100 / COUNT(*), 2) AS PCT_GOOD,
    ROUND(COUNT(CASE WHEN CUSTOMER_FEEDBACK = 'Okay' Then 1 END) * 100 / COUNT(*), 2) AS PCT_OKAY,
    ROUND(COUNT(CASE WHEN CUSTOMER_FEEDBACK = 'Bad' Then 1 END) * 100 / COUNT(*), 2) AS PCT_BAD,
    ROUND(COUNT(CASE WHEN CUSTOMER_FEEDBACK = 'Very Bad' Then 1 END) * 100 / COUNT(*), 2) AS PCT_VERY_BAD
FROM ORDER_T
GROUP BY QUARTER_NUMBER
ORDER BY QUARTER_NUMBER;

-- Question 6:
-- What is the trend of the number of orders by quarter? 
-- Hint: Count the number of orders for each quarter.

SELECT
	QUARTER_NUMBER,
    COUNT(DISTINCT ORDER_ID) AS NUM_OF_ORDERS
FROM ORDER_T
GROUP BY QUARTER_NUMBER
ORDER BY QUARTER_NUMBER;



-- Question 7:
-- Calculate the net revenue generated by the company. What is the quarter-over-quarter % change in net revenue? [5 marks]
-- Hint: Net Revenue is the amount obtained by multiplying the number of units sold by the price after deducting the discounts applied.
-- Quarter over Quarter percentage change in revenue means what is the change in revenue from the subsequent quarter to the previous quarter in percentage.
-- Calculate the revenue for each quarter by summing the quantity of product and the discounted vehicle price. Use the LAG function to get the revenue from the previous quarter, and then compute the quarter-over-quarter percentage change based on the current and previous revenue values.
-- Ensure the results are ordered by quarter_number to maintain the correct sequence.


-- PART 1
SELECT 
    ROUND(SUM(VEHICLE_PRICE * (1 - (DISCOUNT / 100)) * QUANTITY), 2) AS REVENUE
FROM ORDER_T;
	
SELECT     
	ROUND(SUM(revenue),2) AS total_revenue 
FROM (SELECT         
		quarter_number,         
		SUM(quantity * (vehicle_price - ((discount / 100) * vehicle_price)))  AS revenue     
		FROM order_t )  AS quarterly_revenue_summary ; 
        


-- PART 2
SELECT 
	QUARTER_NUMBER,
    REVENUE,
    PREVIOUS_QUART_REV,
    ROUND(((REVENUE - PREVIOUS_QUART_REV) / PREVIOUS_QUART_REV) * 100, 2) AS QUART_OVER_QUART_CHANGE
FROM (
	SELECT
    QUARTER_NUMBER,
    SUM(VEHICLE_PRICE * (1 - (DISCOUNT / 100)) * QUANTITY) AS REVENUE,
    LAG(SUM(VEHICLE_PRICE * (1 - (DISCOUNT / 100)) * QUANTITY)) 
        OVER (ORDER BY QUARTER_NUMBER) AS PREVIOUS_QUART_REV
	FROM ORDER_T
	GROUP BY QUARTER_NUMBER
    ) SUB
ORDER BY QUARTER_NUMBER;



-- Alternative Solution
SELECT     
	quarter_number,     
	revenue,     
	LAG(revenue) OVER(ORDER BY quarter_number) AS previous_revenue,     
	(revenue - LAG(revenue) OVER(ORDER BY quarter_number)) / LAG(revenue)  OVER(ORDER BY quarter_number) AS qoq_perc_change 
	FROM (SELECT         
			quarter_number,         
			SUM(quantity * (vehicle_price - ((discount / 100) * vehicle_price)))  AS revenue     
		 FROM order_t     
		 GROUP BY quarter_number) AS subquery 
ORDER BY quarter_number;





-- Question 8:
-- What is the trend of net revenue and orders by quarters? 
-- Hint: Find out the sum of net revenue and count the number of orders for each quarter.

SELECT
     QUARTER_NUMBER,
     COUNT(DISTINCT ORDER_ID) AS NUMBER_OF_ORDER,
     ROUND(SUM(VEHICLE_PRICE * (1 - (DISCOUNT / 100)) * QUANTITY), 2) AS REVENUE
FROM ORDER_T
GROUP BY QUARTER_NUMBER;


-- Alternative Solution
SELECT         
	quarter_number,       
    ROUND(SUM(quantity * (vehicle_price -  ((discount/100)*vehicle_Price))),2) revenue,       
    COUNT(order_id) total_orders 
FROM order_t 
GROUP BY quarter_number 
ORDER BY 1;



-- Question 9:
-- What is the average discount offered for different types of credit cards? 
-- Hint: Find out the average of discount for each credit card type.

SELECT 
	C.CREDIT_CARD_TYPE,
    ROUND(AVG(O.DISCOUNT), 2) AVERAGE_DISCOUNT
FROM CUSTOMER_T C
INNER JOIN ORDER_T O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY 1
ORDER BY 2 DESC;



-- Question 10:
-- What is the average time taken to ship the placed orders for each quarter? 
-- Hint: Please use the julianday function instead of the DATEDIFF function to find the difference between the ship date and the order date.
-- The SQL Playground Editor is built on the SQLite platform, which doesn’t support the DATEDIFF function available in MySQL

SELECT
	QUARTER_NUMBER,
    ROUND(AVG(DATEDIFF(SHIP_DATE, ORDER_DATE)),2) AS SHIPPING_DURATION
FROM ORDER_T
GROUP BY 1
ORDER BY 1;
