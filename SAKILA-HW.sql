USE sakila;
 -- 1a. Display the first and last names of all actors from the table actor
SELECT first_name,last_name 
FROM sakila.actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
ALTER TABLE sakila.actor 
ADD COLUMN `Actor Name` VARCHAR(100);
UPDATE `actor` SET `Actor Name` = CONCAT_WS(" ", UPPER(`first_name`), UPPER(`last_name`));
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id,first_name,last_name 
FROM sakila.actor 
WHERE `first_name`="Joe";
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM sakila.actor
WHERE `last_name` 
LIKE '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * FROM sakila.actor 
WHERE `last_name` 
LIKE '%LI%'ORDER BY `last_name`,`first_name`;
-- 2d. Using IN, display the country_id and country columns of tcountryhe following countries: Afghanistan, Bangladesh, and China:
SELECT country_id,country 
FROM sakila.country 
WHERE country IN ("Afghanistan","Bangladesh","China");
-- 3a.You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE sakila.actor ADD COLUMN `description` BLOB;
ALTER TABLE sakila.actor DROP COLUMN `description`;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name ,COUNT(last_name) 
FROM sakila.actor 
GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,COUNT(last_name) 
FROM sakila.actor 
GROUP BY last_name 
HAVING COUNT(last_name)>=2;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE  sakila.actor 
SET  first_name="HARPO"  
WHERE last_name= "WILLIAMS" AND first_name="GROUCHO";
SELECT * FROM `actor` 
WHERE last_name = "WILLIAMS";
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE sakila.actor
SET first_name="GROUCHO",last_name="WILLIAMS"
WHERE first_name="HARPO" AND last_name="WILLIAMS";
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name,s.last_name,ad.address 
FROM staff AS s,address AS ad 
WHERE s.address_id=ad.address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.staff_id,s.first_name,s.last_name,SUM(p.amount) AS "Total Amount Rung Up"
FROM staff AS s
INNER JOIN payment AS p 
ON s.staff_id=p.staff_id
WHERE YEAR(p.payment_date)=2005 AND MONTH(p.payment_date)=08
GROUP BY s.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title,COUNT(fa.actor_id) AS "Number Of ACtor"
FROM film f,film_actor fa
WHERE f.film_id=fa.film_id
GROUP BY title;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title,COUNT(inventory_id) AS "Copies"
FROM inventory i
JOIN film f
ON (i.film_id=f.film_id)
WHERE f.title="Hunchback Impossible";
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT cus.first_name,cus.last_name,SUM(p.amount)AS "TOTAL AMOUNT PAID"
FROM customer AS cus
JOIN payment AS p
ON (cus.customer_id=p.customer_id)
GROUP BY cus.last_name;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
    FROM film
    WHERE language_id 
    IN(
	SELECT language_id 
	FROM  language
	WHERE name="English"
	  )
    AND title LIKE 'K%' OR title LIKE'Q%';
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip
SELECT `ACTOR Name`
FROM actor
WHERE actor_id
IN(
SELECT actor_id 
FROM film_actor
WHERE film_id
	IN(
		SELECT film_id
		FROM film
		WHERE title="Alone Trip"
		)
  );
  -- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
  SELECT cus.first_name,cus.last_name,cus.email
  from customer cus,city c,country con,address addr
  WHERE country="Canada"
  AND con.country_id=c.country_id
  AND c.city_id=addr.city_id
  AND addr.address_id=cus.address_id;
  -- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
  SELECT f.title AS "Family Movies"
FROM film f,category cat ,film_category fcat
WHERE cat.name="Family"
AND cat.category_id=fcat.category_id
AND fcat.film_id=f.film_id;
-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title,COUNT(r.rental_id) AS "RENTAL COUNT"
FROM film f,rental r,inventory i
WHERE f.film_id=i.film_id
AND i.inventory_id=r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id)DESC;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id,sum(p.amount) AS "STORE BUSINESS IN DOLLARS "
FROM store s,payment p,staff st
WHERE s.store_id=st.store_id
AND st.staff_id=p.staff_id
GROUP BY s.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id,c.city,con.country
FROM country con ,city c,store s,address ad
WHERE s.address_id=ad.address_id
AND ad.city_id=c.city_id
AND c.country_id=con.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT cat.name,sum(pay.amount) AS "Gross Revenue"
FROM payment pay,category cat,film_category fcat,inventory i,rental r
WHERE cat.category_id=fcat.category_id
AND fcat.film_id=i.film_id
AND i.inventory_id=r.inventory_id
AND r.rental_id=pay.rental_id
GROUP BY cat.name
ORDER BY sum(pay.amount) DESC 
LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW `TOP FIVE GENRES` AS
SELECT cat.name,sum(pay.amount) AS "Gross Revenue"
FROM payment pay,category cat,film_category fcat,inventory i,rental r
WHERE cat.category_id=fcat.category_id
AND fcat.film_id=i.film_id
AND i.inventory_id=r.inventory_id
AND r.rental_id=pay.rental_id
GROUP BY cat.name
ORDER BY sum(pay.amount) DESC 
LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM `TOP FIVE GENRES`;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW `TOP FIVE GENRES`;







