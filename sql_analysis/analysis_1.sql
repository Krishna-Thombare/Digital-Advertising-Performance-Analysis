CREATE DATABASE advertising_campaign_analysis;
USE advertising_campaign_analysis;

CREATE TABLE advertising_campaigns;

SELECT COUNT(*) AS total_rows
FROM advertising_campaigns;

SELECT COUNT(DISTINCT campaign_id) AS unique_campaigns
FROM advertising_campaigns;

SELECT *
FROM advertising_campaigns
LIMIT 5;

DESCRIBE advertising_campaigns;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign_id) AS unique_campaign_ids
FROM advertising_campaigns;

SELECT COUNT(*) AS null_cpa_rows
FROM advertising_campaigns
WHERE CPA IS NULL;

SELECT 
    COUNT(*) AS zero_conversion_campaigns
FROM advertising_campaigns
WHERE conversions = 0;

SELECT 
    MIN(start_date) AS earliest_date,
    MAX(start_date) AS latest_date
FROM advertising_campaigns;

SELECT
    conversions,
    CPA,
    COUNT(*) AS campaign_count
FROM advertising_campaigns
WHERE conversions = 0
GROUP BY conversions, CPA;

SET SQL_SAFE_UPDATES = 0;

UPDATE advertising_campaigns
SET CPA = NULL
WHERE conversions = 0
  AND campaign_id IS NOT NULL;

SET SQL_SAFE_UPDATES = 1;

SELECT
    MIN(start_date) AS earliest_date,
    MAX(start_date) AS latest_date,
    MIN(impressions) AS min_impressions,
    MAX(impressions) AS max_impressions,
    MIN(clicks) AS min_clicks,
    MAX(clicks) AS max_clicks,
    MIN(conversions) AS min_conversions,
    MAX(conversions) AS max_conversions
FROM advertising_campaigns;

SELECT
    SUM(clicks > impressions) AS clicks_greater_than_impressions,
    SUM(conversions > clicks) AS conversions_greater_than_clicks,
    SUM(ad_spend <= 0) AS invalid_ad_spend,
    SUM(revenue < 0) AS negative_revenue
FROM advertising_campaigns;