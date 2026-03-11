create table netflix_titles(
show_id text primary key,
type text,
title text,
director text,
cast_members text,
country text,
date_added DATE,
release_year int,
rating text,
duration text,
listed_in text,
description text
);

-- check if the data is loaded
Select * from netflix_titles ;

-- count the total no. of titles
select COUNT(*) from netflix_titles;

-- number of movies and tv shows each
select type, count(*) 
from netflix_titles
group by type;

select distinct type from netflix_titles;


-- top countries producing the content
select country, count(*)
from netflix_titles
group by country
order by count(*) desc;

-- Latest releases
select title, release_year
from netflix_titles
order by release_year desc;

-- list titles added in 2020
select title
from netflix_titles
where EXTRACT(YEAR FROM date_added) = 2020;

-- show whose title contains "Love"
select title 
from netflix_titles
where title like '%Love%';


-- Movies released after 2015
select title, release_year
from netflix_titles 
where release_year>2015 and type='Movie'


-- TV Shows from the United States
select title, country
from netflix_titles
where type='TV Show' and country like '%United States%'


-- Shows added in 2019
select title, date_added
from netflix_titles
where EXTRACT(YEAR from date_added) = 2019


-- Titles with rating PG-13 or TV-MA
select title, rating
from netflix_titles
where rating in ('PG-13','TV-MA');

-- Titles where director is null
select title, director
from netflix_titles
where director is null

-- Earliest and latest release year
select 
		type, 
		MIN(release_year) as earliest_year, 
		MAX(release_year)as latest_year
from netflix_titles
group  by type

-- Count titles per rating
select rating, count(*)
from netflix_titles
group by rating
order by count(*) desc;

-- Average number of seasons for TV Shows
select AVG(
CAST(SPLIT_PART(duration,' ',1) AS INT)
) as AVG_seasons
from netflix_titles
where type='TV Show';

-- Maximum duration among movies
SELECT MAX(
CAST(SPLIT_PART(duration,' ',1) AS INT)
) AS max_movie_duration
FROM netflix_titles
WHERE type = 'Movie';

-- Count titles per release year
select release_year, count(title)
from netflix_titles
group by release_year
order by release_year desc;

-- Count titles per country
select country, count(title)
from netflix_titles
group by country
order by count(title) desc;

-- Count titles per type and rating
select type, rating, count(title)
from netflix_titles
group by type,rating
order by type;

-- Top 5 countries producing the most shows
select country, count(title)
from netflix_titles
where type='TV Show'
group by country
order by count(title) desc limit 5;

-- Count titles in each genre
select listed_in, count(title) 
from netflix_titles
group by listed_in
order by  count(title) desc;

--------------------------------------------------------------
Select * from netflix_titles ;

-- GENRE TABLE --
CREATE TABLE genres AS
SELECT show_id,
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
FROM netflix_titles;

select * from genres;

-- Shows with genre names
select n.title, g.genre
from netflix_titles n
Left join genres g
on n.show_id=g.show_id

-- Count shows per genre
select distinct g.genre, count(n.title) 
from genres g
left join netflix_titles n
on g.show_id=n.show_id
group by g.genre
order by count(n.title) desc;

-- Directors with number of titles
select director, count(title)
from netflix_titles
where director is not null
group by director
order by count(title) desc;

-- CAST MEMBER TABLE --
CREATE TABLE cast_members AS
SELECT show_id,
UNNEST(STRING_TO_ARRAY(cast_members, ',')) AS actor
FROM netflix_titles;

select * from cast_members;

--Top 10 cast members
select actor, count(*)
from cast_members
group by actor
order by count(*) desc limit 10;

-- Combine TV Shows and Movies with category column
select title, 'Movie Category' as category
from netflix_titles
where type='Movie'

UNION

select title, 'TV Category' as category
from netflix_titles
where type='TV Show'

-- Movies vs TV Shows per country
select country, type, count(title)
from netflix_titles
where country is not null
group by type, country
order by country ;

-- Average titles added per month for each release year
select release_year, 
		AVG(monthly_count) 
from (
select release_year, 
		DATE_TRUNC('month',date_added) AS month,
		COUNT(*) AS monthly_count
from netflix_titles
GROUP BY release_year, month
) sub
GROUP by release_year
ORDER by release_year;

-- Titles per rating in last 5 years
select rating, count(title)
from netflix_titles
where release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-5
group by rating
order by count(title) desc;

-- Directors with more than 5 titles
select director, count(title)
from netflix_titles
where director is not null
group by director
having count(title)>5
order by count(title) desc;

-- to list the titles of director
SELECT director, title
FROM netflix_titles
WHERE director IN (
SELECT director
FROM netflix_titles
GROUP BY director
HAVING COUNT(title) > 5
);


-- Top 3 directors per genre
SELECT genre, director, total_titles
FROM (
    SELECT 
        g.genre,
        n.director,
        COUNT(*) AS total_titles,
        RANK() OVER (
            PARTITION BY g.genre
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM netflix_titles n
    JOIN genres g
        ON n.show_id = g.show_id
    WHERE n.director IS NOT NULL
    GROUP BY g.genre, n.director
) ranked
WHERE rnk <= 3;