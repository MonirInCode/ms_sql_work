----Name:Md.Moniruzzaman Monir
----ID:1280429

USE HouseRentDB
GO
INSERT INTO HouseType VALUES
(1,'Apartment'),
(2,'3 Bed Room'),
(3,'Independent'),
(4,'Studio')
GO
INSERT INTO Properties VALUES
(101,'33/A,ABC,Mohammadpur',1),
(102,'43/B,BCA,Mirpur',2),
(103,'55/C,CBC,Farmgate',3),
(104,'23/E,EEC,Dhanmondi',4),
(105,'12/A,BCA,Mirpur',2),
(106,'65/D,MMM,Bakshibazar',4),
(107,'35/A,BBB,Mohammadpur',3),
(108,'40/A,BBB,Mohammadpur',1)
GO
INSERT INTO Owners VALUES
(201,'Karim','Ahmed','21/A,abc,Mirpur,Dhaka','3302384321','01775-435795'),
(202,'Zakir','Hossain','33/B,def,Ghatail,Tangail','2356598745','01652-454555'),
(203,'Saiful','Islam','25/C,ghi,Monohordi,Narshingdhi','2302549854','01924-545454'),
(204,'Azizul','Haque','29/D,jkl,Bhuapur,Tangail','3502374322','01775-533985'),
(205,'Kawser','Hossain','67/E,mno,Mohammadpur,Dhaka','2135698524','01553-659874'),
(206,'Rakib','Hossain','77/F,pqr,Motijheel,Dhaka','5632598415','01652-356985'),
(207,'Mansur','Sarkar','45/G,stu,Karatia,Tangail','4003321000','01776-532413')
GO
INSERT INTO Tenant VALUES
(301,'Ariful','Islam','789654123','Teacher','01234-567891'),
(302,'Rahim','Mia','987456321','Doctor','01234-567892'),
(303,'Rayhan','Ahmed','598325698','Business','01234-567893'),
(304,'Forhad','Ahmed','454648945','Engineer','01234-567894'),
(305,'Rasel','Mia','565564565','Business','01234-567895'),
(306,'Munna','Ahmed','568674446','Graphic Designer','01234-567896'),
(307,'Rubel','Mia','356745454','Teacher','01234-567897'),
(308,'Nayeem','Hossain','235641655','Doctor','01234-567898'),
(309,'Juwel','Mia','354415453','Software Engineer','01234-567899'),
(310,'Monir','Hossain','244545645','Social Worker','01234-567890')
GO
INSERT INTO Agreements VALUES
(401,'Have to pay 1 month rent in advance'),
(402,'Must inform 1 month before leaving home'),
(403,'Rent must be paid before 5th of every month')
GO
INSERT INTO Relations VALUES
(201,301,101,401,'01/01/2023','11/01/2023','02/01/2023',10000),
(202,302,102,402,'02/01/2023','12/01/2023','02/02/2023',12000),
(201,303,101,401,'11/02/2023','12/31/2024','12/01/2023',10000),
(203,304,103,403,'02/01/2023','02/01/2024','04/02/2023',16000),
(204,305,104,402,'01/01/2023','08/01/2023','02/02/2023',15000),
(204,306,104,402,'08/02/2023','12/01/2024','01/01/2024',15000),
(205,307,105,401,'04/01/2023','03/01/2024','05/01/2023',11000),
(206,308,106,402,'04/01/2023','03/01/2024','05/02/2023',17000),
(207,309,107,403,'09/01/2023','08/01/2024','10/01/2023',15000),
(207,310,108,403,'08/01/2023','09/01/2024','10/01/2023',14000)
GO

--INSERT Query
INSERT INTO Tenant VALUES
(311,'Azizur','Rahman','253035400','Teacher','01580-467878')

--UPDATE Query
UPDATE Tenant
SET ContactNumber = '01580-467877'
WHERE TenantID=311

--DELETE Query
DELETE FROM Tenant
WHERE TenantID=311

--Give an example of using AND Clause
SELECT TenantID,HouseID,RentStartDate,Rent
FROM Relations
WHERE RentStartDate > '10-1-2023' AND
Rent>10000

--Give an example of using NOT IN Clause
SELECT T.TenantID,FirstName,LastName,TenantOccupation,RentStartDate
FROM Tenant as T 
JOIN Relations as R
ON R.TenantID=T.TenantID
WHERE TenantOccupation NOT IN ('Teacher','Doctor')
AND RentStartDate > '2-1-2023'

--Give an example of BETWEEN Clause
SELECT T.TenantID,FirstName,LastName,TenantNIDNumber,TenantOccupation,RentStartDate
FROM Tenant AS T
JOIN Relations AS R
ON T.TenantID=R.TenantID
WHERE RentStartDate BETWEEN '05-01-2023' AND '10-01-2023'

