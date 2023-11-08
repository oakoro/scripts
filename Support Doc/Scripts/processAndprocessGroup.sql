SELECT P.name,P.description,P.version,P.createdate,P.lastmodifieddate, G.name AS [Folder Name]
FROM BPAProcess P INNER JOIN BPAGroupProcess GP ON P.processid = GP.processid INNER JOIN BPAGroup G ON GP.groupid = G.id
WHERE ProcessType = 'O'