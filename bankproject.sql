drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup (userid, gold_signup_date)
VALUES (1, '2017-09-22'), (3, '2017-04-21');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users 
VALUES (1, '2014-09-02'), (2, '2015-01-15'), (3, '2014-04-11');


drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales (userid, created_date, product_id)
VALUES
  (1, '2017-04-19', 2),
  (3, '2019-12-18', 1),
  (2, '2020-07-20', 3),
  (1, '2019-10-23', 2),
  (1, '2018-03-19', 3),
  (3, '2016-12-20', 2),
  (1, '2016-11-09', 1),
  (1, '2016-05-20', 3),
  (2, '2017-09-24', 1),
  (1, '2017-03-11', 2),
  (1, '2016-03-11', 1),
  (3, '2016-11-10', 1),
  (3, '2017-12-07', 2),
  (3, '2016-12-15', 2),
  (2, '2017-11-08', 2),
  (2, '2018-09-10', 3);



drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

*/ 1. What is the total amount each customer spent on zomato? */

select a.userid,sum(b.price) total_amt_spent from sales a inner join product b on a.product_id = b.product_id
group by a.userid;
 */ 2. How many days has each customer visited zomato ? */
 
  select userid , count(distinct created_date) distinct_days from sales group by userid;
   */ 3. What was the first product  purchased by each customer  */
    SELECT *
FROM (
  SELECT *, RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk
  FROM sales
) AS subquery
WHERE rnk = 1;

*/ 4. What is the most purchaseditem on the menu and how many times was it purchased by all customer ? */

SELECT product_id, COUNT(*) AS purchase_count
FROM sales
GROUP BY product_id
ORDER BY purchase_count DESC
LIMIT 1;


*/ 5 which item was the most popular for each_customer ?
SELECT userid, product_id, COUNT(*) AS purchase_count
FROM sales
GROUP BY userid, product_id
HAVING COUNT(*) = (
  SELECT MAX(count)
  FROM (
    SELECT userid, COUNT(*) AS count
    FROM sales
    GROUP BY userid, product_id
  ) AS subquery
  WHERE subquery.userid = sales.userid
  GROUP BY userid
)
ORDER BY userid;

*/ 6 Which item was purchased first by the customer after they became a member ?

select * from 
(
select c.*,rank() over (partition by userid order by created_date) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join 
goldusers_signup b on a.userid = b.userid and created_date >= gold_signup_date) c)d where rnk=1;

*/ 7. Which item was purchased just before the customer become a member ?

select * from 
(
select c.*,rank() over (partition by userid order by created_date desc) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join 
goldusers_signup b on a.userid = b.userid and created_date <= gold_signup_date) c)d where rnk=1;

*/ 8. What is the total orders and amount spent for each member before they become a member  ?

select userid, count(created_date) order_purchased,sum(price) total_amt_spent from
(select c.*,d.price from 
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join 
goldusers_signup b on a.userid = b.userid and created_date <= gold_signup_date) c inner join product d on c.product_id = d.product_id) e
group by userid;

*/ 9. If buying each product generates points for eg 5rs = 2 zomato point and each product has different purchasing points 
for eg for p1 5rs=1 zomato point ,for p2 10rs = 5zomato point and p3 5rs = 1 zomato point 2rs = 1zomato point 
, calcuate points collected by each customers and for which product most points have been given till now.

SELECT userid, SUM(total_points * 2.5) AS total_earned
FROM
(
  SELECT e.*, amt/points AS total_points
  FROM
  (
    SELECT d.*, CASE 
                  WHEN product_id = 1 THEN 5
                  WHEN product_id = 2 THEN 2
                  WHEN product_id = 3 THEN 5
                  ELSE 0
                END AS points
    FROM
    (
      SELECT c.userid, c.product_id, SUM(price) AS amt
      FROM
      (
        SELECT a.*, b.price
        FROM sales a
        INNER JOIN product b ON a.product_id = b.product_id
      ) c
      GROUP BY userid, product_id
    ) d
  ) e
) f
GROUP BY userid;


SELECT *, RANK() OVER (ORDER BY total_earned DESC) AS rnk
FROM (
  SELECT product_id, SUM(total_point) AS total_earned
  FROM (
    SELECT e.*, amt/points AS total_point
    FROM (
      SELECT d.*, CASE
                    WHEN product_id = 1 THEN 5
                    WHEN product_id = 2 THEN 2
                    WHEN product_id = 3 THEN 5
                    ELSE 0
                  END AS points
      FROM (
        SELECT c.userid, c.product_id, SUM(price) AS amt
        FROM (
          SELECT a.*, b.price
          FROM sales a
          INNER JOIN product b ON a.product_id = b.product_id
        ) c
        GROUP BY userid, product_id
      ) d
    ) e
  ) f
  GROUP BY product_id
) subquery;


*/ 10 rank all the transaction of the customers.
select * from sales;
SELECT *,
       RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk
FROM sales;


11. rank all the transactions for each member whenever they are a zomato gold member for every transaction mark as na. */

 SELECT c.*,
       CASE WHEN gold_signup_date IS NOT NULL THEN 'na' ELSE RANK() OVER (PARTITION BY userid ORDER BY created_date DESC) END AS rnk
FROM (
  SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date
  FROM sales a
  LEFT JOIN goldusers_signup b ON a.userid = b.userid AND a.created_date >= b.gold_signup_date
) c;


*/ Thank you*/ 

*/ Zomato Project in SQL is completed. */



