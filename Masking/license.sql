select substring(licensekey,1,5),len(licensekey),installedon,installedby from [dbo].[BPALicense]
select licensekey, 
stuff(licensekey,7,len(licensekey),replicate('x',5))'licensekey',
installedon,
stuff(installedby,5,len(installedby),replicate('x',5)) 'installedby'
from [dbo].[BPALicense]
select  
replicate('x',5)+substring(licensekey,5,10)+replicate('x',5)'licensekey',
installedon,
stuff(installedby,5,len(installedby),replicate('x',5)) 'installedby'
from [dbo].[BPALicense]
select replicate('x',5)+substring(licensekey,5,10)+replicate('x',5),len(licensekey),installedon,installedby from [dbo].[BPALicense]
--STUFF ( character_expression , start , length , replace_with_expression )