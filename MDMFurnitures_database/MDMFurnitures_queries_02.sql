--Zad 1 Podaj dane klientów, którzy nie maj¹ ¿adnych zamówieñ.
SELECT * FROM Customer_T WHERE CustomerID NOT IN(SELECT CustomerID FROM Order_T);

--Zad 2 Podaj nazwy linii produkcyjnych i dla ka¿dej linii liczbê produkowanych produktów oraz ich œredni¹ cenê.
SELECT PL.ProductLineName, COUNT(P.ProductID) AS 'Liczba produkowanych produktów', AVG(P.ProductStandardPrice) AS 'Œrednia cena produktów' 
FROM ProductLine_T AS PL INNER JOIN Product_T AS P
ON PL.ProductLineID = P.ProductLineID GROUP BY PL.ProductLineName;

--Zad 3 Zmodyfikuj poprzednie zapytanie tak, ¿eby uwzglêdniane by³y tylko linie o œredniej cenie wy¿szej ni¿ $200.
SELECT PL.ProductLineName, COUNT(P.ProductID) AS 'Liczba produkowanych produktów', AVG(P.ProductStandardPrice) AS 'Œrednia cena produktów' 
FROM ProductLine_T AS PL INNER JOIN Product_T AS P
ON PL.ProductLineID = P.ProductLineID GROUP BY PL.ProductLineName HAVING AVG(P.ProductStandardPrice) > 200;

--Zad 4 Podaj nazwiska i numery pracowników dla ka¿dego prze³o¿onego, który ma wiêcej ni¿ 2 podw³adnych.
SELECT EmployeeName, EmployeeID FROM Employee_T WHERE EmployeeSupervisor IN(
SELECT EmployeeSupervisor FROM Employee_T GROUP BY EmployeeSupervisor HAVING COUNT(EmployeeSupervisor) > 2);

SELECT A.EmployeeName, A.EmployeeID FROM Employee_T AS A JOIN Employee_T AS B ON A.EmployeeSupervisor = B.EmployeeSupervisor
GROUP BY A.EmployeeName, A.EmployeeID HAVING COUNT(B.EmployeeSupervisor) > 2

--Zad 5 Podaj nazwisko pracownika, datê urodzenia, nazwisko prze³o¿onego i datê urodzenia prze³o¿onego dla tych pracowników, którzy s¹ starsi ni¿ ich prze³o¿ony.
SELECT E.EmployeeName, E.EmployeeBirthDate, ES.EmployeeName, ES.EmployeeBirthDate FROM Employee_T AS E JOIN Employee_T AS ES
ON E.EmployeeSupervisor = ES.EmployeeID WHERE E.EmployeeBirthDate < ES.EmployeeBirthDate;

--Zad 6 Wyœwietl numer zamówienia, numer klienta, datê zamówienia i zamówione produkty dla ka¿dego z klientów.
SELECT O.OrderID, O.CustomerID, O.OrderDate, OL.ProductID FROM Order_T AS O JOIN OrderLine_T AS OL 
ON O.OrderID = OL.OrderID ORDER BY O.CustomerID;

--Zad 7 Wyœwietl wszystkie produkty, ich cenê standardow¹ oraz cenê ca³kowit¹ dla zamówienia o numerze 1.
SELECT P.ProductID, P.ProductStandardPrice, (P.ProductStandardPrice * OL.OrderedQuantity) AS 'Cena ca³kowita'  FROM Product_T AS P JOIN OrderLine_T AS OL
ON P.ProductID = OL.ProductID WHERE OL.OrderID = 1;

--Zad 8 Podaj liczbê pracowników zatrudnionych w ka¿dym oddziale (work center).
SELECT WC.WorkCenterID, COUNT(WI.WorkCenterID) AS 'Liczba zatrudnionych pracowników' FROM WorkCenter_T AS WC FULL JOIN 
WorksIn_T AS WI ON WC.WorkCenterID = WI.WorkCenterID GROUP BY WC.WorkCenterID;

--Zad 9 Wska¿ oddzia³y, które zatrudniaj¹ przynajmniej jedn¹ osobê o umiejêtnoœciach „QC1”
SELECT WorkCenterID FROM WorksIn_T WHERE EmployeeID IN(SELECT EmployeeID FROM EmployeeSkills_T WHERE SkillID = 'QC1');

--Zad 10 Podaj cenê ca³kowit¹ dla zamówienia numer 1.
SELECT SUM(P.ProductStandardPrice * OL.OrderedQuantity) AS 'Cena ca³kowita'  FROM Product_T AS P JOIN OrderLine_T AS OL
ON P.ProductID = OL.ProductID WHERE OL.OrderID = 1;

--Zad 11 Dla ka¿dego dostawcy (vendor) wska¿ te materia³y, dla których cena jednostkowa jest przynajmniej czterokrotnoœci¹ ceny standardowej.
SELECT S.VendorID, S.MaterialID, S.SupplyUnitPrice, R.MaterialStandardPrice FROM Supplies_T AS S join RawMaterial_T AS R 
ON S.MaterialID = R.MaterialID WHERE S.SupplyUnitPrice >= R.MaterialStandardPrice * 4;

