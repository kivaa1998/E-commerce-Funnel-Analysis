--завдання 4
WITH facebook_google_ads AS (SELECT ad_date
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
monthly_reach AS (SELECT campaign_name 
, date_trunc('month', ad_date)::date AS month_start
, sum(reach) AS monthly_reach
FROM facebook_google_ads
WHERE ad_date IS NOT null
GROUP BY campaign_name
, month_start),
reach_w_growth AS (SELECT campaign_name 
, month_start 
, monthly_reach 
, monthly_reach - LAG(monthly_reach) OVER (PARTITION BY campaign_name ORDER BY month_start) AS reach_growth
FROM monthly_reach)
SELECT campaign_name
, max(reach_growth) AS max_growth
FROM reach_w_growth
GROUP BY campaign_name
ORDER BY max_growth DESC
LIMIT 1;