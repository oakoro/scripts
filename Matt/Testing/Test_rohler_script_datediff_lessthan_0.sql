 select sessionnumber,mstartdatetime,menddatetime,datediff(ss,mstartdatetime,menddatetime) 'datediff'
 from (
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
                                    --GETDATE(),
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
							)oke
				where datediff(ss,mstartdatetime,menddatetime) < 0
				order by menddatetime desc