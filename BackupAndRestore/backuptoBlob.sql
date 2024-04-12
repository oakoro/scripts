use master;
create credential [https://bpcarchive.blob.core.windows.net/rpa-autoarchive]
with identity = 'Shared Access Signature',
secret = 'sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2024-04-08T20:05:32Z&st=2024-04-08T12:05:32Z&spr=https&sig=r%2Fq2vYRjc2IsFsfv5EzKCK0t4cvEDBKr%2BcK%2FuZ8VHMI%3D'

--https://bpcarchive.blob.core.windows.net/rpa-autoarchive
--sv=2022-11-02&ss=bfqt&srt=sco&sp=rwdlacupyx&se=2024-04-08T20:05:32Z&st=2024-04-08T12:05:32Z&spr=https&sig=r%2Fq2vYRjc2IsFsfv5EzKCK0t4cvEDBKr%2BcK%2FuZ8VHMI%3D

backup database [AdventureWorks20191] to 
url = 'https://bpcarchive.blob.core.windows.net/rpa-autoarchive/AdventureWorks20191.bak'