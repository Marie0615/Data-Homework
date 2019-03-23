USE sakila;
select * from actor;
-- 1a. Display the first and last names of all actors from the table actor.
select first_name, last_name from actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(First_Name,' ',Last_Name) AS Actor_Name FROM actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
select actor_id, first_name, last_name from actor 
where first_name = "Joe";
-- 2b. Find all actors whose last name contain the letters GEN
select actor_id, first_name, last_name from actor 
where last_name like "%GEN%";
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id, first_name, last_name from actor 
where last_name like "%LI%"
order by last_name, first_name asc;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id, country from country
where country  IN("Afghanistan", "Bangladesh","China");
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB
ALTER TABLE `sakila`.`actor` 
ADD COLUMN `Description` BLOB NULL AFTER `last_update`;
select * from actor;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE `sakila`.`actor` 
DROP COLUMN `Description`;
-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, COUNT(*) AS Count from actor
group by last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, COUNT(*) from actor
group by last_name
HAVING COUNT(*) >= 2;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from actor 
where first_name = "GROUCHO";
UPDATE 
   actor
SET 
    first_name = "HARPO"
WHERE 
    actor_id = 172;
select * from actor 
where first_name = "HARPO";
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE 
   actor
SET 
    first_name = "GROUCHO"
WHERE 
    actor_id = 172;
select * from actor 
where actor_id = 172;
SHOW CREATE TABLE address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
select * from staff;
select * from address;
select 
first_name,
last_name,
address
from 
staff
 INNER JOIN
 address ON address.address_id = staff.address_id;
 -- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
 select * from payment;
select
first_name,
last_name,
SUM(amount) AS Total 
from 
payment
INNER JOIN
staff ON staff.staff_id = payment.staff_id
where payment_date BETWEEN '2005-08-01' and '2005-08-31'
Group by staff.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from film;
select * from film_actor;
select 
title,
Count(actor_id)
from 
film
 INNER JOIN
film_actor ON film_actor.film_id = film.film_id
Group by film.title;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select * from film
where title = "Hunchback Impossible";
select * from inventory
where film_id = 439;
select COUNT(inventory_id) as Total_Copies_Inv
from inventory
where film_id = 439;
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select 
first_name,
last_name,
sum(amount) as Total_Copies_Inv
from customer
INNER JOIN
payment ON payment.customer_id = customer.customer_id
group by last_name asc;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select * from film
where title  like "K%" or title like "Q%"  and language_id = 1;
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select * from film
where title = "Alone Trip";
select 
first_name,
last_name
from actor
INNER JOIN
film_actor ON  film_actor.actor_id = actor.actor_id
where film_actor.film_id= 17;
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select 
first_name, 
last_name, 
email
from customer
INNER JOIN address on address.address_id = customer.address_id
INNER JOIN city on city.city_id = address.city_id
INNER JOIN country on country.country_id = city.country_id
where country = 'Canada';
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films. 
select title from film
INNER JOIN film_category on film.film_id = film_category.film_id
INNER JOIN category on film_category.category_id = category.category_id
where name='Family';
-- 7e. Display the most frequently rented movies in descending order.
select title, count(rental_id) as total_rentals 
from film
INNER JOIN inventory on inventory.film_id = film.film_id
INNER JOIN rental on rental.inventory_id = inventory.inventory_id
group by title
order by total_rentals desc;
-- 7f. Write a query to display how much business, in dollars, each store brought in. 
select store_id, address, sum(amount) as total_dollars 
from address
INNER JOIN store on store.address_id = address.address_id
INNER JOIN payment on store.manager_staff_id = payment.staff_id
group by store_id;
-- 7g. Write a query to display for each store its store ID, city, and country. 
select store_id, address, city, country
from store
INNER JOIN address on store.address_id = address.address_id
INNER JOIN city on city.city_id = address.city_id
INNER JOIN country on city.country_id = country.country_id
group by store_id;
-- 7h. List the top five genres in gross revenue in descending order. --
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) --
select name as film_category, sum(amount) as total_revenue
from payment
INNER JOIN rental on rental.rental_id = payment.rental_id
INNER JOIN inventory on inventory.inventory_id = rental.inventory_id
INNER JOIN film_category on film_category.film_id = inventory.film_id
INNER JOIN category on category.category_id = film_category.category_id
group by name
order by total_revenue desc
limit 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. --
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. --
create view top_five_genres as
select name as `Film Category`, sum(amount) as `Total Revenue`
from payment
join rental on rental.rental_id = payment.rental_id
join inventory on inventory.inventory_id = rental.inventory_id
join film_category on film_category.film_id = inventory.film_id
join category on category.category_id = film_category.category_id
group by name
order by `Total Revenue` desc
limit 5;

-- 8b. How would you display the view that you created in 8a? --
select * from top_five_genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. --
drop view top_five_genres; 

-- Turn safe update mode back on --
set sql_safe_updates = 1;