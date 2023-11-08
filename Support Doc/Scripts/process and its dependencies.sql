
 
IF OBJECT_ID('tempdb..#BPMarkedAssets') IS NOT NULL
DROP TABLE #BPMarkedAssets;
 
CREATE TABLE #BPMarkedAssets
(
  ParentType NVARCHAR(20),
  ParentName NVARCHAR(128),
  ChildType NVARCHAR(20),
  ChildName NVARCHAR(128)
)
 
/* BP Database Version Check */
 
DECLARE @DatabaseVersion AS INT
SELECT TOP 1 @DatabaseVersion = CONVERT(INT, dbversion) FROM dbo.BPADBVersion ORDER BY CONVERT(INT, dbversion) DESC
 --select @DatabaseVersion
IF @DatabaseVersion >= 275
BEGIN
  INSERT INTO #BPMarkedAssets (ParentType, ParentName, ChildType, ChildName)
  SELECT  ParentType, 
      ParentName, 
      ChildType, 
      ChildName
  FROM
  (
    -- Processes
    SELECT  DISTINCT
        CASE p2.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p2.[name] AS ParentName,
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ChildType,
        p.[name] AS ChildName
    FROM  BPAProcess p2 
        INNER JOIN BPAProcessIDDependency d ON p2.processid = d.processID
        INNER JOIN BPAProcess p ON p.processid = d.refProcessID
    UNION
    -- Objects (VBO)
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Object' AS ChildType,
        d.refProcessName AS ChildName
    FROM  BPAProcess p 
        INNER JOIN BPAProcessActionDependency d ON p.processid = d.processID
    UNION
    -- Internal Objects
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Object - Internal' AS ChildType,
        SUBSTRING(d.refProcessName, 20, LEN(d.refProcessName)) AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessNameDependency d ON p.processid = d.processID
    WHERE  d.refProcessName LIKE 'Blueprism.Automate.%'
    UNION
    -- Environment Variables
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Environment Variable' AS ChildType,
        d.refVariableName AS ChildName
    FROM  BPAProcess p 
        INNER JOIN BPAProcessEnvironmentVarDependency d ON p.processid = d.processID
    -- Credentials
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Credential' AS ChildType,
        d.refCredentialsName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessCredentialsDependency d ON p.processid = d.processID
    -- Queues
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Work Queue' AS ChildType,
        d.refQueueName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessQueueDependency d ON p.processid = d.processID
    -- Fonts
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Font' AS ChildType,
        d.refFontName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessFontDependency d ON p.processid = d.processID
    -- Calendars
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Calendar' AS ChildType,
        d.refCalendarName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessCalendarDependency d ON p.processid = d.processID
    UNION
    -- Web Services (SOAP)
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'SOAP Web Service' AS ChildType,
        d.refServiceName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessWebServiceDependency d ON p.processid = d.processID
    UNION
    -- APIs (RESTful)
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Web API Service' AS ChildType,
        d.refApiName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessWebApiDependency d ON p.processid = d.processID
 
    UNION
    -- Skills (only return SkillId as NVARCHAR(128))
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Skill' AS ChildType,
        CONVERT(NVARCHAR(128), d.refSkillId) AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessSkillDependency d ON p.processid = d.processID
  ) x
END
ELSE
BEGIN
  INSERT INTO #BPMarkedAssets (ParentType, ParentName, ChildType, ChildName)
  SELECT  ParentType, 
      ParentName, 
      ChildType, 
      ChildName
  FROM
  (
    -- Processes
    SELECT  DISTINCT
        CASE p2.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p2.[name] AS ParentName,
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ChildType,
        p.[name] AS ChildName
    FROM  BPAProcess p2 
        INNER JOIN BPAProcessIDDependency d ON p2.processid = d.processID
        INNER JOIN BPAProcess p ON p.processid = d.refProcessID
    UNION
    -- Objects (VBO)
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Object' AS ChildType,
        d.refProcessName AS ChildName
    FROM  BPAProcess p 
        INNER JOIN BPAProcessActionDependency d ON p.processid = d.processID
    UNION
    -- Internal Objects
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Object - Internal' AS ChildType,
        SUBSTRING(d.refProcessName, 20, LEN(d.refProcessName)) AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessNameDependency d ON p.processid = d.processID
    WHERE  d.refProcessName LIKE 'Blueprism.Automate.%'
    UNION
    -- Environment Variables
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Environment Variable' AS ChildType,
        d.refVariableName AS ChildName
    FROM  BPAProcess p 
        INNER JOIN BPAProcessEnvironmentVarDependency d ON p.processid = d.processID
    -- Credentials
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Credential' AS ChildType,
        d.refCredentialsName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessCredentialsDependency d ON p.processid = d.processID
    -- Queues
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Work Queue' AS ChildType,
        d.refQueueName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessQueueDependency d ON p.processid = d.processID
    -- Fonts
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Font' AS ChildType,
        d.refFontName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessFontDependency d ON p.processid = d.processID
    -- Calendars
    UNION
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'Calendar' AS ChildType,
        d.refCalendarName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessCalendarDependency d ON p.processid = d.processID
    UNION
    -- Web Services (SOAP)
    SELECT  DISTINCT
        CASE p.ProcessType WHEN 'P' THEN 'Process' ELSE 'Object' END AS ParentType,
        p.[name] AS ParentName,
        'SOAP Web Service' AS ChildType,
        d.refServiceName AS ChildName
    FROM  BPAProcess p
        INNER JOIN BPAProcessWebServiceDependency d ON p.processid = d.processID
  ) x
END
 
CREATE CLUSTERED INDEX idxMarkedAssets 
ON #BPMarkedAssets (ParentType, ParentName, ChildType, ChildName)
 
;WITH BPAssetsHierarchy
AS
(
  SELECT  ParentType AS AncestorType,
      ParentName AS AncestorName,
      ChildType AS DescendantType,
      ChildName AS DescendantName,
      1 AS Depth,
      CAST(':' + ParentName + ChildName AS NVARCHAR(MAX)) AS CircularRef
  FROM  #BPMarkedAssets
  UNION ALL
  SELECT  b.AncestorType AS AncestorType,
      b.AncestorName AS AncestorName,
      a.ChildType AS DescendantType,
      a.ChildName AS DescendantName,
      b.Depth + 1 AS Depth,
      CAST(b.CircularRef + b.AncestorName + a.ChildName + ':' AS NVARCHAR(MAX)) AS CircularRef
  FROM  #BPMarkedAssets a
      INNER JOIN BPAssetsHierarchy b ON  a.ParentName = b.DescendantName AND 
                        a.ParentType = b.DescendantType AND
                        CHARINDEX(':' + b.AncestorName + a.ChildName + ':', b.CircularRef) = 0
  WHERE  b.Depth < 100
)
SELECT    DISTINCT
      AncestorType,
      AncestorName,
      DescendantType,
      DescendantName,
      Depth
FROM    BPAssetsHierarchy
--WHERE    AncestorName = @AncestorName OR DescendantName = @DescendantName
ORDER BY  Depth, AncestorType DESC, AncestorName, DescendantType DESC, DescendantName
 
DROP TABLE  #BPMarkedAssets