IF DB_ID(N'${database}') IS NULL EXEC(N'CREATE DATABASE [${database}];');
GO

IF SERVERPROPERTY('EngineEdition') <> 5 EXEC(N'ALTER DATABASE [${database}] SET READ_COMMITTED_SNAPSHOT ON;');
GO

USE [${database}]
GO
IF SCHEMA_ID(N'${registry}') IS NULL EXEC(N'CREATE SCHEMA [${registry}];');
GO
IF SCHEMA_ID(N'${registry}Import') IS NULL EXEC(N'CREATE SCHEMA [${registry}Import];');
GO
IF SCHEMA_ID(N'${registry}Legacy') IS NULL EXEC(N'CREATE SCHEMA [${registry}Legacy];');
GO
IF SCHEMA_ID(N'${registry}Extract') IS NULL EXEC(N'CREATE SCHEMA [${registry}Extract];');
GO
IF SCHEMA_ID(N'Redis') IS NULL EXEC(N'CREATE SCHEMA [Redis];');
GO

USE [master]
GO
IF SUSER_ID(N'${user}') IS NULL EXEC(N'CREATE LOGIN [${user}] WITH PASSWORD=''${password}'';');
GO

USE [${database}]
GO
IF USER_ID(N'${user}') IS NULL EXEC(N'CREATE USER [${user}] FOR LOGIN [${user}];');
GO

USE [${database}]
GO
sp_addrolemember 'db_owner', '${user}';
GO
