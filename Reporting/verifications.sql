SELECT * FROM dbo.BPASession WHERE sessionnumber = 226617
SELECT * FROM dbo.BPASession where stuff(convert(varchar(20),startdatetime,121),15,19,'00:00') like '2024-02-01 08:%' --2024-02-01 08:00:00.000
SELECT * FROM dbo.BPASession where startdatetime between '2024-01-11 18:00' and '2024-01-11 19:00' order by startdatetime 

--2023-10-28 15:30:02.187	10789
--2023-10-28 16:30:02.187	10789

SELECT DATEDIFF(HH,'2023-08-01 10:21:41.940',GETDATE())

SELECT DATEADD(DD,-2,GETDATE())

declare @period_length_days     as int      = 30

SELECT TOP 1000 sessionnumber, startdatetime, ENDdatetime
FROM dbo.BPASession WHERE DATEDIFF(DD,startdatetime,GETDATE()) <= @period_length_days OR enddatetime IS NULL
ORDER BY startdatetime DESC
--SELECT TOP 1000 sessionnumber, startdatetime, ENDdatetime,
--DATEDIFF(DD,startdatetime,GETDATE()) 
--FROM dbo.BPASession --WHERE DATEDIFF(DD,startdatetime,GETDATE()) <= @period_length_days OR enddatetime IS NULL
--ORDER BY startdatetime DESC