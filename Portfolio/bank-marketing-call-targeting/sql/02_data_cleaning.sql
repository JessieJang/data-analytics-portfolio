-- Check poutcome distribution AND conversion rate by value.
-- 'unknown' = new clients (no prior contact), 81.75% of data — cannot be dropped.
-- Prior 'success' converts at 64.7% vs 11.7% baseline — strongest targeting signal.
SELECT poutcome, COUNT(*) AS total,ROUND((COUNT(*)*100.0)/(SELECT COUNT(*) FROM bank),2)AS percentage,
		SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS yes_count,
		ROUND((SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS conversion_rate
FROM bank
GROUP BY poutcome;

-- Test whether contact channel affects conversion, to decide if it's useful for targeting
SELECT contact, COUNT(*)AS total ,
		SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS yes_count,
		ROUND((SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS rate
FROM bank
GROUP BY contact;

-- Note: 'duration' excluded from targeting — data leakage