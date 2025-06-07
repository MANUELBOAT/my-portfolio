use Sandra;
Create table AIRLINE(
Name Varchar(30),
Age int,
Nationality varchar(30) );
Select * from  AIRLINE;
Insert into AIRLINE(Name,Age,Nationality)
Values('Christabel',43,'Ghanaian'),
      ('Jason',20 , 'Canadian'),
	  ('Pauline',25, 'Nigerian'),
	  ('Abigail',34, 'Kenyan'),
	  ('Adom',33,'Russian');
Select * from AIRLINE;
/*CREATING A  SCALE FUNCTION WITH PARAMETERS*/
 CREATE FUNCTION STUDENTPSinfo(@NAME VARCHAR(50),@COUNTRY VARCHAR(50))
 RETURNS VARCHAR(200)
 AS
 BEGIN
 RETURN(SELECT @NAME+SPACE(2)+@COUNTRY)
 END;
 SELECT dbo.STUDENTPSinfo([NAME],[COUNTRY]) AS [INFO] FROM INFOTECH
 SELECT dbo.STUDENTPSinfo([NAME],[COUNTRY]) AS[INFO] FROM INFOTECH WHERE NAME='SUSANNA WINNI' AND COUNTRY='NIGERIA'

 /*CREATING A SCALE FUNCTION WITH NO PARAMETERS*/
 CREATE FUNCTION dbo.GETSTUDENTfromGH()
 RETURNS INT
 AS BEGIN
 DECLARE @NOofGHSTUDENT INT;
 SELECT @NOofGHSTUDENT = COUNT (*) FROM INFOTECH WHERE COUNTRY ='GHANA';
 RETURN @NOofGHSTUDENT;
 END ;
 GO
 
 SELECT dbo.GETSTUDENTfromGH();
 
 /*creating an inline fuction */
 CREATE FUNCTION dbo.GETSTUDENTbycountry(@COUNTRY VARCHAR(30))
 RETURNS TABLE
 AS
 RETURN(SELECT STUDENTID,NAME,AGE GENDER 
 FROM INFOTECH 
 WHERE COUNTRY= @COUNTRY);

 SELECT *FROM dbo.GETSTUDENTbycountry('GHANA');

 /*CREATING a multiline function*/
-- Create a multiline function to categorize students based on age
CREATE FUNCTION dbo.CategorizeStudentsByAge (@minAge INT, @maxAge INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT 
        NAME,
        AGE,
        CASE 
            WHEN AGE BETWEEN @MinAge AND @MaxAge THEN 'In Range'
            ELSE 'Out of Range'
        END AS AgeCategory
    FROM INFOTECH
);
GO

-- Example usage of the multiline function
DECLARE @MinAge INT = 20;
DECLARE @MaxAge INT = 25;

SELECT *
FROM dbo.CategorizeStudentsByAge(@MinAge, @MaxAge);





