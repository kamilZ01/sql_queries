--Zad 1 Zmień strukturę tabeli Product_T poprzez dodanie nowej kolumny QtyOnHand – liczba długości 5 znaków z ograniczeniem tylko do liczb dodatnich.
ALTER TABLE Product_T 
ADD QtyOnHand INT
CONSTRAINT CHK_QtyOnHand CHECK (QtyOnHand >= 0 AND QtyOnHand <= 99999);

--Zad 2 Wprowadź przykładowe dane i sprawdź, czy ograniczenie działa poprawnie.
INSERT INTO Product_T VALUES (28,2,'TV table','Oak',450,0,100000);
INSERT INTO Product_T VALUES (28,2,'TV table','Oak',450,0,-50);
INSERT INTO Product_T VALUES (28,2,'TV table','Oak',450,0,15);
INSERT INTO Product_T VALUES (29,3,'Bedroom Bed','Walnut',1300,0,8);

--Zad 3 Dodaj zamówienie do tabeli Order_T (uwzględnij dane z tabeli Customer_T w celu zachowania zgodności referencyjnej).
INSERT INTO Order_T VALUES (77,14,'2018-09-15','2018-09-17',5,13);

--Zad 4.1 Ile ośrodków pracowniczych (work centers) ma Pine Valley?
SELECT COUNT(*) AS 'Ilość ośrodków pracowniczych' FROM WorkCenter_T;
--Zad 4.2 Gdzie się znajdują?
SELECT WorkCenterLocation FROM WorkCenter_T;

--Zad 5 Podaj dane pracowników, których nazwisko zaczyna się na literę „L”
SELECT * FROM Employee_T WHERE EmployeeName LIKE '% L%';

--Zad 6 Którzy pracownicy zostali zatrudnieni w roku 2005?
SELECT * FROM Employee_T WHERE EmployeeDateHired BETWEEN '20050101' AND '20051231';

--Zad 7 Podaj dane klientów, którzy pochodzą ze stanów California lub Washington. Uporządkuj ich względem kodu pocztowego w porządku malejącym.
SELECT * FROM Customer_T WHERE CustomerState IN('CA','WA') ORDER BY CustomerPostalCode DESC;

--Zad 8 Podaj listę wszystkich surowców (raw materials), które są wykonane z drzewa wiśniowego (cherry) i mają rozmiary (grubość i szerokość) 12 na 12.
SELECT * FROM RawMaterial_T WHERE Material = 'Cherry' AND Thickness = '12' AND Width = '12';

--Zad 9 Podaj dane: MaterialID, MaterialName, Material, MaterialStandardPrice oraz Thickness dla wszystkich surowców wykonanych z drzewa wiśniowego (cherry), sosnowego (pine) lub orzecha (walnut). Posortuj je po materiale, cenie standardowej oraz grubości.
SELECT MaterialID, MaterialName, Material, MaterialStandardPrice, Thickness FROM RawMaterial_T WHERE Material IN('cherry','pine','walnut')
ORDER BY Material,MaterialStandardPrice,Thickness;

--Zad 10 Wyświetl identyfikator linii produkcyjnej i średnią standardową cenę wszystkich produktów dla każdej z linii produkcyjnej.
SELECT ProductLineID, AVG(ProductStandardPrice) AS 'Średnia standardowa cena' FROM Product_T GROUP BY ProductLineID;

--Zad 11  Uwzględnij w wynikach z poprzedniego zapytania tylko te produkty, których cena standardowa jest większa niż $200 i linie produkcyjne o średniej cenie standardowej równej przynajmniej $500.
SELECT ProductLineID, AVG(ProductStandardPrice) AS 'Średnia standardowa cena' FROM Product_T 
WHERE ProductStandardPrice > 200 GROUP BY ProductLineID 
HAVING AVG(ProductStandardPrice) >= 500;

--Zad 12 Dla każdego zamówionego produktu wyświetl jego identyfikator I sumaryczną zamówioną liczbę (nazwij kolumnę TotalOrdered). Posortuj wyniki względem popularności produktów.
SELECT ProductID, SUM(OrderedQuantity) AS 'Total Ordered' FROM OrderLine_T GROUP BY ProductID ORDER BY 'Total Ordered' DESC;

