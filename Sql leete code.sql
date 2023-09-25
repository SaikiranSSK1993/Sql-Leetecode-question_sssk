1.Highest salary department wise

select D.dept_name as "department",T.name as "NAME",T.SALARY AS "salary"
from text T
inner join 
department D
on 
T.dept_id=D.dept_id 
where (T.DEPT_ID,T.SALARY) in 
(select dept_id ,max(SALARY) from text group by dept_id);

2.Department top three highest salary 

select b.name as "Department",a.name as "Employee",a.Salary as "Salary" from 
(
  select  departmentId ,name,salary ,dense_rank() over (partition by departmentId order by salary desc) r from Employee  
) a
inner join 
Department  b 
on 
a.departmentId=b.id 
where r <=3;

3.Higher temperature than previous date 

select * from 
weather e,weather y 
where  DATEDIFF(e.recorddate,y.recorddate)=1
and e.temp > y.temp ;

3.181. Employees Earning More Than Their Managers

Employee 

select a.name as "Employee"
from Employee e 
inner join Employee M
on 
e.managerId=M.id
where e.salary>M.salary ;
 

5.
183. Customers Who Never Order

select a.name   as "Customers" from Customers c
left join orders o 
on 
c.id =o.customerId  
where o.customerid is null ;



6.
180. Consecutive Numbers


SELECT DISTINCT a.Num as ConsecutiveNums
FROM Logs a, Logs b, Logs c
WHERE b.Id = a.Id - 1 and c.Id = a.Id - 2 and a.Num = b.Num and c.Num = a.Num;

7.
196. Delete Duplicate Emails

delete a
from person a ,person b 
where a.email=b.email and a.id>b.id;

8.
197. Rising Temperature

select a.id as id from 
weather a ,weather b 
where DATEDIFF(a.recordDate,b.recordDate)=1
and a.temperature > b.temperature ;

9.
511. Game Play Analysis I

Write an SQL query that reports the first login date for each player.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+-------------+
| player_id | first_login |
+-----------+-------------+
| 1         | 2016-03-01  |
| 2         | 2017-06-25  |
| 3         | 2016-03-02  |
+-----------+-------------+


# Write your MySQL query statement below
# as 创建 min(event_date) 列的别名，使可读性更强
# group by 聚合相同的 player_id
select player_id, min(event_date) as first_login
from Activity 
group by player_id

or 

select a.player_id as player_id  ,a.device_id  as device_id  from 
(
  select player_id,device_id,event_date,dense_rank() over (partition by player_id order by event_date asc ) rn 
from  Activity  ) a 
where rn =1 ;

10  
512. Game Play Analysis II

Write a SQL query that reports the device that is first logged in for each player.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+-----------+
| player_id | device_id |
+-----------+-----------+
| 1         | 2         |
| 2         | 3         |
| 3         | 1         |

select a.player_id as player_id  ,a.event_date as first_login from 
(
  select player_id,event_date,dense_rank() over (partition by player_id order by event_date asc ) rn 
from  Activity  ) a 
where rn =1 ;

11
513. Game Play Analysis III

Write an SQL query that reports for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date.
 Check the example for clarity.


Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-05-02 | 6            |
| 1         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Result table:
+-----------+------------+---------------------+
| player_id | event_date | games_played_so_far |
+-----------+------------+---------------------+
| 1         | 2016-03-01 | 5                   |
| 1         | 2016-05-02 | 11                  |
| 1         | 2017-06-25 | 12                  |
| 3         | 2016-03-02 | 0                   |
| 3         | 2018-07-03 | 5                   |


USING WINDOWS FUNCTION 

SELECT PLAYER_ID,event_date,SUM(games_played) OVER (partition BY player_id ORDER BY event_date ) AS games_played_so_far 
FROM Activity 

USING SELF join

select a.player_id AS player_id , a.event_date AS event_date , sum(b.games_played) as games_played_so_far
from activity a join activity b
on a.player_id = b.player_id
where a.event_date >= b.event_date
group by a.player_id, a.event_date
order by a.player_id;

12
550. Game Play Analysis IV

Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, 
rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting 
from their first login date, then divide that number by the total number of players.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
Result table:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+


SELECT ROUND(COUNT(DISTINCT B.PLAYER_ID)/COUNT(DISTINCT A.PLAYER_ID),2) AS FRACTION  FROM 
(
SELECT PLAYER_ID,MIN(EVENT_DATE) AS EVENT_DATE FROM ACTIVITY 
GROUP  BY PLAYER_ID
) A LEFT JOIN ACTIVITY B ON 
A.PLAYER_ID=B.PLAYER_ID AND A.EVENT_DATE+1=B.EVENT_DATE 


595. Big Countries

+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

Write a SQL solution to output 'big countries' name, population and area.

select name ,population, area  from World 
where  area >300000 and population >25000000 ;

596. Classes More Than 5 Students .

Courses table:
+---------+----------+
| student | class    |
+---------+----------+
| A       | Math     |
| B       | English  |
| C       | Math     |
| D       | Biology  |
| E       | Math     |
| F       | Computer |
| G       | Math     |
| H       | Math     |
| I       | Math     |
+---------+----------+
Output: 
+---------+
| class   |
+---------+
| Math    |
+---------+

select class from courses 
group by class
 having count(Distinct student)>= 5 ;

620. Not Boring Movies

SELECT *
FROM cinema
WHERE mod(id,2) <> 0 AND description <> "boring"
ORDER BY rating DESC


627. Swap Salary

# Write your MySQL query statement below
UPDATE salary
SET
    sex = CASE sex
        WHEN 'm' THEN 'f'
        ELSE 'm'
    END;
	
