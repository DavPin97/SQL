SELECT*
FROM "film";
-- 1.Crea el esquema de la BBDD

-- 2.Muestra los nombres de todas las peliculas con una clasificacion por edades de 'R'
SELECT f.title, 
	   f.rating
FROM film f 
WHERE f.rating = 'R';

-- 3.Encuentra los nombres de los actores que tengan un "actor_id" entre 30 y 40

SELECT CONCAT (a.first_name,' ', a.last_name) AS "NombreCompleto", a.actor_id
FROM actor a 
WHERE a.actor_id BETWEEN 30 AND 40;

-- 4.Obten las peliculas cuyo idioma coincide con el idioma original

SELECT f.title
FROM film f 
WHERE f.original_language_id = f.language_id;

-- NOTA: En la tabla "film", todos los registros para la columna "original_language_id" son NULL

-- 5.Ordena las peliculas por duracion de forma ascendente

SELECT f.title, f.length
FROM film f 
ORDER BY f.length;

-- 6.Encuentra el nombre y apellido de los actores que tengan 'Allen' en su apellido

SELECT CONCAT(a.first_name, ' ', a.last_name) AS "NombreCompleto"
FROM actor a 
WHERE a.last_name LIKE '%ALLEN%';

-- 7.Encuentra la cantidad total de peliculas en cada clasificacion de la tabla
-- "film" y muestra la clasificacion junto con el recuento

SELECT f.rating ,
	   COUNT (*) AS "Total_Peliculas"
FROM film f 
GROUP BY f.rating;

-- 8.Encuentra el titulo de todas las peliculas que son 'PG-13' o tienen una
-- duracion mayor a 3 horas en la tabla film

SELECT f.title, f.rating, f.length
FROM film f 
WHERE f.rating = 'PG-13' OR f.length > 180;

-- 9.Encuentra la variabilidad de lo que costaria reemplazar las peliculas

SELECT stddev(f.replacement_cost) AS "Desviacion_Coste"
FROM film f ;

SELECT variance(f.replacement_cost) AS "Varianza_Coste"
FROM film f ;

-- 10.Encuentra la mayor y la menor duracion de una pelicula de nuestra BBDD

SELECT MAX(f.length) AS "Duracion_Maxima",
	   MIN(f.length) AS "Duracion_Minima"
FROM film f ;

-- 11.Encuentra lo que costo el antepenultimo alquiler ordenado por dia

SELECT p.amount, p.payment_date, p.payment_id
FROM payment p 
ORDER BY p.payment_date DESC, p.payment_id
OFFSET 2 LIMIT 1;
-- NOTA: He anadido el payment_id a la consulta para aclararme mejor, ya que 
-- usando solo el payment_date habia muchisimas fechas iguales.

-- 12.Encuentra el titulo de las peliculasen la tabla "film" que no sean
-- ni 'NC-17' ni 'G' en cuanto a su clasificacion

SELECT f.title, f.rating
FROM film f 
WHERE f.rating NOT IN ('NC-17','G');

-- 13.Encuentra el promedio de duracion de las peliculas para cada clasificacion
-- de la tabla film y muestra la clasificacion junto con el promedio de duracion

SELECT AVG(f.length), f.rating AS "Clasificacion"
FROM film f 
GROUP BY f.rating;

-- 14.Encuentra el titulo de todas las peliculas que tengan una duracion mayor a 180 minutos

SELECT f.title, f.length
FROM film f 
WHERE f.length > 180;

-- 15.¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(p.amount)
FROM payment p ;

-- 16.Muestra los 10 clientes con mayor valor de id

SELECT concat(c.first_name, ' ', c.last_name)
FROM customer c 
ORDER BY c.customer_id DESC
LIMIT 10;

-- 17.Encuentra el nombre y apellido de los actores que aparecen en la pelicula con titulo 'Egg Igby'

SELECT CONCAT (a.first_name, ' ', a.last_name) AS "Nombre_Actor"
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY';

-- 18.Selecciona todos los nombres de las peliculas unicos

SELECT DISTINCT f.title
FROM film f ;

-- 19. Encuentra el titulo de las peliculas que son comedias y tienen una duracion mayor a 180 minutos en la tabla 'film'

SELECT f.title AS "Titulo_Pelicula"
FROM film f
JOIN film_category fc  ON f.film_id = fc.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE f.length  > 180 AND c."name" = 'Comedy';

