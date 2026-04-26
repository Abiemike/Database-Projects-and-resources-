

--Q#1
SELECT DISTINCT sl.login AS [User_login],sl.Full_Name AS [User Name], 
sl.Phone_Number AS [User Phone]
FROM Security_Logins sl
JOIN Security_Logins_Log sll ON sl.Id = sll.Login
WHERE sll.Logon_Date < '2017-01-01'
  AND sl.login NOT IN (
      SELECT sl2.login
      FROM Security_Logins sl2
      JOIN Security_Logins_Log sll2 ON sl2.Id = sll2.Login
      WHERE sll2.Logon_Date BETWEEN '2017-01-01' AND '2017-12-31'
  );
  --=============================================================
  --Q#2
SELECT DISTINCT cd.Company_Name AS [Company Name], cd.LanguageID AS [language]

FROM [dbo].[Applicant_Job_Applications] aja
JOIN [dbo].[Company_Jobs] cj ON aja.Job = cj.ID
JOIN [dbo].[Company_Descriptions] cd ON cj.Company = cd.Company
WHERE cd.LanguageID = 'EN'
GROUP BY cd.Company_Name,cd.LanguageID
HAVING COUNT(aja.ID) >= 10
ORDER BY cd.Company_Name;


-----------------============================
--Q#3

--SELECT  Full_name, id , login FROM  [dbo].[Security_Logins]

--SELECT Current_Salary, login,  Currency FROM  [dbo].[Applicant_Profiles] ap

WITH Ranked_HighestSalaries AS (
    SELECT 
        ap.ID, sl.Login AS Applicant_Name, ap.Current_Salary,  ap.Currency,
        ROW_NUMBER() OVER (PARTITION BY ap.Currency ORDER BY ap.Current_Salary DESC) AS SalaryRank
    FROM [dbo].[Applicant_Profiles] ap
    JOIN [dbo].[Security_Logins] sl ON ap.Login = sl.Id
)
SELECT 
    Applicant_Name, Current_Salary,  Currency
FROM Ranked_HighestSalaries
WHERE SalaryRank = 1;

---=========================================================
-- q#4 
SELECT cd.Company_Name AS [Company Name],
       ISNULL(COUNT(cj.ID), 0) AS [Number of Jobs Posted]
FROM [dbo].[Company_Profiles] cp
JOIN [dbo].[Company_Descriptions] cd ON cp.ID = cd.Company
LEFT JOIN [dbo].[Company_Jobs] cj ON cp.ID = cj.Company
WHERE cd.LanguageID = 'EN'
GROUP BY cd.Company_Name
ORDER BY [Number of Jobs Posted] DESC, cd.Company_Name;
	---------------========================================
-- Q#5
	SELECT
    'Companies taht have Posted a Jobs' AS [Company Status],
    COUNT(DISTINCT cp.ID) AS [Total Number]
FROM 
    [dbo].[Company_Profiles] cp
JOIN
    [dbo].[Company_Jobs] cj ON cp.ID = cj.Company

UNION 

SELECT
    'Companies that have never posted a jobs ' AS [Company Status],
    COUNT(DISTINCT cp.ID) AS [Total Number]
FROM
    [dbo].[Company_Profiles] cp
LEFT JOIN
    [dbo].[Company_Jobs] cj ON cp.ID = cj.Company
WHERE
    cj.Company IS NULL

	
	