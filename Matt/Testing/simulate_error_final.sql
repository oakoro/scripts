 declare @startdatetime datetime = '2024-09-25 11:37:58.717', @enddatetime datetime --= '2024-09-23 12:05:29.707'
 select
 CAST(CAST(CAST(@startdatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                 CAST(TIMEFROMPARTS(
                                    DATEPART(HOUR, CAST(@startdatetime AS DATETIME)),
                                    (CAST(DATEPART(MINUTE, CAST(@startdatetime AS DATETIME)) AS INT) / 5) * 5,
                                    00, 00, 00
                                 ) AS VARCHAR(21)) AS DATETIME2) AS mstartdatetime,
                            IIF(@enddatetime IS NULL
                                AND (CAST(GETDATE() AS DATE) > CAST(@startdatetime AS DATE)),
                                DATETIMEFROMPARTS(YEAR(@startdatetime), MONTH(@startdatetime), DAY(@startdatetime), 23, 55, 00, 00),
                                IIF(@enddatetime IS NULL,
                                    GETDATE(),
                                    CAST(CAST(CAST(@enddatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                         CAST(TIMEFROMPARTS(
                                            DATEPART(HOUR, CAST(@enddatetime AS DATETIME)),
                                            (CAST(DATEPART(MINUTE, CAST(@enddatetime AS DATETIME)) AS INT) / 5) * 5,
                                            00, 00, 00
                                         ) AS VARCHAR(21)) AS DATETIME2)
                                )
                            ) AS menddatetime
SELECT TOP (ROUND(DATEDIFF(SECOND, '2024-09-25 10:35:00.0000000', '2024-09-25 10:11:20.9600000') / 300, 0) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value] 

SELECT TOP (ROUND(DATEDIFF(SECOND, '2024-09-24 13:35:00.0000000', '2024-09-24 12:53:18.0300000') / 300, 0) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value]

select DATEDIFF(SECOND, '2024-09-24 13:35:00.0000000', '2024-09-24 12:53:18.0300000')
select ROUND(ABS(DATEDIFF(SECOND, '2024-09-24 13:35:00.0000000', '2024-09-24 12:53:18.0300000'))/300,0)+1
select round(DATEDIFF(SECOND, '2024-09-24 13:35:00.0000000', '2024-09-24 12:53:18.0300000')/300,0)+1
select abs(DATEDIFF(SECOND, '2024-09-24 13:35:00.0000000', '2024-09-24 12:53:18.0300000'))+1
select ABS(0)

  SELECT TOP (ROUND(DATEDIFF(SECOND, '2024-09-24 13:35:00.0000000', '2024-09-24 12:53:18.0300000') / 300, 0) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value] 

SELECT TOP (ROUND(ABS(DATEDIFF(SECOND, '2024-09-24 13:35:00.0000000', '2024-09-24 12:53:18.0300000')) / 300, 0) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value] 