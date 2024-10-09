SELECT TOP (1) 
    [DateTime],
    COUNT(*) AS [ConcurrentSessionsCount] 
FROM 
    (
        SELECT 
            value AS 'DateTime'
        FROM
            (
                SELECT 
                    ProcessName,
                    mstartdatetime,
                    menddatetime,
                    sessionnumber,
                    STUFF(
                        (
                            SELECT ',' + CAST(GDS.Duration AS VARCHAR(21))
                            FROM
                                (
                                    SELECT *
                                    FROM
                                        (
                                            SELECT 
                                                DATEADD(SECOND, GS.[value], InitialTable.mstartdatetime) AS Duration
                                            FROM 
                                                (
                                                    SELECT TOP (ROUND(DATEDIFF(SECOND, mstartdatetime, menddatetime) / 300, 0) + 1) 
                                                        (ROW_NUMBER() OVER (ORDER BY (SELECT 1)) - 1) * 300 AS [value]  
                                                    FROM 
                                                        (SELECT 1 AS value1 FROM BPASession S1 
                                                         RIGHT JOIN INFORMATION_SCHEMA.COLUMNS ON S1.sessionnumber = -1000
                                                        ) AS ST
                                                ) AS GS
                                        ) AS DateSeries
                                    WHERE Duration <= InitialTable.menddatetime
                                ) AS GDS
                            WHERE GDS.Duration = Duration
                            ORDER BY GDS.Duration
                            FOR XML PATH('')
                        ), 1, 1, ''
                    ) AS TotalDuration
                FROM
                    (
                        SELECT DISTINCT
                            R.[name] AS ResourceName,
                            P.[name] AS ProcessName,
                            CAST(CAST(CAST(S.startdatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                 CAST(TIMEFROMPARTS(
                                    DATEPART(HOUR, CAST(S.startdatetime AS DATETIME)),
                                    (CAST(DATEPART(MINUTE, CAST(S.startdatetime AS DATETIME)) AS INT) / 5) * 5,
                                    00, 00, 00
                                 ) AS VARCHAR(21)) AS DATETIME2) AS mstartdatetime,
                            IIF(S.enddatetime IS NULL
                                AND (CAST(GETDATE() AS DATE) > CAST(S.startdatetime AS DATE)),
                                DATETIMEFROMPARTS(YEAR(S.startdatetime), MONTH(S.startdatetime), DAY(S.startdatetime), 23, 55, 00, 00),
                                IIF(S.enddatetime IS NULL,
                                    DATETIMEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE()), 23, 59, 00, 00),
                                    CAST(CAST(CAST(S.enddatetime AS DATE) AS VARCHAR(21)) + ' ' +
                                         CAST(TIMEFROMPARTS(
                                            DATEPART(HOUR, CAST(S.enddatetime AS DATETIME)),
                                            (CAST(DATEPART(MINUTE, CAST(S.enddatetime AS DATETIME)) AS INT) / 5) * 5,
                                            00, 00, 00
                                         ) AS VARCHAR(21)) AS DATETIME2)
                                )
                            ) AS menddatetime,
                            S.sessionnumber
                        FROM 
                            BPAScheduleLogEntry AS SLE WITH (NOLOCK)
                        INNER JOIN 
                            BPAScheduleLog AS SL WITH (NOLOCK) ON SLE.schedulelogid = SL.id
                        RIGHT JOIN 
                            BPASession AS S WITH (NOLOCK) ON SLE.logsessionnumber = S.sessionnumber
                        LEFT JOIN 
                            BPASchedule AS SC WITH (NOLOCK) ON SL.scheduleid = SC.id
                        LEFT JOIN 
                            BPAResource AS R WITH (NOLOCK) ON S.runningresourceid = R.resourceid
                        LEFT JOIN 
                            BPAProcess AS P WITH (NOLOCK) ON S.processid = P.processid
                        WHERE 
                            S.startdatetime > CONVERT(DATE, GETDATE() - 1 * 30)
                            AND NOT (R.[name] LIKE '%_debug')
                    ) AS InitialTable
            ) AS FinalTable
        CROSS APPLY 
            STRING_SPLIT(TotalDuration, ',') AS SplittedDuration
    ) AS GT 
GROUP BY 
    [DateTime]
ORDER BY 
    [ConcurrentSessionsCount] DESC;