--Name:Md.Moniruzzaman Monir
--ID:1280429

USE master
GO

DROP DATABASE IF EXISTS HouseRentDB
GO

CREATE DATABASE HouseRentDB
ON (
	Name= 'HouseRentDB_Data_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER2022\MSSQL\DATA\HouseRentDB_Data_1.mdf',
	Size= 25MB,
	MaxSize= 100MB,
	FileGrowth= 5%
)
LOG ON (
	Name= 'HouseRentDB_Log_1',
	FileName='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER2022\MSSQL\DATA\HouseRentDB_Log_1.ldf',
	Size= 2MB,
	MaxSize= 25MB,
	FileGrowth= 1%
)
GO

USE HouseRentDB
GO

CREATE TABLE HouseType(
HouseTypeID int PRIMARY KEY NOT NULL,
HouseType varchar(50) NOT NULL
)
GO

CREATE TABLE Properties(
HouseID int PRIMARY KEY NOT NULL ,
HouseAddress varchar(50) NOT NULL,
HouseTypeID int REFERENCES HouseType(HouseTypeID)
)
GO

CREATE TABLE Owners(
OwnerID int PRIMARY KEY NOT NULL,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
OwnerAddress varchar(50) NOT NULL,
OwnerNIDNumber varchar(20) NOT NULL,
ContactNumber varchar(20) NOT NULL
)
GO

CREATE TABLE Tenant(
TenantID int PRIMARY KEY NOT NULL,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
TenantNIDNumber varchar(20) NOT NULL,
TenantOccupation varchar(20) NOT NULL,
ContactNumber varchar(20) NOT NULL
)
GO

CREATE TABLE Agreements(
AgreementID int PRIMARY KEY NOT NULL,
AgreementDesc varchar(200) NOT NULL
)
GO

CREATE TABLE Relations (
OwnerID int REFERENCES Owners(OwnerID),
TenantID int REFERENCES Tenant(TenantID),
HouseID int REFERENCES Properties(HouseID),
AgreementID int REFERENCES Agreements(AgreementID),
AgreementStartDate date NOT NULL,
AgreementEndDate date NOT NULL,
RentStartDate date NOT NULL,
Rent money NOT NULL
)
GO

--ALTER Query
ALTER TABLE Tenant
ADD EmailAddress VARCHAR(100);

--DROP Query
DROP TABLE Tenant

--Example of CTE
WITH Summary AS
(
SELECT AgreementStartDate,AgreementEndDate,SUM(Rent) AS TotalRent
FROM Relations AS R
JOIN Tenant AS T
ON R.TenantID=T.TenantID
GROUP BY AgreementStartDate,AgreementEndDate
)
SELECT Summary.AgreementStartDate,Summary.AgreementEndDate,TotalRent
FROM Summary

--Give an example of SEQUENCE
CREATE SEQUENCE TenantS_T
AS int
START WITH 100 INCREMENT BY 10
MINVALUE 0 MAXVALUE 10000
CYCLE CACHE 10

CREATE TABLE TenantS(
TenantID int Primary Key NOT NULL,
FirstName varchar(20) NOT NULL,
LastName varchar(20) NOT NULL,
TenantNIDNumber varchar(20) NOT NULL,
TenantOccupation varchar(20) NOT NULL,
ContactNumber varchar(20) NOT NULL
)

--Give an example of Using VIEW with Encryption
CREATE VIEW TopPaidTenants
WITH ENCRYPTION
AS
SELECT T.TenantID,(FirstName+' '+LastName) AS TenantName
FROM Tenant AS T JOIN Relations AS R
ON T.TenantID=R.TenantID
WHERE Rent>14000

--Store Procedure With Input & Output Parameter.
CREATE PROC spGetRentWiseTenatName
@rent money,
@tenant varchar(20) OUTPUT
AS
BEGIN
SELECT @tenant=(FirstName+' '+LastName)
FROM Tenant AS T JOIN Relations AS R
ON T.TenantID=R.TenantID
WHERE Rent= @rent
END

--Give an example of Scalar function
CREATE FUNCTION fnRentWiseOwnerName(@rent money)
RETURNS varchar(20)
AS
BEGIN
DECLARE @ownerName varchar(20)
SELECT DISTINCT @ownerName=(FirstName+' '+LastName)
FROM Relations AS R JOIN Owners AS O
ON R.OwnerID=O.OwnerID
WHERE Rent=@rent
RETURN @ownerName
END

--Example of Table function
CREATE FUNCTION fnRentWiseTenantName()
RETURNS TABLE
AS
RETURN
SELECT T.TenantID,(FirstName+' '+LastName) AS TenantName
FROM Tenant AS T JOIN Relations AS R
ON T.TenantID=R.TenantID
WHERE Rent>14000

--Example of Instead of Delete TRIGGER
DROP TRIGGER IF EXISTS trInsteadOfDelete
GO
CREATE TRIGGER trInsteadOfDelete
ON Relations
INSTEAD OF DELETE
AS
BEGIN
DECLARE @rent money
SELECT @rent=Rent FROM deleted
if @rent>10000
BEGIN
RAISERROR('Cannot Delete',16,1)
ROLLBACK
END
else
BEGIN
PRINT 'Deleted Successfully!!'
END
END