--Zad 12 Oblicz koszt surowców dla ka¿dego z produktów w porównaniu do jego ceny standardowej. Podaj identyfikator produktu, opis produktu, cenê standardow¹ oraz koszt produktu.
SELECT P.ProductID, P.ProductDescription, P.ProductStandardPrice, SUM(U.QuantityRequired* R.MaterialStandardPrice) AS 'Koszt wyprodukowania'
FROM Product_T AS P join Uses_T AS U ON P.ProductID = U.ProductID join RawMaterial_T AS R ON U.MaterialID = R.MaterialID 
GROUP BY P.ProductID, P.ProductDescription, P.ProductStandardPrice;

--Zad 13 Dla ka¿dego zamówienia wyœwietl jego identyfikator oraz kwotê, która pozosta³a do zap³aty – na podstawie informacji, ile nale¿y zap³aciæ i ile zosta³o zap³acone. Zak³adamy, ¿e dane zamówienie mo¿e mieæ wiele p³atnoœci.
SELECT PA.OrderID, COALESCE(SUM(P.ProductStandardPrice * OL.OrderedQuantity),0) - SUM(DISTINCT PA.PaymentAmount) AS 'Kwota pozosta³a do zap³aty' 
FROM Payment_T AS PA
FULL JOIN Order_T AS O ON PA.OrderID = O.OrderID
FULL JOIN OrderLine_T AS OL ON O.OrderID = OL.OrderID
FULL JOIN Product_T AS P ON OL.ProductID = P.ProductID
WHERE PA.OrderID IS NOT NULL
GROUP BY PA.OrderID

--Zad 14 Podaj informacje o klientach, którzy kupili biurka komputerowe (computer desk). Podaj równie¿ zakupion¹ ich liczbê.
SELECT C.*, SUM(OL.OrderedQuantity) as 'Iloœæ zamówionych sztuk' FROM Customer_T as C join Order_T as O on C.CustomerID = O.CustomerID join OrderLine_T as OL on O.OrderID = OL.OrderID
join Product_T AS P on OL.ProductID = P.ProductID where P.ProductDescription like '%computer desk%' 
group by C.CustomerAddress, C.CustomerCity, C.CustomerID, C.CustomerName, C.CustomerPostalCode, C.CustomerState, P.ProductDescription;

--Zad 15 Podaj dane klientów, którzy kupili produkty z linii Basic w marcu 2018 roku. Nie duplikuj rezultatów.
SELECT DISTINCT C.* FROM Customer_T as C join Order_T as O on C.CustomerID = O.CustomerID join OrderLine_T as OL on O.OrderID = OL.OrderID
join Product_T AS P on OL.ProductID = P.ProductID join ProductLine_T AS PL ON P.ProductLineID = PL.ProductLineID 
WHERE PL.ProductLineName = 'Basic' AND O.OrderDate BETWEEN '20180301' AND '20180331';

SELECT * FROM Customer_T WHERE CustomerID IN(SELECT CustomerID FROM Order_T WHERE OrderDate BETWEEN '20180301' AND '20180331' AND OrderID IN(
SELECT OrderID FROM OrderLine_T WHERE ProductID IN(SELECT ProductID FROM Product_T WHERE ProductLineID IN(
SELECT ProductLineID FROM ProductLine_T WHERE ProductLineName = 'Basic'))));

--Zad 16 Zmodyfikuj poprzednie zapytanie tak, ¿eby uwzglêdnia³o równie¿ liczbê produktów zakupionych w marcu 2018.
SELECT C.*, SUM(OL.OrderedQuantity) AS 'Liczba zakupionych produktów' FROM Customer_T AS C join Order_T AS O ON C.CustomerID = O.CustomerID join OrderLine_T AS OL ON O.OrderID = OL.OrderID
join Product_T AS P on OL.ProductID = P.ProductID join ProductLine_T AS PL ON P.ProductLineID = PL.ProductLineID 
WHERE PL.ProductLineName = 'Basic' AND O.OrderDate BETWEEN '20180301' AND '20180331'
GROUP BY C.CustomerID, C.CustomerAddress, C.CustomerCity, C.CustomerName, C.CustomerPostalCode, C.CustomerState;

--Zad 17 Podaj w porz¹dku alfabetycznym i bez powtórzeñ listê pracowników (managerów), którzy s¹ prze³o¿onymi pracowników o identyfikatorze umiejêtnoœci „BS12”.
SELECT DISTINCT  E.* from Employee_T as E join Employee_T as EM on E.EmployeeID = EM.EmployeeSupervisor join EmployeeSkills_T as ES 
on EM.EmployeeID = ES.EmployeeID where ES.SkillID = 'BS12' order by E.EmployeeName;

