:: CMD

docker run --rm ^
  --name "sqlserverdio" ^
  -e "ACCEPT_EULA=Y" ^
  -e "MSSQL_SA_PASSWORD=yourStrong(\!)Password" ^
  -p 1433:1433 ^
  -d mcr.microsoft.com/mssql/server:2022-latest