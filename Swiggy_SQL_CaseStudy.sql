-- Table Details
SELECT * FROM users;
SELECT * FROM food;
SELECT * FROM delivery_partner;
SELECT * FROM menu;
SELECT * FROM orders;
SELECT * FROM restaurants;
SELECT * FROM order_details;

-- Q1.customers who have never ordered
select name from users 
where  user_id not in (select user_id from orders);

-- Q2.Average price per dish in descending order 
select f.f_name, avg(m.price) as  'Avg Price'
from food f
join menu m
on f.f_id = m.f_id
group by f.f_name
order by avg(m.price) desc;

-- Q3.Top restaurant in terms of no. of orders for month of June 
select r.r_name as 'Restaurant Name', count(order_id) 'No. of orders'
from orders o
join restaurants r on o.r_id=r.r_id
where monthname(date) like 'june'
group by r.r_name
order by count(order_id) desc limit 1;

-- Q4.Restaurants with montly sales(July) > Rs 500   --
select r.r_name as 'Restaurant Name',sum(amount) as 'Revenue'
from orders o 
join restaurants r 
on o.r_id=r.r_id
where monthname(date) like 'july'
group by r.r_name
having sum(amount) > 500;

-- Q5.Show all orders with order details for a particular customer(say Ankit) in a particular date range
select o.order_id,r.r_name,f.f_name from orders o 
join restaurants r 
on r.r_id=o.r_id
join order_details od 
on od.order_id=o.order_id
join food f 
on f.f_id=od.f_id
where user_id =(select user_id from users where name like 'Ankit')
and (date between '2022-05-01' and '2022-06-01'); 

-- Q6.Restaurant with max repeated customers
select r.r_name as 'Restaurant Name',count(user_id) as 'Loyal Customers'
from
    (select r_id,user_id,count(*) as 'visits' 
     from orders
     group by r_id,user_id
     having visits>1) t
join restaurants r on r.r_id=t.r_id
group by r.r_name
order by count(user_id) desc limit 1;

-- Q7.Month over Month revenue growth of swiggy
select Month, ((revenue - prev)/prev)*100 as 'Growth(%)'
from(
With sales as (
select monthname(date) as 'Month',sum(amount) as 'Revenue'
from orders o
join restaurants r on o.r_id=r.r_id
group by monthname(date)
)
select month ,revenue,lag(revenue,1) over(order by revenue) as'prev'
from sales)t

-- Q8.Customer's Favourite Food
with temp as (
	select o.user_id,od.f_id,count(od.f_id) as'frequency'
    from orders o
    join order_details od
    on o.order_id=od.order_id
    group by o.user_id,od.f_id
)
select u.Name,f.f_name as 'Food Item',t1.frequency from 
temp t1 
join users u 
on u.user_id=t1.user_id
join food f
on f.f_id=t1.f_id
where t1.frequency=(
      select max(frequency)
      from temp t2 
      where t2.user_id=t1.user_id
)





