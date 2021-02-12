--1.1 Podaj liczbę wierszy w tabeli MENU.
SELECT COUNT(*) AS Total_pizzas FROM menu

--1.2 Ile jest różnych krajów pochodzenia w tabeli MENU?
SELECT COUNT(DISTINCT(country)) AS Origins FROM menu

--1.3 Podaj cenę najtańszej włoskiej pizzy. 
SELECT MIN(PRICE) AS Cheapest_Italian FROM menu WHERE country = 'Italy'

--1.4 Podaj łączną cenę zamówienia pizzy Margherita i wegetariańskiej (Vegetarian). 
SELECT SUM(price) AS Margherita_Vegetarian FROM menu WHERE pizza IN('margherita','vegetarian')

--1.5 Podaj najniższą, najwyższą i średnią cenę pizzy w MENU.
SELECT MIN(price) AS MIN_PRICE, MAX(price) AS MAX_PRICE, AVG(price) AS AVG_PRICE from menu

--1.6 Ile rodzajów pizzy powstaje na bazie 'wheat mix'?
SELECT COUNT(pizza) AS base_of_wholemeal FROM menu WHERE base = 'wholemeal'

--1.7 Ile rodzajów pizzy nie ma przypisanego kraju pochodzenia?
SELECT COUNT(pizza) AS no_origin FROM menu WHERE country IS NULL

--1.8 Oblicz średni zysk jako 30% dochodu uzyskanego ze sprzedaży 50 pizz w ciągu dnia. Rezultat podaj z dokładnością do dwóch miejsc po przecinku.
SELECT FORMAT(ROUND((AVG(price * 0.3) * 50),2),'N2') AS profit FROM menu

--2.1 Podaj wszystkie składniki wraz z ich typami dla pizzy 'Margherita'.
SELECT RECIPE.ingredient, ITEMS.type FROM recipe INNER JOIN items ON RECIPE.ingredient = ITEMS.ingredient WHERE RECIPE.pizza = 'margherita'

--2.2 Podaj wszystkie składniki typu rybnego używane w pizzach wraz z informacją o nazwie pizzy, w której jest używany.
SELECT ITEMS.ingredient, RECIPE.pizza FROM recipe INNER JOIN items ON ITEMS.ingredient = RECIPE.ingredient WHERE ITEMS.type = 'fish'

--2.3 Podaj wszystkie składniki typu mięsnego używane w pizzach wraz z informacją o nazwie pizzy, w której jest używany.
SELECT ITEMS.ingredient, RECIPE.pizza FROM recipe INNER JOIN items ON ITEMS.ingredient = RECIPE.ingredient WHERE ITEMS.type = 'meat'

--2.4 Podaj nazwy wszystkich rodzajów pizzy, które pochodzą z tego samego kraju, co pizza 'siciliano'. Nie używaj podzapytania.
SELECT menu2.pizza FROM menu AS menu1 INNER JOIN menu AS menu2 ON menu1.country = menu2.country WHERE menu1.pizza = 'siciliano' AND menu2.pizza != 'siciliano'

--2.5 Podaj nazwy i ceny rodzajów pizzy, które kosztują więcej niż 'Quattro Stagioni' Nie używaj podzapytania.
SELECT menu1.pizza, menu1.price FROM menu AS menu1 INNER JOIN menu AS menu2 ON menu1.price > menu2.price WHERE menu2.pizza = 'quattro stagioni'

--2.6 Podaj wszystkie(!) rybne skladniki oraz dodatkowo informację o nazwach pizzy, które je wykorzystują. Rezultat podaj w porządku alfabetycznym względm nazw składników.
SELECT ITEMS.ingredient, RECIPE.pizza FROM recipe RIGHT JOIN items ON RECIPE.ingredient = ITEMS.ingredient WHERE ITEMS.type = 'fish' ORDER BY ITEMS.ingredient ASC

--2.7 Podaj nazwy typów składników używanych w pizzach amerykańskich (tzn. z krajem pochodzenia 'U.S.', 'Mexico' oraz 'Canada')
SELECT DISTINCT(ITEMS.type) FROM items INNER JOIN recipe ON ITEMS.ingredient = RECIPE.ingredient INNER JOIN menu ON MENU.pizza = RECIPE.pizza WHERE MENU.country IN('U.S.', 'Mexico', 'Canada')

--2.8 Które pizze na bazie 'wheat mix' są z owocami?
SELECT MENU.pizza FROM menu INNER JOIN recipe ON MENU.pizza = RECIPE.pizza INNER JOIN ITEMS ON RECIPE.ingredient = ITEMS.ingredient WHERE ITEMS.type = 'fruit' AND  MENU.base = 'wholemeal'