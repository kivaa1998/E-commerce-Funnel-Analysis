--завдання 1
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
FROM public.google_ads_basic_daily)
SELECT ad_date
, 'facebook' AS source
, 'google' AS source
, min(spend) AS min_spend
, max(spend) AS max_spend
, round(AVG(spend),2) AS avg_spend
FROM facebook_google_ads_basic_daily fgabd 
WHERE ad_date IS NOT null
GROUP BY ad_date
, SOURCE










