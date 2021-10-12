# How to run locally

## Create docker network

docker network create drivingnetwork

## Spin up SQL Locally

docker run --network drivingnetwork -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=Passw0rd1234' -p 1433:1433 --name sql1 -d mcr.microsoft.com/mssql/server:2017-latest 

./sqlcmd -S localhost -U SA -P 'xxx' -Q "CREATE DATABASE mydrivingDB"
./sqlcmd -S localhost -U SA -P 'xxx' -Q "SELECT name from sys.databases";

## Populate database
docker run --network drivingnetwork -e SQLFQDN=sql1 -e SQLUSER=SA -e SQLPASS=Passw0rd1234 -e SQLDB=mydrivingDB openhack/data-load:v1

## Build POI and run poi
cd poi
docker build .
docker run -p --network drivingnetwork

docker run -d --network ah-oh-20 -p 8080:80 --name poi -e "SQL_PASSWORD=localtestpw123@" -e "SQL_SERVER=sqltestdb" -e "SQL_USER=sa" -e "ASPNETCORE_ENVIRONMENT=Local" tripinsights/poi:1.0