--Zad 18 Podaj nazwisko sprzedawcy, nazwê wykoñczenia oraz liczbê sprzedanych produktów dla tego wykoñczenia.
SELECT S.SalespersonName, P.ProductFinish, SUM(OL.OrderedQuantity) AS 'Iloœæ sprzedanych produktów' FROM Salesperson_T AS S join Order_T AS O 
ON S.SalespersonID = O.SalespersonID join OrderLine_T AS OL ON O.OrderID = OL.OrderID join Product_T AS P ON OL.ProductID = P.ProductID
GROUP BY S.SalespersonName, P.ProductFinish ORDER BY S.SalespersonName;

--Zad 19 Podaj liczbê produktów wyprodukowanych w ka¿dym oddziale (work center). uwzglêdnij oddzia³y bez produktów.
SELECT WC.WorkCenterID, COUNT(PR.ProductID) AS 'Liczba ró¿nych produkowanych produktów' FROM WorkCenter_T AS WC FULL JOIN ProducedIn_T AS PR 
ON WC.WorkCenterID = PR.WorkCenterID GROUP BY WC.WorkCenterID;

--Zad 20 Podaj listê klientów oraz liczbê dostawców z tego samego stanu, co dany klient.
SELECT C.*, count(V.VendorID) as 'Iloœæ dostawców z tego samego stanu' FROM Customer_T AS C join Vendor_T as V on C.CustomerState = V.VendorState 
group by C.CustomerID, C.CustomerCity, C.CustomerAddress, C.CustomerName, C.CustomerPostalCode, C.CustomerState;

--Zad 21 Podaj identyfikatory klientów, którzy nie dokonali jeszcze ¿adnej p³atnoœci. 
SELECT CustomerID FROM Customer_T WHERE CustomerID NOT IN(SELECT DISTINCT CustomerID FROM Order_T WHERE OrderID = ANY(SELECT OrderID FROM Payment_T));

--Zad 22 Podaj nazwy stanów, w których s¹ klienci, ale nie ma tam sprzedawców. 
SELECT DISTINCT CustomerState from Customer_T where CustomerState NOT IN(SELECT SalespersonState from Salesperson_T WHERE SalespersonState IS NOT NULL);

--Zad 23 Podaj dane produktów z uwzglêdnieniem ich opisów oraz informacji o liczbie zamówieñ. Uwzglêdnij równie¿ produkty bez zamówieñ.
SELECT P.*, SUM(OL.OrderedQuantity) as 'Iloœæ zamówionych produktów' from Product_T as P full join OrderLine_T as OL on P.ProductID = OL.ProductID 
group by P.ProductDescription, P.ProductFinish, P.ProductID, P.ProductLineID, P.ProductOnHand, P.ProductStandardPrice, P.QtyOnHand

--Zad 24 Podaj dane klientów i numery ich zamówieñ. Uwzglêdnij klientów bez zamówieñ.
SELECT C.*, O.OrderID from Customer_T as C full join Order_T as O on C.CustomerID = O.CustomerID

--Zad 25 Podaj numery zamówieñ oraz liczbê zamówionych elementów dla tych zamówieñ, w których ta liczba jest wiêksza ni¿ œrednia liczba z zamówieñ dla tego produktu.
SELECT OL.OrderID, OL.ProductID, OL.OrderedQuantity from OrderLine_T AS OL JOIN OrderLine_T AS OLP ON OL.ProductID = OLP.ProductID
GROUP BY OL.OrderID, OL.ProductID, OL.OrderedQuantity
HAVING OL.OrderedQuantity > AVG(OLP.OrderedQuantity)

--Zad 26 Dla ka¿dego stanu podaj informacje o wszystkich pracownikach oprócz ostatnio zatrudnionego.
SELECT * FROM Employee_T AS e1 WHERE EmployeeDateHired != 
(SELECT MAX(EmployeeDateHired) FROM Employee_T AS e2 WHERE e2.EmployeeState = e1.EmployeeState)

--Zad 27 Dla ka¿dego produktu podaj w porz¹dku rosn¹cym informacje o tym produkcie (identyfikator, nazwa, opis) oraz o kliencie, który kupi³ tego produktu najwiêcej. U¿yj zapytania skorelowanego.
SELECT DISTINCT P.ProductID, P.ProductFinish ,P.ProductDescription, C.* FROM Customer_T AS C 
JOIN Order_T AS O ON O.CustomerID = C.CustomerID
JOIN OrderLine_T AS OL ON O.OrderID  = (
	SELECT TOP 1 OrderID FROM OrderLine_T
	WHERE ProductID = OL.ProductID
	GROUP BY ProductID,OrderID
	ORDER BY ProductID,SUM(OrderedQuantity) DESC
)
FULL JOIN Product_T AS P ON OL.ProductID=P.ProductID
ORDER BY P.ProductID, P.ProductFinish ,P.ProductDescription 