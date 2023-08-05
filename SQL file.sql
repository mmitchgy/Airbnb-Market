-- AIRBNB LISTINGS

-- Airbnb listings to meet the high demand for temporary lodging for anywhere between a 
-- few nights to many months, guests and hosts have used Airbnb to expand on traveling 
-- possibilities and present more unique, personalized way of experiencing the world.

-- Data Source -- https://www.kaggle.com/code/ebrahimelgazar/exploring-nyc-airbnb-market

-- Data assessment
select * from airbnb_last_review;
select * from airbnb_price;
select * from airbnb_room_type;
--

-- data cleaning
-- airbnb_last_review table
UPDATE airbnb_last_review
SET last_review = STR_TO_DATE(last_review, '%M %d %Y');

-- airbnb_price table
UPDATE airbnb_price
SET price = REPLACE(price, 'dollars', '')
WHERE price LIKE '%dollars';
-- 
-- airbnb_room_type
UPDATE airbnb_room_type
Set room_type= lower(room_type);
--
-- Questions --
-- 1) What is the average price, per night, of an Airbnb listing in NYC?
-- 2) Average Price of apartment in each neighborhood
-- 3) Most common room types
-- 4) Busiest host
-- 5) most expensive listing in each neighborhood.
-- 6) listing with higher price than the average in their neighborhood
-- 7) listing with the same description in different neighborhood

-- 1)
select round(AVG(price),2) AS avg_price
FROM airbnb_price;
-- 2)
SELECT nbhood_full, ROUND(AVG(price), 2) AS average_price
FROM airbnb_price
GROUP BY nbhood_full;
-- 3)
SELECT room_type, COUNT(*) AS room_count
FROM airbnb_room_type
GROUP BY 1
order by 2 DESC;
-- 4)
SELECT host_name, COUNT(*) AS num_listings
FROM airbnb_last_review
GROUP BY host_name
ORDER BY num_listings DESC
LIMIT 5;
-- 5)
SELECT listing_id, nbhood_full, MAX(price)
FROM airbnb_price
GROUP BY 1,2;
-- 6)
SELECT listing_id, nbhood_full, price
FROM airbnb_price
WHERE price > (
SELECT AVG(price) AS average_price
FROM airbnb_price);
-- 7) listing with the same description in different neighborhood
select description, count(distinct nbhood_full) AS num_neighborhood
from airbnb_room_type arb
join airbnb_price arbl
on arb.listing_id = arbl.listing_id
group by 1
HAVING num_neighborhood > 1;
--
-- 3) how many adverts are for private rooms?
select count(*)
from airbnb_room_type
where room_type='private room';
-- Answer they are 11353 private rooms



