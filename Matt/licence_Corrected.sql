DECLARE  
@Dt DATETIME = GETDATE(),
@usr UNIQUEIDENTIFIER = (SELECT [userid] FROM [dbo].[BPAUser] WHERE username='admin'),
@mxDT DATETIME = (SELECT MAX(installedon) FROM [dbo].[BPALicense]),
@v7license NVARCHAR(MAX) =  '$license',
@v6license NVARCHAR(MAX) = 'hardcodedlicense',
@license NVARCHAR(MAX)

SELECT TOP (1) @license = CASE 
WHEN dbversion IN ('444','481','486','501','523','533') THEN @v7license 
ELSE @v6license
END 
FROM [dbo].[BPADBVersion] ORDER BY scriptrundate DESC

SELECT @license

INSERT INTO [BPALicense] ([licensekey], [installedon], [installedby])
VALUES (
    @license,
    @Dt,
    @usr)

SELECT MAX(installedon) AS 'NewLicenseInstalled' FROM [BPALicense]

