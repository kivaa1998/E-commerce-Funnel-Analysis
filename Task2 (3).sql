--завдання 2
WITH facebook_google_ads_basic_daily AS (SELECT ad_date
, spend
, impressions 
, reach 
, leads 
, value
, campaign_name
, fa.adset_name
, 'facebook' AS source
FROM public.facebook_ads_basic_daily fabd
LEFT JOIN public.facebook_campaign fc
ON fabd.campaign_id = fc.campaign_id 
LEFT JOIN public.facebook_adset fa
ON fabd.adset_id = fa.adset_id
UNION ALL 
SELECT ad_date
, spend
, impressions 
, reach 
, leads 
, value
, campaign_name
, adset_name
, 'google' AS source
FROM public.google_ads_basic_daily),
daily_totals AS (SELECT ad_date
, campaign_name
, sum(spend) AS total_spend
, sum(value) AS total_value
, (ROUND(CAST(SUM(value) AS NUMERIC), 0) - ROUND(CAST(SUM(spend) AS NUMERIC), 0)) / NULLIF(SUM(spend), 0) * 100 AS ROMI
FROM facebook_google_ads_basic_daily
WHERE ad_date IS NOT null 
GROUP BY ad_date
, campaign_name),
top_5_romi AS (SELECT ad_date
, romi
FROM daily_totals
WHERE romi IS NOT NULL
ORDER BY romi DESC
LIMIT 5)
SELECT * FROM top_5_romi;