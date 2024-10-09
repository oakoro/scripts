select  
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
							where DATEDIFF(ss,startdatetime,enddatetime)  < -599


SELECT ROUND(DATEDIFF(SECOND, '2024-09-23 17:44:43.147', '2024-09-23 17:12:23.4166667')/300,0)--+1;
SELECT ABS(DATEDIFF(SECOND, '2024-09-23 17:44:43.147', '2024-09-23 17:12:23.4166667'));
SELECT DATEDIFF(SECOND, '2024-09-23 17:44:43.147', '2024-09-23 17:12:23.4166667');
GO
SELECT TOP (ROUND(DATEDIFF(SECOND, '2024-09-23 17:44:43.147', '2024-09-23 17:12:23.4166667') / 300, 0) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value] ;
GO
SELECT TOP (abs(DATEDIFF(SECOND, '2024-09-23 17:44:43.147', '2024-09-23 17:12:23.4166667')) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) AS [value] 
	go													

--select DATEDIFF(SECOND, '2024-09-23 17:44:43.147', '2024-09-23 17:12:23.4166667')
