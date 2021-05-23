USE webtraffic;

### PERCENT_RANK()
SELECT web.website_name AS WEBSITE,
category as PAGE_CATEGORIES,
wstat.no_users AS NO_OF_USERS,
wstat.ad_impressions AS ADS_SHOWN,
wstat.ad_click AS ADS_CLICK,
FORMAT(PERCENT_RANK() OVER
(PARTITION BY wstat.website_id ORDER BY wstat.ad_click DESC), 2) AS ADCLICK_PERC_RANK
FROM webstats wstat
INNER JOIN website web
ON wstat.website_id = web.website_id
INNER JOIN pages
ON wstat.page_id = pages.page_id
GROUP BY WEBSITE, PAGE_CATEGORIES;

### CUME_DIST()
SELECT web.website_name AS WEBSITE,
ads.ad_source_name AS AD_SOURCE,
FORMAT(wstat.ad_click * ads.pay_per_click,2) AS REVENUE,
FORMAT(CUME_DIST() OVER(PARTITION BY wstat.website_id
ORDER BY (wstat.ad_click*ads.pay_per_click) DESC), 2) AS ADCLICK_CUME_DIST
FROM webstats wstat
INNER JOIN ad_source ads
ON wstat.ad_source_id = ads.ad_source_id
INNER JOIN website web
ON wstat.website_id = web.website_id
GROUP BY WEBSITE, AD_SOURCE;

### NTILE()
SELECT web.region AS REGION,
web.website_name AS WEBSITE,
pag.target_gender AS GENDER,
pag.target_age AS TARGET_AGE,
wstat.no_users AS NO_OF_USERS,
NTILE(4) OVER
(PARTITION BY region ORDER BY target_age ASC) AS USER_BINS
FROM webstats wstat
INNER JOIN website web 
ON wstat.website_id = web.website_id
INNER JOIN pages pag 
ON wstat.page_id = pag.page_id
GROUP BY REGION, WEBSITE, GENDER, TARGET_AGE;