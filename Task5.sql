--завдання 5
WITH facebook_google_ads_basic_daily AS (SELECT DISTINCT ad_date
, fa.adset_name
FROM public.facebook_ads_basic_daily fabd
LEFT JOIN public.facebook_campaign fc
ON fabd.campaign_id = fc.campaign_id 
LEFT JOIN public.facebook_adset fa
ON fabd.adset_id = fa.adset_id
WHERE ad_date IS NOT NULL AND adset_name IS NOT null
UNION ALL 
SELECT  ad_date
, adset_name
FROM public.google_ads_basic_daily
WHERE ad_date IS NOT NULL AND adset_name IS NOT null),
adset_days as ( SELECT ad_date
, adset_name
FROM facebook_google_ads_basic_daily
GROUP BY ad_date 
, adset_name),
numbered AS (SELECT ad_date 
, adset_name
, row_number() over(PARTITION BY adset_name ORDER BY ad_date) AS rank
FROM adset_days),
grouped AS (SELECT adset_name
, min(ad_date) AS start_date
, max(ad_date) AS end_date
, count(*) AS days_in_row
FROM ( SELECT adset_name
, ad_date
, ad_date - RANK * INTERVAL '1 days' AS grp
FROM numbered ) AS sub
GROUP BY adset_name, grp)
SELECT adset_name
, days_in_row
FROM grouped 
ORDER BY days_in_row DESC
LIMIT 1;