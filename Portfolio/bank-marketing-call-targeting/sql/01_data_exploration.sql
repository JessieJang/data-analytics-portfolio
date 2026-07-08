-- 1. Preview the raw data to understand structure and columns
SELECT * FROM bank LIMIT 30;
	   
-- 2. Baseline conversion rate: overall subscription rate to benchmark segments against
SELECT ROUND(((SELECT COUNT(*) FROM bank WHERE y='yes')*100.0)/
       (SELECT COUNT(*) FROM bank),2) AS percentage;

-- 3. Distribution of clients by job type
SELECT job, COUNT(*) FROM bank GROUP BY job;

