IF USER_ID(N'${user}') IS NULL EXEC(N'CREATE LOGIN [${user}] WITH PASSWORD=''${password}'';') ELSE EXEC (N'ALTER LOGIN [${user}] WITH PASSWORD=''${password}'';');
GO
