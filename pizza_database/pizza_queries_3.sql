--Zadanie 1
--1.1 Podaj œredni¹ cenê pizzy dla ka¿dego kraju pochodzenia. 
SELECT country, AVG(price) AS 'avg_price' FROM menu GROUP BY country HAVING country IS NOT NULL;
--SELECT country, AVG(price) AS 'avg_price' FROM menu WHERE country IS NOT NULL GROUP BY country;

--1.2 Podaj najwy¿sz¹ cenê pizzy dla ka¿dego kraju pochodzenia.
SELECT country, MAX(price) AS 'max_price' FROM menu GROUP BY country HAVING country IS NOT NULL;
--SELECT country, MAX(price) AS 'max_price' FROM menu WHERE country IS NOT NULL GROUP BY country;

--1.3 Podaj najni¿sz¹ cenê pizzy dla ka¿dego kraju pochodzenia.
SELECT country, MIN(price) AS 'min_price' FROM menu GROUP BY country HAVING country IS NOT NULL;
--SELECT country, MIN(price) AS 'min_price' FROM menu WHERE country IS NOT NULL GROUP BY country;

--1.4 Podaj œredni¹ cenê pizzy dla ka¿dego kraju pochodzenia. Nie uwzglêdniaj krajów z jednym rodzajem pizzy.
SELECT country, AVG(price) AS 'avg_price' FROM menu GROUP BY country HAVING COUNT(pizza) > 1 AND country IS NOT NULL;
--SELECT country, AVG(price) AS 'avg_price' FROM menu WHERE country IS NOT NULL GROUP BY country HAVING COUNT(pizza) > 1;

--1.5 Podaj œredni¹ cenê pizzy dla ka¿dego kraju pochodzenia. Uwzglêdnij tylko kraje z liter¹  'i' w nazwie.
SELECT country, AVG(price) AS 'avg_price' FROM menu GROUP BY country HAVING country LIKE '%i%';
--SELECT country, AVG(price) AS 'avg_price' FROM menu WHERE country LIKE '%i%' GROUP BY country;

--1.6 Podaj najni¿sz¹ cenê pizzy dla ka¿dego kraju pochodzenia. Uwzglêdnij tylko kraje, w których ta cena jest ni¿sza ni¿ $7.50
SELECT country, MIN(price) AS 'min_price' FROM menu GROUP BY country HAVING MIN(price) < 7.5 AND country IS NOT NULL;
--SELECT country, MIN(price) AS 'min_price' FROM menu WHERE country IS NOT NULL GROUP BY country HAVING MIN(price) < 7.5;

--Zadanie 2
--2.1 Podaj nazwy oraz ceny rodzajów pizzy, dla których cena jest wy¿sza od ceny ka¿dej pizzy w³oskiej.
SELECT pizza, price FROM menu WHERE price > (SELECT MAX(price) FROM menu WHERE country = 'Italy');

--2.2  Podaj nazwy rodzajów pizzy, które zawieraj¹ przynajmniej jeden sk³adnik miêsny. U¿yj podzapytania.
SELECT pizza FROM menu WHERE pizza IN(SELECT pizza FROM recipe WHERE ingredient IN(SELECT ingredient FROM items WHERE type = 'meat'));
--SELECT pizza FROM recipe WHERE ingredient IN(SELECT ingredient FROM items WHERE type = 'meat');

--2.3 Dla ka¿dego sk³adnika u¿ytego w pizzy wska¿ nazwê pizzy, w której iloœæ tego sk³adnika jest najwy¿sza (podaj równie¿ tê iloœæ).
SELECT ingredient, pizza, amount FROM recipe AS recipe_result WHERE amount IN(SELECT MAX(amount) FROM recipe WHERE recipe_result.ingredient = ingredient);

--2.4 Podaj listê sk³adników u¿ywanych w wiêcej ni¿ jednej pizzy.
SELECT ingredient FROM recipe GROUP BY ingredient HAVING COUNT(pizza) > 1;
--SELECT DISTINCT(ingredient) FROM recipe AS outer_recipe WHERE ingredient IN(SELECT ingredient FROM recipe AS inner_recipe WHERE
--outer_recipe.ingredient = inner_recipe.ingredient GROUP BY ingredient HAVING count(ingredient) > 1);

--2.5 Podaj wszystkie rodzaje pizzy, które nie s¹ wegetariañskie, tzn. maj¹ przynajmniej jeden sk³adnik miêsny.
SELECT DISTINCT(pizza) FROM recipe WHERE ingredient IN(SELECT ingredient FROM items WHERE type = 'meat');

--2.6 Podaj sk³adniki, których nie ma w ¿adnym przepisie na pizzê.
SELECT ingredient FROM items WHERE ingredient != ALL(SELECT ingredient FROM recipe);

--2.7 Podaj sk³adniki u¿ywane w wiêcej ni¿ jednej pizzy. U¿yj zapytania skorelowanego.
SELECT DISTINCT(ingredient) FROM recipe AS outer_recipe WHERE ingredient IN(SELECT ingredient FROM recipe AS inner_recipe WHERE
outer_recipe.ingredient = inner_recipe.ingredient GROUP BY ingredient HAVING count(ingredient) > 1);

--2.8 Podaj nazwy i ceny tych rodzajów pizzy, których cena mieœci siê pomiêdzy cen¹ pizzy  'napoletana' i 'garlic' (z wy³¹czeniem tych cen)
SELECT pizza, price FROM menu WHERE price < (SELECT MAX(price) FROM menu WHERE pizza IN('napoletana','garlic')) AND 
price > (SELECT MIN(price) FROM menu WHERE pizza IN('napoletana','garlic'));

--2.9 Podaj nazwê pizzy, która ma najwiêcej sk³adników.
SELECT pizza FROM recipe GROUP BY pizza HAVING COUNT(pizza) >= ALL(SELECT COUNT(pizza) FROM recipe GROUP BY pizza);

--2.10 Podaj typy sk³adników u¿ywane w najdro¿szej pizzy w menu.
SELECT DISTINCT(type) FROM items WHERE ingredient IN(SELECT ingredient FROM recipe WHERE pizza in (SELECT pizza FROM menu WHERE price = (SELECT MAX(price) FROM menu)));