-- 20.Encuentra las categorias de peliculas que tienen un promedio de duracion superior a 100 minutos y
-- muestra el nombre de la categoria junto con el promedio de duracion

SELECT AVG(f.length) AS "Promedio_Duracion", c."name"
FROM film f
JOIN film_category fc  ON f.film_id = fc.film_id
JOIN category c ON c.category_id = fc.category_id
GROUP BY c."name" HAVING AVG (f.length) > 110;

-- 21.¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(f.length) AS "Media_Duracion"
FROM film f ;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices

SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Nombre_Completo"
FROM actor a ;

-- 23. Numeros de alquiler por dia, ordenados por cantidad de alquiler de forma descendente

SELECT SUM (r.rental_id ) AS "Alquileres_Diarios"
FROM rental r 
GROUP BY r.rental_date
ORDER BY SUM (r.rental_id ) DESC;

-- 24. Encuentra las peliculas con una duracion superior al promedio

SELECT f.title 
FROM film f 
WHERE f.length > (
	SELECT AVG(length)
	FROM "film"
);

-- 25.Averigua el numero de alquileres registrados por mes.

SELECT date_trunc('month',r.rental_date) AS "Mes",
	   COUNT (*) AS "Total_Alquileres"
FROM rental r 
GROUP BY date_trunc('month',r.rental_date);

-- 26.Encuentra el promedio, la desviacion estandar y varianza del total pagado

SELECT AVG(p.amount) AS "Promedio",
	   stddev(p.amount) AS "Desviacion",
	   variance(p.amount) AS "Varianza"
FROM payment p ;

-- 27.¿Qué películas se alquilan por encima del precio medio?

SELECT f.title AS "Pelicula"
FROM payment p 
JOIN rental r ON r.rental_id = p.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE p.amount > (
					SELECT AVG(amount)
					FROM payment
					);

-- 28.Muestra el id de los actores que hayan participado en mas de 40 peliculas

SELECT fa.actor_id
FROM film_actor fa 
GROUP BY fa.actor_id HAVING COUNT (fa.film_id) > 40;

-- 29.Obtener todas las peliculas, y si estan disponibles en el inventario, mostrar la cantidad disponible

SELECT f.title,
		(
		SELECT COUNT (*)
		FROM inventory i
		WHERE i.film_id = f.film_id
		) AS "Copias_Disponibles"
FROM film f ;


-- 30. Obtener los actores y el numero de peliculas en las que ha actuado

SELECT concat(a.first_name, ' ', a.last_name) AS "Nombre",
	   COUNT(fa.film_id) AS "Total_Peliculas"
FROM actor a 
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id;

-- 31.Obtener todas las peliculas y mostrar los actores que han actuado en ellas, incluso
-- si algunas peliculas no tienen actores asociados.

SELECT f.title, concat(a.first_name, ' ', a.last_name) AS "Nomre_Actor"
FROM film f 
LEFT JOIN film_actor fa ON fa.film_id  = f.film_id 
LEFT JOIN actor a ON a.actor_id = fa.actor_id
ORDER BY f.title;

-- 32.Obtener todos los actores y mostrar las peliculas en las que han actuado, incluso si algunos actores
-- no han actuado en ninguna pelicula

SELECT concat(a.first_name, ' ', a.last_name) AS "Nombre_Actor",
	   f.title 
FROM actor a 
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
ORDER BY "Nombre_Actor";

-- 33.Obtener todas las peliculas que tenemos y todos los registros de alquiler.

SELECT f.title, r.rental_id
FROM film f 
LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
ORDER BY f.title;

-- 34.Encuentra los 5 clientes que mas dinero se hayan gastado con nosotros.

SELECT concat(c.first_name,' ', c.last_name) AS "Nombre_Cliente",
	   SUM(p.amount) AS "Total_Gastado"
FROM customer c 
LEFT JOIN rental r ON r.customer_id = c.customer_id
LEFT JOIN payment p ON p.customer_id = c.customer_id
GROUP BY "Nombre_Cliente"
ORDER BY SUM(p.amount)DESC
LIMIT 5;

-- 35.Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT concat(a.first_name, ' ', a.last_name) AS "Nombre_Completo"
FROM actor a 
WHERE a.first_name = 'JOHNNY';


-- 36.Renombre la columna "first_name" como Nombre y "last_name" como Apellido.

SELECT a.first_name AS "Nombre",
	   a.last_name AS "Apellido"
