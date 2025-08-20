--завдання 3
WITH new_table AS (SELECT ad_date
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
weekly_values AS (SELECT  date_trunc('week', ad_date)::date AS week_start
, campaign_name
, sum(value) AS weekly_value
FROM new_table
WHERE ad_date IS NOT null
GROUP BY week_start, campaign_name),
max_value AS (SELECT week_start
, max(weekly_value) AS max_value
FROM weekly_values
GROUP BY week_start
ORDER BY max_value DESC)
SELECT week_start 
, max_value
FROM max_value
LIMIT 1;