--Give an example of using WILDCARD
SELECT * FROM Tenant
WHERE TenantOccupation LIKE 'SO%'

--Give an example of using LIKE and WILDCARD
SELECT (FirstName+' '+LastName) AS ContactName
FROM Tenant
WHERE (FirstName+' '+LastName) LIKE '[aeiou]%'

--Give an example of OFFSET FETCH 
SELECT * FROM Tenant
ORDER BY TenantID
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY

--Example of CUBE Operator.
SELECT HouseID,AVG(Rent) AS RentAvg
FROM Relations
GROUP BY CUBE (HouseID)

--Example of ROLLUP Operator.
SELECT HouseID,AVG(Rent) AS RentAvg
FROM Relations
GROUP BY ROLLUP (HouseID)

--Example of GROUPING SETS Operator.
SELECT HouseID,AVG(Rent) AS RentAvg
FROM Relations
GROUP BY GROUPING SETS (HouseID)

--Example of OVER Operator
SELECT RentStartDate,
AVG(Rent) OVER (PARTITION BY RentStartDate) AS AvgHouseRent,
SUM(Rent) OVER (PARTITION BY RentStartDate) AS SumHouseRent
FROM Relations

--Give an example of SUBQUERY
SELECT FirstName,LastName,AgreementID,Rent FROM Relations AS R
JOIN Tenant AS T
ON R.TenantID=T.TenantID
WHERE R.TenantID IN
(SELECT TenantID FROM Tenant)

--Give an example of ANY
SELECT FirstName,LastName,AgreementID,AVG(Rent) AS AvgRentAmount
FROM Relations AS R
JOIN Tenant AS T
ON R.TenantID=T.TenantID
GROUP BY FirstName,LastName,AgreementID
HAVING AVG(Rent)>ANY
(SELECT TenantID FROM Tenant)

--Give an example of ALL
SELECT FirstName,LastName,AgreementID,AVG(Rent) AS AvgRentAmount
FROM Relations AS R
JOIN Tenant AS T
ON R.TenantID=T.TenantID
GROUP BY FirstName,LastName,AgreementID
HAVING AVG(Rent)>ALL
(SELECT TenantID FROM Tenant)

--Example of SOME
SELECT FirstName,LastName,AgreementID,AVG(Rent) AS AvgRentAmount
FROM Relations AS R
JOIN Tenant AS T
ON R.TenantID=T.TenantID
GROUP BY FirstName,LastName,AgreementID
HAVING AVG(Rent)>SOME
(SELECT TenantID FROM Tenant)

--Give an example CORRELATED SUBQUERY.
SELECT OwnerID,TenantID,Rent FROM Relations
WHERE Rent>
(SELECT AVG(Rent) FROM Relations)

--Example of CASE function
SELECT TenantID,Rent,
CASE
	WHEN Rent=10000 THEN 'You rent a Mobile home'
	WHEN Rent=14000 THEN 'You rent a Single-family houses'
	WHEN Rent>15000 THEN 'You rent a Multiple-family houses'
	ELSE 'You rent a Apartments'
END AS Housing_Classifications
FROM Relations

--Example of IIF function
SELECT TenantID,Rent,
IIF(Rent<14000,'Low','High') AS RentRange
FROM Relations

--Statement of Cast
SELECT CAST('2023-04-02' AS datetime) AS CastDateTime

--Statement of Convert
SELECT CONVERT(TIME,'2023-04-02') AS ConvertedTime

--Example of MERGE
MERGE TenantArchive AS ta
USING TenantCopy AS tc
ON tc.TenantID=ta.TenantID
WHEN MATCHED AND 
tc.ContactNumber IS NOT NULL
THEN
UPDATE SET ta.TenantNIDNumber=tc.TenantNIDNumber,
ta.TenantOccupation=tc.TenantOccupation
WHEN NOT MATCHED
THEN
INSERT(TenantID,FirstName,LastName,TenantNIDNumber,TenantOccupation,ContactNumber)
VALUES(tc.TenantID,tc.FirstName,tc.LastName,
tc.TenantNIDNumber,tc.TenantOccupation,tc.ContactNumber);

--Insert by SEQUENCE
INSERT INTO TenantS VALUES
(NEXT VALUE FOR TenantS_T,'Ariful','Islam','3302374256','Software Developer','01775435695')

--justification of VIEW
SELECT * FROM TopPaidTenants

--Justification of Store Procedure
DECLARE @tenant varchar(20)
EXEC spGetRentWiseTenatName 15000,@tenant OUTPUT
PRINT @tenant

--Justification of Scalar Function
SELECT dbo.fnRentWiseOwnerName(10000)

--Justification of Table Valued Function
SELECT * FROM dbo.fnRentWiseTenantName()

--Justification of Instead of Delete TRIGGER
DELETE FROM Relations
WHERE Rent= 12000