--Zad 13 Dla każdego zamówienia wyświetl jego numer oraz liczbę produktów w zamówieniu.
SELECT OrderID, SUM(OrderedQuantity) AS 'Liczba produktów w zamówieniu' FROM OrderLine_T GROUP BY OrderID;

--Zad 14 Dla każdego klienta wyświetl jego identyfikator i całkowitą liczbę zamówień.
SELECT CustomerID, COUNT(OrderID) AS 'Ilość zamówień klienta' FROM Order_T GROUP BY CustomerID;

--Zad 15 Dla każdego sprzedawcy wyświetl wszystkie identyfikatory jego klientów.
SELECT DISTINCT SalespersonID, CustomerID FROM Order_T WHERE SalespersonID IS NOT NULL;

--Zad 16 Dla każdego produktu wyświetl jego identyfikator i liczbę zamówień na ten produkt. Wynik uporządkuj malejąco względem liczby zamówień – nazwij kolumnę NumOrders.
SELECT ProductID, Count(OrderID) AS 'NumOrders' FROM OrderLine_T GROUP BY ProductID ORDER BY 'NumOrders' DESC;

--Zad 17 Dla każdej płatności po 10 marca 2018 wyświetl numer płatności, numer zmówienia, kwotę płatności i 10 pierwszych znaków z komentarza o płatności (PaymentComment).
SELECT PaymentID, OrderID, PaymentAmount, SUBSTRING(PaymentComment,1,10) AS 'PaymentComment' FROM Payment_T WHERE PaymentDate > '20180310';

--Zad 18 Dla każdego klienta wyświetl jego numer oraz liczbę zamówień zrealizowanych po roku 2018.
SELECT CustomerID, Count(OrderID) AS 'Ilość zamówień' FROM Order_T WHERE FulfillmentDate > '20181231' GROUP BY CustomerID;

--Zad 19  Dla każdego sprzedawcy podaj całkowitą liczbę zrealizowanych przez niego zamówień.
SELECT SalespersonID, COUNT(OrderID) AS 'Ilość zrealizowanych zamówień' FROM Order_T WHERE SalespersonID IS NOT NULL GROUP BY SalespersonID 

--Zad 20 Dla każdego klienta, który miał więcej niż 2 zamówienia, podaj jego identyfikator w liczbę zamówień.
SELECT CustomerID, COUNT(OrderID) AS 'Liczba zamówień' FROM Order_T GROUP BY CustomerID HAVING COUNT(OrderID) > 2;

--Zad 21 Podaj listę wszystkich obszarów sprzedaży (TerritoryID), które mają więcej niż jednego sprzedawcę – podaj tę liczbę.
SELECT SalesTerritoryID, COUNT(SalespersonID) AS 'Liczba sprzedawców' FROM Salesperson_T GROUP BY SalesTerritoryID HAVING COUNT(SalespersonID) > 1;

--Zad 22 Dla pracowników, którzy mieszkają w TN lub FL, podaj wiek ich zatrudnienia.
SELECT EmployeeID, (YEAR(EmployeeDateHired) - YEAR(EmployeeBirthDate)) AS 'Wiek zatrudnienia' FROM Employee_T 
WHERE EmployeeState IN ('TN','FL') AND EmployeeDateHired IS NOT NULL AND EmployeeBirthDate IS NOT NULL;

--Zad 23 Podaj MaterialName, Material oraz szerokość (Width) dla wszystkich surowców,które nie są z drzewa czereśniowego lub dębu, których szerokość jest większa niż 10 cali.
SELECT MaterialName, Material, Width FROM RawMaterial_T WHERE Material NOT IN('Cherry','Oak') AND Width > 10;

--Zad 24 Podaj dane: ProductID, ProductDescription, ProductFinish, ProductStandardPrice dla produktów dębowych o cenie standardowej większej niż $400 oraz produktów z drzewa wiśniowego o cenie standardowej mniejszej niż $300.
SELECT ProductID, ProductDescription, ProductFinish, ProductStandardPrice FROM Product_T 
WHERE (ProductFinish = 'Oak' AND ProductStandardPrice > 400) OR (ProductFinish = 'Cherry' AND ProductStandardPrice < 300);