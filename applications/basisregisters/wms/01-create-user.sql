IF NOT EXISTS(SELECT 1 FROM sys.sql_logins WHERE name = '${user}')
BEGIN
  EXEC(N'CREATE LOGIN [${user}] WITH PASSWORD=''${password}'';')
END
ELSE
BEGIN
  EXEC (N'ALTER LOGIN [${user}] WITH PASSWORD=''${password}'';');
END
GO
