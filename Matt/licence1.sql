DECLARE  
@Dt DATETIME = GETDATE(),
@usr UNIQUEIDENTIFIER = (SELECT [userid] FROM [dbo].[BPAUser] WHERE username='admin'),
@mxDT DATETIME = (SELECT MAX(installedon) FROM [BPALicense]),
@dbversion INT,
@result CHAR(10),
@v7license NVARCHAR(400),-- = $($license),
@v6license NVARCHAR(400) = 'hardcodedlicense',
@license NVARCHAR(400)

SELECT TOP (1) @result = CASE 
WHEN dbversion IN ('444','481','486','501','523','533') THEN  'v7license' 
ELSE 'v6license'
END 
FROM [dbo].[BPADBVersion] order by scriptrundate DESC

SELECT @result

IF @result = 'v6license' SET @license = 'hardcodedlicense' ELSE SET @license = @license

SELECT @license,  @Dt,    @usr

