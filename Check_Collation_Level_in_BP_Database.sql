SELECT CASE
           WHEN unicodeLogging = 1 THEN
               'Unicode Logging Enabled'
           WHEN unicodeLogging = 0 THEN
               'Non Unicode Logging Enabled'
           ELSE
               'Logging Unkown'
       END AS LoggingType
FROM BPASysConfig