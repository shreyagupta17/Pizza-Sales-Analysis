-- Q1 Retrieve the total number of orders placed?
select count(order_id) as 'total_orders'
from orders;

-- Q2 Calculate the total revenue generated from pizza sales?
select round(sum(order_details.quantity*pizzas.price),2) as 'total_revenue'
from order_details
join pizzas on order_details.pizza_id=pizzas.pizza_id;

-- Q3 Identify the highest-priced pizza.
select pizza_types.name ,pizzas.price
from pizza_types 
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by price desc
limit 1;


-- Q4 Identify the most common pizza size ordered.
select pizzas.size,count(order_details.pizza_id) as 'total_count'
from pizzas 
join order_details on pizzas.pizza_id=order_details.pizza_id
group by size
order by total_count desc
limit 1;

-- Q5 List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,sum(order_details.quantity) as total_orders
from pizza_types 
join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by name
order by total_orders desc
limit 5;

-- Q6 Join the necessary tables to find the total quantity of each pizza category ordered.
select category,sum(order_details.quantity) as quantity
from pizza_types
join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by category;

-- Q7 Determine the distribution of orders by hour of the day.
select hour(order_time) as hour,count(order_id)
from orders
group by hour;

-- Q8 Join relevant tables to find the category-wise distribution of pizzas.
select pizza_types.category,count(pizza_type_id)
from pizza_types
group by category;

-- Q9 Group the orders by date and calculate the average number of pizzas ordered per day.
select round (avg(total_pizza),0) from
(select date(orders.order_date) as date,sum(order_details.quantity) as total_pizza
from orders 
join order_details on orders.order_id=order_details.order_id
group by date) as order_quantity;

-- Q10 Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name,sum(order_details.quantity*pizzas.price) as revenue
from pizza_types 
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on pizzas.pizza_id=order_details.pizza_id
group by name
order by revenue desc
limit 3;

-- Q11 Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,round(sum(order_details.quantity*pizzas.price)/(select round(sum(order_details.quantity*pizzas.price),2) as 'total_revenue'
from order_details
join pizzas on order_details.pizza_id=pizzas.pizza_id
)*100,2) as percent
from pizza_types join pizzas on  pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by category;

-- Q12 Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over (order by order_date) from
(select orders.order_date , sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas on order_details.pizza_id=pizzas.pizza_id
join orders on orders.order_id=order_details.order_id
group by orders.order_date) as sales;
  
-- Q13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue from
(select category,name,revenue, rank() over(partition by category order by revenue desc) as rn from
(select pizza_types.category,pizza_types.name,sum(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id 
group by pizza_types.category,pizza_types.name) as a) as b
where rn<4;














