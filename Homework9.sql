use sakila;

-- 1a
select first_name, last_name from actor;

-- 1b
select upper(concat(first_name, " ", last_name)) as "Actor Name" from actor;

-- 2a
select actor_id, first_name, last_name from actor where first_name like "JOE";

-- 2b
select * from actor where last_name like "%GEN%";

-- 2c
select * from actor where last_name like "%LI%" order by last_name, first_name;

-- 2d
select country_id, country from country where country in ("Afghanistan", "Bangladesh", "China");

-- 3a
alter table actor
add column description blob;

-- 3b
alter table actor
drop column description;

-- 4a
select last_name, count(*) from actor group by last_name;

-- 4b
select last_name, count(*) from actor group by last_name having count(*) > 1;

-- 4c
update actor
set first_name = "HARPO"
where first_name = "GROUCHO" and last_name = "WILLIAMS";

-- 4d
update actor
set first_name = "GROUCHO"
where first_name = "HARPO";

-- 5a
show create table address;

-- 6a
select staff.first_name, staff.last_name, address.address
from staff 
join address 
	on staff.address_id = address.address_id;

-- 6b
select staff.staff_id, sum(payment.amount)
from staff 
join payment 
	on staff.staff_id = payment.staff_id
where payment.payment_date like "2005-08%"
group by staff.staff_id;

-- 6c
select film.title, (select count(*) from film_actor where film_actor.film_id = film.film_id) as "Num of Actors"
from film 
inner join film_actor 
	on film.film_id = film_actor.film_id
group by film.title;

-- 6d
select count(*)
from inventory 
join film 
	on inventory.film_id = film.film_id
where film.title like "Hunchback Impossible";

-- 6e
select customer.first_name, customer.last_name, sum(payment.amount) as "Total Amount Paid"
from customer 
join payment 
	on customer.customer_id = payment.customer_id
group by customer.customer_id
order by customer.last_name;

-- 7a
select title
from film
where (title like "K%" or title like "Q%") and language_id = (
	select language_id 
    from language
    where name = "English"
);

-- 7b
select *
from actor
where actor_id in (
	select actor_id
    from film_actor
    where film_id = (
		select film_id
        from film
		where title like "Alone Trip"
	)
);

-- 7c
select customer.first_name, customer.last_name, customer.email
from customer
join address
	on customer.address_id = address.address_id
join city
	on address.city_id = city.city_id
join country
	on city.country_id = country.country_id
where country.country like "Canada";

-- 7d
select title
from film
where film_id in (
	select film_id
    from film_category
    where category_id in (
		select category_id
        from category
        where name like "Family"
	)
);

-- 7e
select film.title, count(*) as "Number of Rentals"
from film
join inventory
	on inventory.film_id = film.film_id
join rental
	on rental.inventory_id = inventory.inventory_id
group by film.title
order by count(*) desc;

-- 7f
select store.store_id, sum(payment.amount) as "Total Sales"
from store
join inventory
	on store.store_id = inventory.store_id
join rental
	on inventory.inventory_id = rental.inventory_id
join payment
	on rental.rental_id = payment.rental_id
group by store.store_id;

-- 7g
select store.store_id, city.city, country.country
from store
join address
	on store.address_id = address.address_id
join city
	on address.city_id = city.city_id
join country
	on city.country_id = country.country_id;

-- 7h
select category.name, sum(payment.amount) as "Gross Revenue"
from category
join film_category
	on category.category_id = film_category.category_id
join inventory
	on film_category.film_id = inventory.film_id
join rental
	on inventory.inventory_id = rental.inventory_id
join payment
	on rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

-- 8a
create view Top5GenresByRevenue as
	select category.name, sum(payment.amount) as "Gross Revenue"
	from category
	join film_category
		on category.category_id = film_category.category_id
	join inventory
		on film_category.film_id = inventory.film_id
	join rental
		on inventory.inventory_id = rental.inventory_id
	join payment
		on rental.rental_id = payment.rental_id
	group by category.name
	order by sum(payment.amount) desc
	limit 5;

-- 8b
select *
from Top5GenresByRevenue;

-- 8c
DROP VIEW IF EXISTS Top5GenresByRevenue;