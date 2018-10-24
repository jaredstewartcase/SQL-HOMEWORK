#SQL HOMEWORK - JARED CASE - 10/24/2018

#using the sakila database for the homework
use sakila;

#1a. Display the first and last names of all actors from the table actor.
SELECT first_name AS 'Actor - First Name', last_name AS 'Actor - Last Name' 
FROM sakila.actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor 
#Name.
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' 
FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, 
#"Joe." What is one query would you use to obtain this information?
SELECT actor_id AS 'Actor Id', first_name AS 'Actor - First Name', last_name AS 'Actor - Last Name' 
FROM actor 
WHERE first_name = "Joe";

#2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id AS 'Actor Id', first_name AS 'Actor - First Name', last_name AS 'Actor - Last Name' 
FROM actor 
WHERE last_name LIKE '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, 
#in that order:
SELECT actor_id AS 'Actor Id', first_name AS 'Actor - First Name', last_name AS 'Actor - Last Name' 
FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id 'AS Country ID', country AS 'Country' 
FROM country 
WHERE country IN ("Afghanistan", "Bangladesh", "China");

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
#as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor
DROP description;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name AS 'Last Name', count(*) AS 'Count of Last Names' 
FROM actor
GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at 
#least two actors
SELECT last_name AS 'Last Name', count(*) AS 'Count of Last Names Greater Than 2'
FROM actor
GROUP BY last_name
Having count(*) > 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE actor_id = 172;

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
#In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = "GROUCHO"
WHERE actor_id = 172;

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables 
#staff and address:
SELECT staff.first_name AS 'Staff - First Name', staff.last_name 'Staff - Last Name', address.address 'Staff Address' 
FROM address
INNER JOIN staff ON
staff.address_id = address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.first_name AS 'Staff First Name', staff.last_name AS 'Staff Last Name', SUM(payment.amount) AS 'Total Amount Rung Up'
FROM payment
INNER JOIN staff 
ON staff.staff_id = payment.staff_id
WHERE YEAR(payment.payment_date) = 2005 AND MONTH(payment.payment_date) = 08
GROUP BY payment.staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title AS 'Film Name', COUNT(film_actor.actor_id) AS 'Actor Count Per Film'
FROM film_actor
INNER JOIN film
ON film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title AS 'Film Name', COUNT(inventory.film_id) AS 'Film Count in Inventory'
FROM inventory
INNER JOIN film
ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible'
GROUP BY inventory.film_id;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
#List the customers alphabetically by last name:
SELECT customer.first_name AS 'First Name', customer.last_name AS 'Last Name', SUM(payment.amount) AS 'Amount Paid by Customer'
FROM payment
INNER JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of 
#movies starting with the letters K and Q whose language is English.
SELECT film.title AS 'Film Title'
FROM film
WHERE film.title LIKE 'K%' OR film.title LIKE 'Q%' AND film.language_id IN
(
SELECT language.language_id
FROM language
WHERE language.name = 'English'
);

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor.first_name AS 'First Name', actor.last_name AS 'Last Name'
FROM actor
WHERE actor.actor_id IN
(
SELECT film_actor.actor_id
FROM film_actor
WHERE film_actor.film_id IN
(
SELECT film.film_id 
FROM film
WHERE film.title = 'Alone Trip'
));

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email 
#addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name AS 'Customer First Name', c.last_name AS 'Customer Last Name', c.email AS 'Customer Email', y.country AS 'Customer Home Country'
FROM customer c
    INNER JOIN address a
		ON c.address_id = a.address_id
    INNER JOIN city i
		ON a.city_id = i.city_id
	INNER JOIN country y
		ON i.country_id = y.country_id
WHERE y.country = 'Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
#Identify all movies categorized as family films.
SELECT f.film_id AS 'Film ID', f.title AS 'Film Title', a.name AS 'Film Category', a.category_id AS 'Film Category ID'
FROM film f
	INNER JOIN film_category c
		ON f.film_id = c.film_id
	INNER JOIN category a
		ON a.category_id = c.category_id
WHERE a.name = 'Family';

#7e. Display the most frequently rented movies in descending order.
SELECT r.inventory_id AS 'Invenotry ID', i.film_id AS 'Film ID', f.title AS 'Film Title', Count(f.title) AS 'Rental Count by Film Title'
FROM rental r
	INNER JOIN inventory i
		ON r.inventory_id = i.inventory_id
	INNER JOIN film f
		ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY COUNT(f.title) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT staff.store_id AS 'Store', (SELECT SUM(payment.amount) FROM payment WHERE payment.staff_id = staff.staff_id) AS 'Total Sales Per Store'
FROM staff
GROUP BY staff.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id AS 'Store ID', c.city AS 'Store City', t.country AS 'Store Country'
FROM store s
	INNER JOIN staff 
		ON s.store_id = staff.store_id
	INNER JOIN address
		ON staff.address_id = address.address_id
	INNER JOIN city c
		ON address.city_id = c.city_id
	INNER JOIN country t
		ON c.country_id = t.country_id;

#7h. List the top five genres in gross revenue in descending order. 
#(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS 'Category Name', SUM(p.amount) AS 'Gross Revenue by Film Category'
	FROM payment p
    INNER JOIN rental r
		ON p.rental_id = r.rental_id 
	INNER JOIN inventory i
		ON r.inventory_id = i.inventory_id
	INNER JOIN film_category f
		ON i.film_id = f.film_id
	INNER JOIN category c
		ON f.category_id = c.category_id
	GROUP BY c.name
    ORDER BY COUNT(p.amount) DESC LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
#Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to 
#create a view.   
CREATE VIEW Top5Categories AS
SELECT c.name AS 'Category Name', SUM(p.amount) AS 'Gross Revenue by Film Category'
	FROM payment p
    INNER JOIN rental r
		ON p.rental_id = r.rental_id 
	INNER JOIN inventory i
		ON r.inventory_id = i.inventory_id
	INNER JOIN film_category f
		ON i.film_id = f.film_id
	INNER JOIN category c
		ON f.category_id = c.category_id
	GROUP BY c.name
    ORDER BY COUNT(p.amount) DESC LIMIT 5;

#8b. How would you display the view that you created in 8a?     
SELECT * 
FROM top5categories;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top5categories;
