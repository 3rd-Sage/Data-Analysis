SELECT * 
FROM Projects..athlete_events;

-- find the total number of summer olympic games.
-- find for each sport, how many games where they played in
-- compare 1 and 2 results


WITH t1 as (
    select count(distinct Games) as total_summer_games
    from Projects..athlete_events
    WHERE Season = 'summer' 
    
),
-- select *
-- from t1;

t2 as (
    select distinct(Sport), Games 
    FROM Projects..athlete_events
),

-- select Sport, Games
-- from t2 
-- order by 2,1

t3 AS (
    select Sport, count(Games) as no_of_Games
    from t2
    GROUP by Sport
)

SELECT *
from t3
JOIN t1
    on t1.total_summer_games = t3.no_of_Games
order by no_of_Games DESC;

select count(distinct Team)
FROM Projects..athlete_events

-- Fetch 5 atheletes who has won the most gold medals 
select *
FROM Projects..athlete_events;

SELECT Name, COUNT(Medal) as Total_Medal
FROM Projects..athlete_events
WHERE Medal = 'Gold'
GROUP by Name;

with A as (
    SELECT Name, COUNT(Medal) as Total_Medal
    from Projects..athlete_events
    WHERE Medal = 'Gold'
    GROUP BY Name
),
-- dense_rank
B as (
SELECT *,Dense_RANK() over(ORDER by Total_Medal DESC) as rnk
FROM A
)
SELECT *
FROM B 
where rnk <= 5;
-- ORDER by Total_Medal DESC
-- how to rank records in sql

-- List total Gold, silver and bronze medals won by each country in desc first attempt on city and second was on country
SELECT *
FROM Projects..athlete_events;

with A as(
select city, Count(Medal) as No_Gold_Medal
FROM Projects..athlete_events
WHERE Medal = 'Gold'
GROUP by City
-- order by No_Gold_Medal desc
),

B as (
    select city, Count(Medal) as No_Silver_Medal
    FROM Projects..athlete_events
    WHERE Medal = 'Silver'
    GROUP by City
    -- order by No_Silver_Medal desc
),

C as (
    select city, Count(Medal) as No_Bronze_Medal
    FROM Projects..athlete_events
    WHERE Medal = 'Bronze'
    GROUP by City
    -- order by No_Bronze_Medal desc
)
SELECT C.City, No_Gold_Medal, No_Silver_Medal, No_Bronze_Medal
FROM C
JOIN B
    ON C.City = B.City
JOIN A
    ON C.City = A.City
order by 2 desc;

-- second on country
WITH C as (
select region, COUNT(Medal) as Gold_Medals
from Projects..athlete_events AE
JOIN Projects..country_definitions CD
    on AE.NOC = CD.NOC
WHERE Medal = 'Gold'
GROUP by region, Medal
-- ORDER by Gold_Medals desc
),
B as (
    select region, COUNT(Medal) as Silver_Medals
    from Projects..athlete_events AE
    JOIN Projects..country_definitions CD
        on AE.NOC = CD.NOC
    WHERE Medal = 'Silver'
    Group by region
),
A as (
    select region, COUNT(Medal) as Bronze_Medals
    from Projects..athlete_events AE
    JOIN Projects..country_definitions CD
        on AE.NOC = CD.NOC
    WHERE Medal = 'Bronze'
    Group by region
)
select A.region, Gold_Medals, Silver_Medals, Bronze_Medals,
    CASE
        when Gold_Medals = 'NA' then 0
        else Gold_Medals
    end,
    case
        when Silver_Medals = 'NA' then 0
        else Silver_Medals
    end,
    case
        when Bronze_Medals = 'NA' then 0
        else Bronze_Medals
    end  
    
from A
JOIN B
    ON B.region = A.region
JOIN C
    ON C.region = A.region
ORDER BY 2  DESC;

-- solution form success

WITH a as (
    select d.region,
    CASE WHEN Medal = 'Gold' then 1 else 0 end as gold,
    case when Medal = 'Silver' then 1 else 0 end as silver,
    case when Medal = 'Bronze' then 1 else 0 end  as Bronze

    from Projects..athlete_events e
     join Projects..country_definitions d
        ON e.NOC = d.NOC 
)
select region, sum(gold) as gold, sum(silver) as silver, sum(Bronze) as bronze
from a 
group by region
order by 2 desc;




-- which country won the max medals from each olympic games
WITH A as (
select Games,region,
CASE 
    WHEN Medal = 'Gold' then 1 else 0
END as Gold,
CASE 
    WHEN Medal = 'Silver' then 1 else 0
END as Silver,
CASE 
    WHEN Medal = 'Bronze' then 1 else 0
END as Bronze
FROM Projects..athlete_events AE 
JOIN Projects..country_definitions CD 
    ON AE.NOC = CD.NOC 
)

select Games, concat(region, ' - ', sum(Gold)) as Gold, CONCAT(region, ' - ', SUM(Silver)) as Silver, concat(region, ' - ', SUM(Bronze)) as Bronze
from A
group by Games, region
order by Games, Gold 

