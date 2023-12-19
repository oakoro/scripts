DECLARE  
@Dt DATETIME = GETDATE(),
@usr UNIQUEIDENTIFIER = (SELECT [userid] FROM [dbo].[BPAUser] WHERE username='admin'),
@mxDT DATETIME = (SELECT MAX(installedon) FROM [BPALicense]),
@v7license NVARCHAR(200) =  '$license',
@v6license NVARCHAR(200) = 'hardcodedlicense',
@license NVARCHAR(200)

SELECT TOP (1) @license = CASE 
WHEN dbversion IN ('444','481','486','501','523','533') THEN @v7license 
ELSE @v6license
END 
FROM [dbo].[BPADBVersion] order by scriptrundate DESC

SELECT @license



SELECT @license,  @Dt,    @usr
INSERT INTO [BPALicense] ([licensekey], [installedon], [installedby])
values ( '@license', @Dt,  @usr)

SELECT MAX(installedon) AS 'NewLicenseInstalled' FROM [BPALicense]


