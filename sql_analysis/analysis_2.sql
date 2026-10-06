-- ====================================================================================
-- QUESTION 1 — Which advertising platforms deliver the strongest overall performance?
-- ====================================================================================
SELECT
    platform,
    COUNT(*) AS campaigns,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    SUM(conversions) AS conversions,
    ROUND(SUM(ad_spend), 2) AS ad_spend,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(SUM(clicks) * 100.0 / SUM(impressions), 2) AS ctr,
    ROUND(SUM(ad_spend) / NULLIF(SUM(clicks), 0), 2) AS cpc,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS conversion_rate,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas

FROM advertising_campaigns
WHERE platform NOT IN ('TikTok', 'Twitter')
GROUP BY platform
ORDER BY roas DESC;

-- ===========================================================================================================================
-- KEY FINDING: Facebook showed the strongest overall efficiency, with the lowest CPC (1.75), lowest CPA (41.12), 
-- and highest ROAS (10.39×). Google Ads and LinkedIn had the same conversion rate (4.99%), but LinkedIn had a much 
-- higher CPA (131.11) and lower ROAS (3.30×), showing that conversion rate alone does not determine campaign profitability.
-- ===========================================================================================================================

-- ================================================================================================
-- QUESTION 2 — Which campaign objectives are associated with better conversion and profitability?
-- ================================================================================================
SELECT
    campaign_objective,
    COUNT(*) AS campaigns,
    SUM(conversions) AS conversions,
    ROUND(SUM(ad_spend), 2) AS ad_spend,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(profit), 2) AS profit,

    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0),2) AS ctr,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS conversion_rate,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas

FROM advertising_campaigns
WHERE platform NOT IN ('TikTok', 'Twitter')
GROUP BY campaign_objective
ORDER BY roas DESC;

-- ============================================================================================================================
-- KEY FINDING: Conversion campaigns showed the strongest overall efficiency, with the highest conversion rate (5.87%), 
-- lowest CPA (58.66), and highest ROAS (7.32×). Brand Awareness had the lowest conversion rate (2.61%), highest CPA (125.07), 
-- and lowest ROAS (3.53×), showing a clear difference in downstream efficiency across campaign objectives.
-- ============================================================================================================================

-- ================================================================================================
-- QUESTION 3 — Does higher purchase intent correspond to better campaign outcomes?
-- ================================================================================================
SELECT
    purchase_intent_score,
    COUNT(*) AS campaigns,
    SUM(conversions) AS conversions,
    ROUND(SUM(ad_spend), 2) AS ad_spend,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS conversion_rate,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas

FROM advertising_campaigns
WHERE platform NOT IN ('TikTok', 'Twitter')
GROUP BY purchase_intent_score
ORDER BY
    CASE purchase_intent_score
        WHEN 'High' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Low' THEN 3
    END;

-- =======================================================================================================================================
-- KEY FINDING: Higher purchase intent was strongly associated with better campaign performance. High-intent audiences had an 
-- 8.31% conversion rate, the lowest CPA (38.90), and the highest ROAS (11.06×), while low-intent audiences had a 2.43% conversion rate, 
-- CPA of 143.37, and ROAS of 3.17×.
-- =======================================================================================================================================

-- ==============================================================================
-- QUESTION 4 — What separates profitable campaigns from loss-making campaigns?
-- ==============================================================================
SELECT
    CASE
        WHEN profit >= 0 THEN 'Profitable'
        ELSE 'Loss-Making'
    END AS campaign_result,

    COUNT(*) AS campaigns,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0), 2) AS ctr,
    ROUND(SUM(conversions) * 100.0 / NULLIF(SUM(clicks), 0), 2) AS conversion_rate,
    ROUND(SUM(ad_spend) / NULLIF(SUM(conversions), 0), 2) AS cpa,
    ROUND(SUM(revenue) / NULLIF(SUM(ad_spend), 0), 2) AS roas

FROM advertising_campaigns
WHERE platform NOT IN ('TikTok', 'Twitter')
GROUP BY campaign_result;
  
-- =====================================================================================================================================================
-- KEY FINDING: Profitable campaigns showed much stronger funnel efficiency than loss-making campaigns, with a higher conversion rate (5.17% vs 1.21%), 
-- much lower CPA (59.60 vs 423.77), and substantially higher ROAS (7.47× vs 0.55×). Loss-making campaigns generated weaker engagement and 
-- conversion performance, resulting in negative average profit of 1,993.26 per campaign.
-- =====================================================================================================================================================

-- ================================================================================================
-- QUESTION 5 — Which ad formats generate stronger click-through rates across different platforms?
-- ================================================================================================
SELECT
    platform, creative_format,
    COUNT(*) AS campaigns,
    SUM(impressions) AS impressions,
    SUM(clicks) AS clicks,
    ROUND(SUM(clicks) * 100.0 / NULLIF(SUM(impressions), 0), 2) AS ctr
    
FROM advertising_campaigns
WHERE platform NOT IN ('TikTok', 'Twitter')
GROUP BY platform, creative_format
ORDER BY platform, ctr DESC;

-- =====================================================================================================================================================
-- KEY FINDING: Video ads delivered consistently strong CTR across all four platforms, while Text ads had the lowest CTR on every platform. 
-- Interactive ads performed particularly well on Facebook, reaching a 3.09% CTR.
-- =====================================================================================================================================================