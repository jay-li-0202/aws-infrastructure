# Useful commands

## SSH

### SSH - Port Forward via Bastion (Production)

```bash
ssh -i <your_private_key.pem> \
    -L 9000:es.basisregisters.local:443 \
    -L 9001:db.basisregisters.local:1433 \
    -L 6379:cache.basisregisters.local:6379 \
    root@<bastion_ip>
```

### SSH - Port Forward via Bastion (Staging)

```bash
ssh -i <your_private_key.pem> \
    -L 9000:es.staging-basisregisters.local:443 \
    -L 9001:db.staging-basisregisters.local:1433 \
    -L 6379:cache.staging-basisregisters.local:6379 \
    root@<bastion_ip>
```

## SQL

### SQL - Delete all tables and sequences

```sql
SELECT ' DROP TABLE ' + QUOTENAME(DB_NAME()) + '.' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U'
UNION
SELECT ' DROP SEQUENCE ' + QUOTENAME(DB_NAME()) + '.' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + '; '
FROM   sys.sequences t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
```

### SQL - Select all ProjectionStates

```sql
SELECT 'DECLARE @Events INT' + CHAR(13) + CHAR(10) +
       'SELECT @Events = COUNT(*) - 1 FROM ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + CHAR(13) + CHAR(10) +
       'SELECT ''' + QUOTENAME(s.NAME) + ''' AS Name, @Events AS Position, '''' As Status UNION' + CHAR(13) + CHAR(10)
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U'
  AND  t.name like '%Messages%'
UNION
SELECT 'SELECT  Name, Position, IIF(Position = @Events, ''Ready'', ''Running'') AS Status FROM ' + QUOTENAME(s.NAME) + '.' + QUOTENAME(t.NAME) + ' UNION '
FROM   sys.tables t
       JOIN sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = 'U'
  AND  t.name like '%ProjectionStates%'
```

```sql
sp_MSforeachdb 'IF EXISTS (SELECT "?" AS DB, * FROM [?].sys.tables WHERE name like ''%ProjectionStates%'')
SELECT ''SELECT * FROM [?].'' + QUOTENAME(s.NAME) + ''.'' + QUOTENAME(t.NAME) + ''; ''
FROM   [?].sys.tables t
       JOIN [?].sys.schemas s
         ON t.[schema_id] = s.[schema_id]
WHERE  t.type = ''U''
  AND  t.name like ''%ProjectionStates%'''
```

## Redis

### Redis - Connect to cluster

* Be sure to have `redis-tools` installed (`apt-get install redis-tools`)
* From a bastion, use `redis-cli -h cache.staging-basisregisters.local`
* From a development station, use `redis-cli -h 127.0.0.1 -p 6379`

### Redis - List all nodes and store in variable

```bash
NODES=`redis-cli -h cache.staging-basisregisters.local cluster nodes | cut -f2 -d' '`
echo $NODES
```

### Redis - Clear entire cluster

```bash
for node in $NODES; do echo Flushing node $node...; redis-cli -h ${node%:*} -p ${node##*:} flushall; done
```

### Redis - Clear keys based on wildcard

This can only be done on a bastion, since it has to connect to all nodes seperately using their AWS internal ip.

Make sure the following scripts are present on the bastion:

> maintenance\redis\clear-redis-key.sh
> maintenance\redis\scan-match.sh

To test, you can use `./scan-match.sh legacy/municipality` which should return all municipality keys.

When you are certain, you can execute `./clear-redis-key.sh legacy/municipality` to clear these keys.

## Terraform

### Delete all terraform folders

```bash
find -type d -name ".terraform" -exec rm -rf {} \;
```

## Paket

### List all outdated packages

```bash
rm -rf /tmp/repos-outdated.txt; forrepos "git pull; sleep 5; echo 'Pulled '(pwd); echo (pwd) >> /tmp/repos-outdated.txt; mono .paket/paket.exe outdated --ignore-constraints | awk '/Outdated packages found:/,/Performance:/' >> /tmp/repos-outdated.txt; sleep 5; echo >> /tmp/repos-outdated.txt; echo 'Outdated '(pwd);"; echo 'Outdated check done!!'
```
