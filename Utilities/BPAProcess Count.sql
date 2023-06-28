SELECT        BPAProcess.name, COUNT(BPASessionLog_NonUnicode.sessionnumber) AS 'LogRows'

FROM            BPASession with (nolock) INNER JOIN

                         BPASessionLog_NonUnicode with (nolock) ON BPASession.sessionnumber = BPASessionLog_NonUnicode.sessionnumber INNER JOIN

                         BPAProcess with (nolock) ON BPASession.processid = BPAProcess.processid

WHERE        (DATEADD(SECOND, - ISNULL(BPASession.endtimezoneoffset, 0), BPASession.enddatetime) >= CAST(GETUTCDATE() - 20 AS DATE))

GROUP BY BPAProcess.name

ORDER BY LogRows desc