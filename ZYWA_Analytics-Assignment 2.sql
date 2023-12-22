 use zywa;
 /*                Q1       MONTHLY TRANSACTIONS 
     Need how much amount we have processed each month commutative and every month.    */
     select * from 	transactions;
     
     SELECT
transaction_timestamp,
billing_amount,
  SUM(billing_amount) OVER (ORDER BY transaction_timestamp) AS cumulative_amount,
  SUM(billing_amount) OVER () AS total_amount_processed
FROM
 transactions; 
 
 
 
             /*   Q2  Most Popular Products/Services
	Design a SQL query to identify the top 5 most popular products or services based on transaction counts.*/
 SELECT
 merchant_type,
  COUNT(billing_amount) AS transaction_count
FROM
  transactions
GROUP BY
  merchant_type
ORDER BY
  transaction_count DESC
LIMIT 5;


 /*     Q3     Daily Revenue Trend

Formulate a SQL query to visualize the daily revenue trend over time. */

SELECT
  transaction_timestamp,
  SUM(billing_amount) AS daily_revenue
FROM
  transactions
GROUP BY
  transaction_timestamp;
  
/*       Q4   Average Transaction Amount by Product Category:**

Formulate a SQL query to find the average transaction amount for each product category.*/
SELECT
  merchant_type,
  AVG(transaction_amount) AS average_transaction_amount
FROM
  transactions
GROUP BY
  merchant_type;
  
 /*  Q5          Transaction Funnel Analysis:**

Create a SQL query to analyze the transaction funnel, including completed, pending, and cancelled transactions.*/

SELECT
  transaction_status,
  COUNT(*) AS transaction_count
FROM
  transactions
GROUP BY
  transaction_status;
  
  
  
  /*###   Q6 **Monthly Retention Rate:**

Design a SQL query to calculate the Monthly Retention Rate, grouping users into monthly cohorts.*/

CREATE TABLE users (
  user_id INT PRIMARY KEY,
  registration_date DATE
);

INSERT INTO users (user_id, registration_date) VALUES
(1, '2023-01-15'),
(2, '2023-01-20'),
(3, '2023-02-10');

CREATE TABLE user_activity (
  user_id INT,
  activity_date DATE
);

INSERT INTO user_activity (user_id, activity_date) VALUES
(1, '2023-01-15'),
(2, '2023-01-20'),
(1, '2023-02-01'),
(3, '2023-02-10')

;

WITH UserCohorts AS (
  SELECT
    user_id,
    MIN(registration_date) AS cohort_date
  FROM
    users
  GROUP BY
    user_id
)

SELECT
  DATE_FORMAT(UserCohorts.cohort_date, '%Y-%m') AS cohort_month,
  DATE_FORMAT(activity_date, '%Y-%m') AS activity_month,
  COUNT(DISTINCT CASE WHEN activity_date = UserCohorts.cohort_date THEN user_activity.user_id END) AS cohort_size,
  COUNT(DISTINCT user_activity.user_id) AS active_users,
  COUNT(DISTINCT user_activity.user_id) / COUNT(DISTINCT CASE WHEN activity_date = UserCohorts.cohort_date THEN user_activity.user_id END) * 100 AS retention_rate
FROM
  UserCohorts
JOIN
  user_activity
  ON UserCohorts.user_id = user_activity.user_id
GROUP BY
  cohort_month, activity_month
ORDER BY
  cohort_month;
  
 