1082: Sales Analysis I

Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.
 
Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+

Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+

Result table:
+-------------+
| seller_id   |
+-------------+
| 1           |
| 3           |
+-------------+

select a.seller_id  
from 
(select seller_id,sum(price) as ABV from sales 
group by seller_id ) a 
where a.ABV=
(select max(b.sums) from 
(select seller_id,sum(price) as sums from sales 
group by seller_id )b )

1083: Sales Analysis II 

| buyer_id    |
+-------------+
| 1           |

SELECT S.buyer_id AS buyer_id
FROM
Sales S 
JOIN Product P 
ON 
S.product_id=P.product_id
GROUP BY buyer_id
HAVING sum(PRODUCT_NAME ='S8') > 0 AND sum(PRODUCT_NAME ='iPhone') = 0 ;

1084: Sales Analysis III

Write a solution to report the products that were only sold in the first quarter of 2019. 
That is, between 2019-01-01 and 2019-03-31 inclusive.


SELECT A.product_id   AS product_id  ,A.product_name AS product_name 
FROM Product A 
INNER JOIN 
Sales  B
ON 
A.product_id=B.product_id 
GROUP BY PRODUCT_ID
having MIN(sale_date)>= "2019-01-01" and  MAX(sale_date)<="2019-03-31"


1179. Reformat Department Table

Example 1:

Input: 
Department table:
+------+---------+-------+
| id   | revenue | month |
+------+---------+-------+
| 1    | 8000    | Jan   |
| 2    | 9000    | Jan   |
| 3    | 10000   | Feb   |
| 1    | 7000    | Feb   |
| 1    | 6000    | Mar   |
+------+---------+-------+
Output: 
+------+-------------+-------------+-------------+-----+-------------+
| id   | Jan_Revenue | Feb_Revenue | Mar_Revenue | ... | Dec_Revenue |
+------+-------------+-------------+-------------+-----+-------------+
| 1    | 8000        | 7000        | 6000        | ... | null        |
| 2    | 9000        | null        | null        | ... | null        |
| 3    | null        | 10000       | null        | ... | null        |
+------+-------------+-------------+-------------+-----+-------------+


select id, 
	sum(case when month = 'jan' then revenue else null end) as Jan_Revenue,
	sum(case when month = 'feb' then revenue else null end) as Feb_Revenue,
	sum(case when month = 'mar' then revenue else null end) as Mar_Revenue,
	sum(case when month = 'apr' then revenue else null end) as Apr_Revenue,
	sum(case when month = 'may' then revenue else null end) as May_Revenue,
	sum(case when month = 'jun' then revenue else null end) as Jun_Revenue,
	sum(case when month = 'jul' then revenue else null end) as Jul_Revenue,
	sum(case when month = 'aug' then revenue else null end) as Aug_Revenue,
	sum(case when month = 'sep' then revenue else null end) as Sep_Revenue,
	sum(case when month = 'oct' then revenue else null end) as Oct_Revenue,
	sum(case when month = 'nov' then revenue else null end) as Nov_Revenue,
	sum(case when month = 'dec' then revenue else null end) as Dec_Revenue
from department
group by id
order by id


----1777: Product's Price for Each Store
Write an SQL query to find the price of each product in each store.

Return the result table in any order.

The query result format is in the following example:

Products table:
+-------------+--------+-------+
| product_id  | store  | price |
+-------------+--------+-------+
| 0           | store1 | 95    |
| 0           | store3 | 105   |
| 0           | store2 | 100   |
| 1           | store1 | 70    |
| 1           | store3 | 80    |
+-------------+--------+-------+
Result table:
+-------------+--------+--------+--------+
| product_id  | store1 | store2 | store3 |
+-------------+--------+--------+--------+
| 0           | 95     | 100    | 105    |
| 1           | 70     | null   | 80     |
+-------------+--------+--------+--------+

select product_id, 
       sum(case when store='store1' then price end) as store1,
       sum(case when store='store2' then price end) as store2,
       sum(case when store='store3' then price end) as store3
from Products
group by product_id

1571: Warehouse Manager [SQL]


Write an SQL query to report how much cubic feet of volume does the inventory occupy in each warehouse.

warehouse_name
volume Return the result table in any order.
The query result format is in the following example.

Warehouse table:
+------------+--------------+-------------+
| name       | product_id   | units       |
+------------+--------------+-------------+
| LCHouse1   | 1            | 1           |
| LCHouse1   | 2            | 10          |
| LCHouse1   | 3            | 5           |
| LCHouse2   | 1            | 2           |
| LCHouse2   | 2            | 2           |
| LCHouse3   | 4            | 1           |
+------------+--------------+-------------+

Products table:
+------------+--------------+------------+----------+-----------+
| product_id | product_name | Width      | Length   | Length    |
+------------+--------------+------------+----------+-----------+
| 1          | LC-TV        | 5          | 50       | 40        |
| 2          | LC-KeyChain  | 5          | 5        | 5         |
| 3          | LC-Phone     | 2          | 10       | 10        |
| 4          | LC-T-Shirt   | 4          | 10       | 20        |
+------------+--------------+------------+----------+-----------+

Result table:
+----------------+------------+
| warehouse_name | volume     | 
+----------------+------------+
| LCHouse1       | 12250      | 
| LCHouse2       | 20250      |
| LCHouse3       | 800        |

SELECT name AS warehouse_name,
       SUM(units*Width*LENGTH*Height) AS volume
FROM Warehouse w
INNER JOIN Products p ON w.product_id = p.product_id
GROUP BY name
ORDER BY NULL;



last one month sales 

select * from tablename where sale_Date>to_date(to_char(select max(sale_date) from t.n)-30,dd-mm-yyyy))
