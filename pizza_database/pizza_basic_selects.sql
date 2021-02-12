--3.1 Podaj listę wszystkich pozycji z menu w porządku alfabetycznym. Uwzględnij wszystkie kolumny.
SELECT * FROM menu ORDER BY pizza ASC

--3.2 Podaj listę wszystkich pozycji z tabeli menu sortując je według ceny malejąco oraz według nazwy rosnąco. Uwzględnij wszystkie kolumny.
SELECT * FROM menu ORDER BY price DESC, pizza ASC

--3.3 Podaj listę wszystkich cen uwzględnionych w tabeli MENU – nie wyświetlaj duplikatów.
SELECT distinct price FROM menu

--3.4 Podaj listę wszystkich włoskich pizz, które kosztują mniej niż $7.00.
SELECT * FROM menu WHERE country = 'italy' AND price < 7

--3.5 Podaj listę wszystkich pizz, dla których krajem pochodzenia nie są Włochy lub USA.
SELECT * FROM menu WHERE country NOT IN('Italy','U.S.') OR country IS NULL

--3.6 Na podstawie tabeli MENU podaj informacje dotyczące pizz: Vegetarian, Americano, Mexicano oraz garlic.
SELECT * FROM menu WHERE pizza IN('vegetarian','americano','mexicano','garlic')

--3.7 Podaj nazwy i ceny wszystkich pizz, które kosztują pomiędzy 6 i 7 dolarów.
SELECT * FROM menu WHERE price between 6 AND 7

--3.8 Podaj listę wszystkich pizz, których nazwa kończy się końcówką 'ano'.
SELECT * FROM menu WHERE pizza LIKE '%ano'

--3.9 Podaj listę wszystkich pizz (nazwa, cena, kraj pochodzenia), dla których został wskazany kraj pochodzenia.
SELECT pizza,price,country FROM menu WHERE country IS NOT NULL

--3.10 Na podstawie tabeli z przepisami podaj w porządku malejącym liczby wszystkich różnych ilości przypraw (spice) wskazanych w przepisach.
SELECT ingredient, SUM(amount) AS amount FROM recipe GROUP BY ingredient ORDER BY amount DESC