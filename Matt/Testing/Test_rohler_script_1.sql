SELECT TOP (ROUND(DATEDIFF(SECOND, '2024-07-23 06:34:00.010', '2024-07-23 06:24:00.0000000') / 300, 0) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value] 

select DATEDIFF(SECOND, '2024-07-23 06:34:00:010', '2024-07-23 06:24:00.0000000')
select round(DATEDIFF(SECOND, '2024-07-23 06:34:00:010', '2024-07-23 06:24:00.0000000')/300,0)+1
--19/09/2024 12:00:00', '19/09/2024 12:05:00'


select  --top
--(ROUND(DATEDIFF(SECOND, startdatetime,enddatetime) / 300, 0) + 1) 
--                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value] ,
														sessionnumber,startdatetime,enddatetime,DATEDIFF(ss,startdatetime,enddatetime) 'Timediff'
from (
select sessionnumber,startdatetime,
IIF(enddatetime IS NULL,
                                    GETDATE(),
                                    CAST(CAST(CAST(enddatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                         CAST(TIMEFROMPARTS(
                                            DATEPART(HOUR, CAST(enddatetime AS DATETIME)),
                                            (CAST(DATEPART(MINUTE, CAST(enddatetime AS DATETIME)) AS INT) / 5) * 5,
                                            00, 00, 00
                                         ) AS VARCHAR(21)) AS DATETIME2)) as enddatetime
										 from dbo.BPASession
										 )test