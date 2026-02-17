create database Consumer_sales_Analysis;
use  Consumer_sales_Analysis;
Drop table if exists customer_sales_behavior ;


USE Consumer_sales_Analysis;

SELECT COUNT(*) FROM customer_sales_behavior;
SELECT * FROM customer_sales_behavior ;

#-- 1.How many total customers are present in the customer_sales_behavior table?
select count(*) as total_customers
from customer_sales_behavior;

#--2.What is the average shopping satisfaction of customers?
select round(avg (Shopping_Satisfaction),2) AS avg_satisfaction
from customer_sales_behavior;

#--3.How many customers are frequent buyers?
select count(*) AS frequent_buyers
from customer_sales_behavior
where Frequent_Buyer = 1;

#--4.What percentage of customers are frequent buyers?
SELECT
ROUND((sum(Frequent_Buyer)/count(*))*100,2) AS frequent_buyer_percentage
FROM customer_sales_behavior;

#--5.Which day has the highest number of customers?
SELECT Day_Name, COUNT(*) AS customer_count
FROM customer_sales_behavior
GROUP BY Day_Name
ORDER BY customer_count DESC
LIMIT 1;
#--6.What is the average satisfaction by gender?
SELECT Gender,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Gender;

#--7.Which age group shops the most?
SELECT Age_Group, COUNT(*) AS customer_count
FROM customer_sales_behavior
GROUP BY Age_Group
ORDER BY customer_count DESC;

#--8.Do frequent buyers have higher satisfaction?
SELECT Frequent_Buyer,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Frequent_Buyer;

#--9.Which purchase frequency has the highest satisfaction?
SELECT Purchase_Frequency,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Purchase_Frequency
ORDER BY avg_satisfaction DESC;

#--10.How many customers left reviews?
SELECT COUNT(*) AS reviewers
FROM customer_sales_behavior
WHERE Review_Left = 'yes';

#--11.Does review engagement affect satisfaction?
SELECT Review_Engagement,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Review_Engagement;

#--12.Which purchase category is most popular?
SELECT Purchase_Categories,
COUNT(*) AS total_purchases
FROM customer_sales_behavior
GROUP BY Purchase_Categories
ORDER BY total_purchases DESC
LIMIT 1;

#--13.Identify customers with low satisfaction .
SELECT Customer_ID, Shopping_Satisfaction_Level
FROM customer_sales_behavior
WHERE Shopping_Satisfaction_Level = 'low';

#--14.Which age group has the highest satisfaction?
SELECT Age_Group,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Age_Group
ORDER BY avg_satisfaction DESC;

#--15.How does browsing frequency impact satisfaction?
SELECT Browsing_Frequency,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Browsing_Frequency;

#--16.Rank customers based on review helpfulness.
SELECT Customer_ID,
Review_Helpfulness,
RANK() OVER (ORDER BY Review_Helpfulness DESC) AS rank_position
FROM customer_sales_behavior;

#--17.Create a customer loyalty label.
SELECT Customer_ID,
IF(Frequent_Buyer = 1,'Loyal','Occasional') AS loyalty_status
FROM customer_sales_behavior;

#--18.Find customers with above-average satisfaction.
SELECT *
FROM customer_sales_behavior
WHERE Shopping_Satisfaction >
(SELECT AVG(Shopping_Satisfaction) FROM customer_sales_behavior);

#--19.Find the most satisfied shopping day.
SELECT Day_Name,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Day_Name
ORDER BY avg_satisfaction DESC
LIMIT 1;

#--20.Create a stored procedure to segment customers.
DELIMITER //

CREATE PROCEDURE Customer_Segmentation()
BEGIN
    SELECT Customer_ID,
    CASE
        WHEN Frequent_Buyer = 1 
         AND Shopping_Satisfaction_Level IN ('high','very_high')
        THEN 'High_Value'
        WHEN Frequent_Buyer = 1 
        THEN 'Medium_Value'
        ELSE 'Low_Value'
    END AS customer_segment
    FROM customer_sales_behavior;
END//

DELIMITER ;
CALL Customer_Segmentation();

#--21.Create an executive summary for management.
SELECT
COUNT(*) AS total_customers,
SUM(Frequent_Buyer) AS loyal_customers,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction,
COUNT(DISTINCT Purchase_Categories) AS total_categories
FROM customer_sales_behavior;


#--22.Which combination of Age Group and Gender has the highest average shopping satisfaction?
SELECT Age_Group, Gender,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Age_Group, Gender
ORDER BY avg_satisfaction DESC;

#--23.What is the cart abandonment rate for each purchase frequency?

SELECT Purchase_Frequency,
COUNT(*) AS total_customers,
SUM(CASE 
    WHEN Cart_Completion_Frequency IN ('Rarely','Never') THEN 1 
    ELSE 0 END) AS abandoned_carts,
ROUND(
    (SUM(CASE 
        WHEN Cart_Completion_Frequency IN ('Rarely','Never') THEN 1 
        ELSE 0 END) / COUNT(*)) * 100, 2
) AS abandonment_rate
FROM customer_sales_behavior
GROUP BY Purchase_Frequency;

#--24.Which browsing frequency leads to the highest cart completion?
SELECT Browsing_Frequency,
COUNT(*) AS total_users,
SUM(CASE 
    WHEN Cart_Completion_Frequency IN ('Often','Always') THEN 1 
    ELSE 0 END) AS successful_carts
FROM customer_sales_behavior
GROUP BY Browsing_Frequency
ORDER BY successful_carts DESC;

#--25.Are personalized recommendations improving customer satisfaction?
SELECT Personalized_Recommendation_Frequency,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Personalized_Recommendation_Frequency;

#--26.Which product search method is used by the most satisfied customers?
SELECT Product_Search_Method,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Product_Search_Method
ORDER BY avg_satisfaction DESC;

#--27.Which improvement area is requested most by low-satisfaction customers?
SELECT Improvement_Areas,
COUNT(*) AS request_count
FROM customer_sales_behavior
WHERE Shopping_Satisfaction_Level = 'low'
GROUP BY Improvement_Areas
ORDER BY request_count DESC;

#--28.Which service feature contributes most to high satisfaction?
SELECT Service_Appreciation,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction
FROM customer_sales_behavior
GROUP BY Service_Appreciation
ORDER BY avg_satisfaction DESC;

#--29.Create a satisfaction rank for each age group using window function.
SELECT Age_Group,
ROUND(AVG(Shopping_Satisfaction),2) AS avg_satisfaction,
DENSE_RANK() OVER (
    ORDER BY AVG(Shopping_Satisfaction) DESC
) AS satisfaction_rank
FROM customer_sales_behavior
GROUP BY Age_Group;

#--30.Create a procedure to find high-risk churn customers.
DELIMITER //

CREATE PROCEDURE High_Risk_Customers()
BEGIN
    SELECT Customer_ID,
    Age_Group,
    Purchase_Frequency,
    Shopping_Satisfaction_Level
    FROM customer_sales_behavior
    WHERE Shopping_Satisfaction_Level = 'low'
    AND Frequent_Buyer = 0;
END//

DELIMITER ;


CALL High_Risk_Customers();