FROM actor a ;


-- 37.Encuentra el ID del actor mas bajo y mas alto en la tabla actor.

SELECT MAX(a.actor_id) AS "ID_Maximo",
	   MIN(a.actor_id) AS "ID_Minimo"
FROM actor a ;

-- 38. Cuenta cuantos actores hay en la tabla "actor".

SELECT COUNT (a.actor_id)
FROM actor a ;

-- 39.Selecciona todos los actores y ordenalos por appelido en orden descendente.

SELECT concat(a.first_name,' ',a.last_name) AS "Nombre_Completo"
FROM actor a 
ORDER BY a.last_name DESC
;

-- 40.Selecciona las primeras 5 peliculas de la tabla "film".

SELECT f.title
FROM film f 
LIMIT 5;

-- 41.Agrupa los actores por su nombre y cuenta cuantos actores tienen el mismo nombre.
-- ¿Cuál es el nombre más repetido?

SELECT a.first_name,
	   COUNT(a.first_name)
FROM actor a 
GROUP BY a.first_name
ORDER BY COUNT(a.first_name) DESC;

-- KENNETH, PENELOPE Y JULIA son los nombres mas repetidos

-- 42.Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT r.rental_id,
	   concat(c.first_name,' ', c.last_name) AS "Nombre_Cliente"
FROM rental r 
LEFT JOIN customer c ON c.customer_id = r.customer_id
ORDER BY r.rental_id;

-- 43.Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT concat(c.first_name,' ', c.last_name) AS "Nombre_Cliente",
	   r.rental_id
FROM customer c 
LEFT JOIN rental r ON r.customer_id = c.customer_id
ORDER BY "Nombre_Cliente";

-- 44.Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación

SELECT f.title, c.name AS categoria
FROM film f
CROSS JOIN category c
;

-- No veo que esta consulta aporte valor, me da todas las combinaciones posibles
-- entre peliculas y categorias sin importar si se corresponde con la realidad
-- Si quisiera ver las peliculas y su categoria podria usar algo como un inner join.

-- 45.Encuentra los actores que han participado en las peliculas de la categoria 'Action'

SELECT concat(a.first_name,' ', a.last_name) AS "Nombre_Actor",
	   c."name" AS "Categoria"
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c."name" = 'Action';

-- 46.Encuentra todos los actores que no han participado en peliculas.

SELECT concat(a.first_name,' ', a.last_name) AS "Nombre_Actor"
FROM actor a 
LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
WHERE fa.film_id  IS NULL;

-- 47.Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT concat(a.first_name,' ', a.last_name) AS "Nombre_Actor",
	   count(fa.film_id) AS "Cantidad_Peliculas"
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY concat(a.first_name,' ', a.last_name);

-- 48.Crea una vista llamada "actor_num_peliculas" que muestre los nombres de los actores y el numero total de peliculas en las que han participado

CREATE VIEW "actor_num_peliculas" AS
SELECT concat(a.first_name,' ', a.last_name) AS "Nombre_Actor",
	   count(fa.film_id) AS "Cantidad_Peliculas"
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY concat(a.first_name,' ', a.last_name);

-- 49.Calcula el numero total de alquileres realizados por cada cliente.

SELECT concat(c.first_name,' ', c.last_name) AS "Cliente",
	   count(r.rental_id) AS "Total_Alquileres"
FROM customer c 
JOIN rental r ON r.customer_id = c.customer_id
GROUP BY concat(c.first_name,' ', c.last_name)
ORDER BY concat(c.first_name,' ', c.last_name);

-- 50. Calcula la duracion total de las peliculas en la categoria 'Action'.

SELECT sum(f.length) AS "Duracion_Total"
FROM category c 
JOIN film_category fc ON fc.category_id = c.category_id
JOIN film f ON f.film_id = fc.film_id
WHERE c."name" = 'Action';

-- 51.Crea una tabla temporal llamada "clientes_rentas_temporal" para almacenar el total
-- de alquileres por cliente.

CREATE TEMPORARY TABLE "Clientes_Rentas_Temporal" AS
SELECT concat(c.first_name, ' ', c.last_name) AS "Cliente",
       COUNT(r.rental_id) AS "Total_alquileres"
FROM customer c
LEFT JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

-- 52.Crea una tabla temporal llamada "peliculas_alquiladas" que almacenen las peliculas que han sido alquiladas al menos 10 veces.

