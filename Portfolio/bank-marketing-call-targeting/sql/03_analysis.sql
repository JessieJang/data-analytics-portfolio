-- Check balance range to design meaningful brackets
SELECT MIN(balance),MAX(balance) 
FROM bank;

-- Conversion by balance bracket: rises with balance but plateaus around 3k
-- (Mid-High 16.3% vs High 16.3% despite far larger holdings)
SELECT  CASE WHEN balance < 0 THEN 'negative'
			WHEN 0 <= balance AND balance < 500 THEN 'Low'
			WHEN 500 <= balance AND balance < 1000 THEN 'Mid-Low'
			WHEN 1000 <= balance AND balance <3000 THEN 'Mid'
			WHEN 3000 <= balance AND balance <10000 THEN 'Mid-High'
			ELSE 'High' 
			END AS balance_range
			,COUNT(*) AS total,
			SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS yes_count,
			ROUND((SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS conversion_rate
FROM bank
GROUP BY balance_range 
ORDER BY conversion_rate DESC;

-- Conversion by age: U-shaped. Under 30 (17.6%) and 60+ (33.6%) far above
-- the 11.7% baseline; 40-50 bottoms out at 9.1%. Splitting 50+ revealed the
-- surge begins after 60, suggesting retirement status drives the shift.
SELECT  CASE WHEN age < 30 THEN '~30'
			WHEN 30 <= age AND age < 40 THEN '30~40'
			WHEN 40 <= age AND age <50 THEN '40~50'
			WHEN 50 <= age AND age <60 THEN '50~60'
			ELSE '60+' 
			END AS age_range
			,COUNT(*) AS total,
			SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS yes_count,
			ROUND((SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS conversion_rate
FROM bank
GROUP BY age_range
ORDER BY conversion_rate DESC;

-- Tier sizing: conversion by age among NEW clients only (poutcome='unknown').
-- Used to size the call list for Tiers 2-3. Rates differ from the all-client
-- view above (60+ = 27.4% here vs 33.6% overall) because prior-success clients
-- are excluded.
SELECT  CASE WHEN age < 30 THEN '~30'
			WHEN 30 <= age AND age < 40 THEN '30~40'
			WHEN 40 <= age AND age <50 THEN '40~50'
			WHEN 50 <= age AND age <60 THEN '50~60'
			ELSE '60+' 
			END AS age_range
			,COUNT(*) AS total,
			SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS yes_count,
			ROUND((SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS conversion_rate
FROM bank
WHERE poutcome= 'unknown'
GROUP BY age_range
ORDER BY conversion_rate DESC;

-- Conversion by contact attempts: holds near baseline through 3 calls,
-- then drops sharply (4th = 9.0%, 8+ = 4.9%). Supports a 3-attempt cap.
SELECT CASE WHEN campaign <= 7 THEN CAST(campaign AS TEXT)
		ELSE '8+'
		END AS campaign_group,
		COUNT(*) AS total,
		SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS yes_count,
		ROUND((SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS conversion_rate
FROM bank
GROUP BY campaign_group
ORDER BY MIN(campaign);

-- New clients only (poutcome='unknown', 82% of data): age dominates balance.
-- 60+ converts 23-33% regardless of balance; even low-balance 60+ (23.3%)
-- beats high-balance 30-40 (11.6%). Balance still sorts within each age band.
-- Confirms the 60+ effect is independent of prior campaign success.
SELECT CASE WHEN age < 30 THEN '~30'
			WHEN 30 <= age AND age < 40 THEN '30~40'
			WHEN 40 <= age AND age <50 THEN '40~50'
			WHEN 50 <= age AND age <60 THEN '50~60'
			ELSE '60+' 
			END AS age_range,
		CASE WHEN balance < 0 THEN 'negative'
			WHEN 0 <= balance AND balance < 500 THEN 'Low'
			WHEN 500 <= balance AND balance < 1000 THEN 'Mid-Low'
			WHEN 1000 <= balance AND balance <3000 THEN 'Mid'
			WHEN 3000 <= balance AND balance <10000 THEN 'Mid-High'
			ELSE 'High' 
			END AS balance_range,
		COUNT(*) AS total,
		SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END) AS yes_count,
		ROUND((SUM(CASE WHEN y='yes' THEN 1 ELSE 0 END)*100.0)/COUNT(*),2) AS conversion_rate
FROM bank
WHERE poutcome = 'unknown'
GROUP BY age_range, balance_range
ORDER BY conversion_rate DESC ;
