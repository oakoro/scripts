SELECT        BPAProcess.name, COUNT(BPASessionLog_NonUnicode.sessionnumber) AS 'LogRows'

FROM            BPASession INNER JOIN

                         BPASessionLog_NonUnicode ON BPASession.sessionnumber = BPASessionLog_NonUnicode.sessionnumber INNER JOIN

                         BPAProcess ON BPASession.processid = BPAProcess.processid

WHERE        (DATEADD(SECOND, - ISNULL(BPASession.endtimezoneoffset, 0), BPASession.enddatetime) >= CAST(GETUTCDATE() - 4 AS DATE))

GROUP BY BPAProcess.name

ORDER BY LogRows desc