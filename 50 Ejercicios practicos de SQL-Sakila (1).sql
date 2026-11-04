Use sakila;
-- Conteo de Películas por Actor: Muestra el nombre, apellido del actor y la cantidad total de películas en las que ha actuado, 
-- ordenado de mayor a menor número de películas.
SELECT count(film_actor.film_id),
    concat(actor.first_name,'-',actor.last_name) as "nombre y apellido"
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id
ORDER BY COUNT(film_actor.film_id) DESC;

-- Clientes Frecuentes: Muestra los clientes (nombre y apellido)
-- que hayan realizado más de 30 alquileres en total.
select concat(customer.first_name," ",customer.last_name), 
	count(rental.rental_id) as rentas_pelis
from rental
join customer
	on rental.customer_id = customer.customer_id
group by rental.customer_id
having rentas_pelis > 30;

-- Recaudación por Categoría de Película: Muestra la categoría y el total de ingresos generados por los alquileres de sus películas, 
-- ordenado descendentemente por ingresos.
select c.name, 
	sum(p.amount) as suma_precios
from category as c
join film_category fc
	on c.category_id = fc.category_id
join film as f
	on f.film_id = fc.film_id
join inventory as i
	on f.film_id = i.film_id
join rental as r 
	on i.inventory_id = r.inventory_id
join payment as p 
	on r.rental_id = p.rental_id
group by c.category_id
order by suma_precios desc;

--  Ubicación Detallada de las Tiendas: Muestra el ID de la tienda, 
-- el nombre del encargado, la dirección, distrito, ciudad y país de cada tienda.
select store.store_id, 
	staff.first_name, 
	address.address, 
	address.district, 
	city.city, 
	country.country
from store 
join staff
	on store.store_id = store.store_id
join address 
	on store.address_id = address.address_id
join city 
	on address.city_id = city.city_id
join country 
	on city.country_id = country.country_id;

-- Top 10 Películas Más Alquiladas: 
-- Muestra el título de la película y el número total de veces que ha sido alquilada en la historia del videoclub
select count(film.film_id) as veces_rentada,
	film.title
from film
join inventory
	on film.film_id = inventory.film_id
join rental
	on inventory.inventory_id = rental.inventory_id

group by film.title
order by veces_rentada desc;

-- Los 10 Mejores Clientes: 
-- Muestra el nombre, apellido y consumo total acumulado de los 10 clientes con mayor volumen de compras
select count(customer.customer_id) as veces_renta ,
	concat(customer.first_name," ",customer.last_name) as nombre_completo
from customer
join rental
	on customer.customer_id = rental.customer_id
group by nombre_completo
order by veces_renta desc
limit 10;

-- Películas con Amplio Inventario: 
-- Muestra el título de la película y el total de unidades en inventario global para películas con más de 7 unidades.
select film.title, 
	count(inventory.store_id) as inventario
from film
join inventory
	on film.film_id = inventory.film_id
group by film.title
having count(inventory.store_id) >= 7
order by inventario;

-- Evolución Mensual de Recaudación por Tienda: 
-- Obtén la suma recaudada en pagos agrupada por tienda, año y mes de pago.
select store.store_id,
sum(payment.amount),
concat(month(rental.rental_date)," / ",year(rental.rental_date)) as mes_año
from store
join staff
	on store.store_id = staff.store_id
join payment

	on staff.staff_id = payment.staff_id
join rental
	on payment.staff_id = rental.staff_id
group by store.store_id, mes_año;

-- ategorías con Gran Volumen de Películas:
-- Muestra el nombre de las categorías que contienen más de 60 películas registradas.
select  category.name,
	count(film_category.film_id) as peliculas
from category
join film_category
	on category.category_id = film_category.category_id
group by category.name
having peliculas >= 60;

-- Actores con Películas de Larga Duración:
-- Muestra el nombre del actor y la duración promedio de sus películas, considerando solo a aquellos cuyo promedio sea superior a 120 minutos.
select actor.first_name,
	round(avg(film.length),2) as duracion
from actor 
join film_actor
	on actor.actor_id = film_actor.actor_id
join film
	on film_actor.film_id = film.film_id
group by actor.first_name
having duracion > 120
order by actor.first_name;