CREATE TEMPORARY TABLE "peliculas_alquiladas" AS
SELECT f.title,
	   sum(r.rental_id) AS "Total_Alquileres"
FROM rental r 
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
GROUP BY f.title HAVING SUM(r.rental_id) > 10;

-- 53.Encuentra el titulo de las peliculas que han sido alquiladas por el cliente con el nombre
-- 'Tammy Sanders' y que aun no se han devuelto. Ordena los resultados alfabeticamente por titulo de pelicula.

SELECT f.title
FROM customer c
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f ON f.film_id = i.film_id
WHERE c.first_name = 'TAMMY'
  AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title;

-- 54.Encuentra los nombres de los actores que han actuado en al menos una pelicula que pertenece a la categoria
-- 'Sci-Fi'. Ordena los resultados alfabeticamente por su apellido.

SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name;

-- 55.Encuentra el nombre y apellido de los actores que han actuado en peliculas que se alquilaron despues de que la pelicula
-- 'Spartacus Cehaper' se alquilara por primera vez. Ordena los resultados alfabeticamente por apellido.

SELECT a.first_name, a.last_name
FROM actor a 
JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN film f ON f.film_id = fa.film_id
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
						SELECT min(r.rental_date)
						FROM rental r
						JOIN inventory i ON i.inventory_id = r.inventory_id 
						JOIN film f ON f.film_id = i.film_id 
						WHERE f.title = 'SPARTACUS CHEAPER'
						)
;

-- 56. Encuentra el nombre y el apellido de los actores que no han actuado en ninguna pelicula de la categoria 'Music'.

SELECT a.first_name, a.last_name
FROM actor a 
WHERE a.actor_id NOT IN (
	SELECT DISTINCT fa.actor_id
	FROM film_actor fa
	JOIN film_category fc ON fc.film_id = fa.film_id 
	JOIN category c ON c.category_id = fc.category_id
	WHERE c.name LIKE 'Music' 
)
;

-- 57.Encuentra el titulo de todas las peliculas que fueron alquiladas por mas de 8 dias

SELECT
	f.title
FROM film f
INNER JOIN inventory i
	ON f.film_id = i.film_id
INNER JOIN rental r
	ON r.inventory_id  = i.inventory_id
WHERE r.return_date IS NOT NULL 
AND EXTRACT(DAY FROM r.return_date - r.rental_date) > 8;

-- 58.Encuentra el titulo de todas las peliculas que son de la misma categoria que 'Animation'.

SELECT f.title
FROM film f 
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
WHERE c."name" = 'Animation';

-- 59.Encuentra el nombre de las peliculas que tienen la misma duracion que la pelicula con tl titulo 'Dancing Fever'.
-- Ordena los resultados alfabeticamente por titulo de pelicula.

SELECT f.title
FROM film f 
WHERE f.length = (
		SELECT f2.length 
		FROM film f2
		WHERE f2.title = 'DANCING FEVER'
		)
ORDER BY f.title;

-- 60.Encuentra los nombre de cliente que han alquilado al menos 7 peliculas distintas. 
-- Ordena los resultados alfabeticamente por apellido.

SELECT c.first_name
FROM customer c 
JOIN rental r ON r.customer_id = c.customer_id
JOIN inventory i ON i.inventory_id = r.inventory_id
GROUP BY c.customer_id HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name
;

--61.Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT
	c."name",
	count(*) AS "Nº_alquileres" 
FROM category c
INNER JOIN film_category fc
	ON c.category_id = fc.category_id
INNER JOIN film f
	ON fc.film_id = f.film_id
INNER JOIN inventory i 
	ON f.film_id = i.film_id
INNER JOIN rental r
	ON i.inventory_id = r.inventory_id
GROUP BY c."name";

--62.Encuentra el número de películas por categoría estrenadas en 2006.
SELECT
	c.name,
	count(f.film_id) AS "Nº_peliculas" 
FROM film f
INNER JOIN film_category fc
	ON f.film_id = fc.film_id 
INNER JOIN category c
	ON c.category_id = fc.category_id 
WHERE f.release_year = 2006
GROUP BY c.name;

--63.Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT *
FROM staff s 
CROSS JOIN store s2;

--64.Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT
	c.customer_id,
	c.first_name,
	c.last_name,
	count(r.rental_id) AS "Cantidad_alquileres"
FROM customer c
INNER JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;





