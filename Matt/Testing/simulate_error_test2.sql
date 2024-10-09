 SELECT [sessionnumber], [startdatetime],mstartdatetime,menddatetime, datediff(ss,mstartdatetime,menddatetime)'datediff'
 FROM (
 SELECT
 [sessionnumber],
 [startdatetime] ,
 CAST(CAST(CAST(startdatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                 CAST(TIMEFROMPARTS(
                                    DATEPART(HOUR, CAST(startdatetime AS DATETIME)),
                                    (CAST(DATEPART(MINUTE, CAST(startdatetime AS DATETIME)) AS INT) / 5) * 5,
                                    00, 00, 00
                                 ) AS VARCHAR(21)) AS DATETIME2) AS mstartdatetime,
								 IIF(enddatetime IS NULL
                                AND (CAST(GETDATE() AS DATE) > CAST(startdatetime AS DATE)),
                                DATETIMEFROMPARTS(YEAR(startdatetime), MONTH(startdatetime), DAY(startdatetime), 23, 55, 00, 00),
                                IIF(enddatetime IS NULL,
                                    GETDATE(),
                                    CAST(CAST(CAST(enddatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                         CAST(TIMEFROMPARTS(
                                            DATEPART(HOUR, CAST(enddatetime AS DATETIME)),
                                            (CAST(DATEPART(MINUTE, CAST(enddatetime AS DATETIME)) AS INT) / 5) * 5,
                                            00, 00, 00
                                         ) AS VARCHAR(21)) AS DATETIME2)
                                )
                            ) AS menddatetime,
 --CAST(GETDATE() AS DATE) 'CastGetdate',
 --CAST(startdatetime AS DATE) 'CastStartdate',
 DATETIMEFROMPARTS(YEAR(startdatetime), MONTH(startdatetime), DAY(startdatetime), 23, 55, 00, 00) 'AssumedEnddate'
 FROM [dbo].[BPASession]
 WHERE [enddatetime] IS NULL
 )TEST
 where datediff(ss,mstartdatetime,menddatetime) < 0



  select [startdatetime], 
 CAST(CAST(CAST(startdatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                 CAST(TIMEFROMPARTS(
                                    DATEPART(HOUR, CAST(startdatetime AS DATETIME)),
                                    (CAST(DATEPART(MINUTE, CAST(startdatetime AS DATETIME)) AS INT) / 5) * 5,
                                    00, 00, 00
                                 ) AS VARCHAR(21)) AS DATETIME2) AS mstartdatetime,
IIF(enddatetime IS NULL
                                AND (CAST(GETDATE() AS DATE) > CAST(startdatetime AS DATE)),
                                DATETIMEFROMPARTS(YEAR(startdatetime), MONTH(startdatetime), DAY(startdatetime), 23, 55, 00, 00),
                                IIF(enddatetime IS NULL,
                                    GETDATE(),
                                    CAST(CAST(CAST(enddatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                         CAST(TIMEFROMPARTS(
                                            DATEPART(HOUR, CAST(enddatetime AS DATETIME)),
                                            (CAST(DATEPART(MINUTE, CAST(enddatetime AS DATETIME)) AS INT) / 5) * 5,
                                            00, 00, 00
                                         ) AS VARCHAR(21)) AS DATETIME2)
                                )
                            ) AS menddatetime1,

 enddatetime
  FROM [dbo].[BPASession]
  where [sessionnumber] in ( 47506,47503)