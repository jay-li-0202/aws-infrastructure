USE [master]
GO
IF SUSER_ID(N'${user}') IS NULL EXEC(N'CREATE LOGIN [${user}] WITH PASSWORD=''${password}'';') ELSE EXEC (N'ALTER LOGIN [${user}] WITH PASSWORD=''${password}'';');
GO

USE [${database}]
GO
IF USER_ID(N'${user}') IS NULL EXEC(N'CREATE USER [${user}] FOR LOGIN [${user}];');
GO

USE [${database}]
GO
sp_addrolemember 'db_owner', '${user}';
GO
