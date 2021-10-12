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
docker build -t "tripinsights/poi:1.0" .
docker run --network drivingnetwork -d -p 8080:80 --name poi -e SQL_USER="SA" -e "SQL_PASSWORD=Passw0rd1234" -e "SQL_SERVER=sql1" -e "ASPNETCORE_ENVIRONMENT=Local" tripinsights/poi:1.0

NB: Needs to be Production 

## Test (Curl or Powershell (Invoke-RestMethod))

Invoke-RestMethod  http://localhost:8080/api/poi/healthcheck
Invoke-RestMethod  http://localhost:8080/api/poi

# Tag Images for uploading to ACR
docker tag tripinsights/tripviewer:1.0 registryszc7583.azurecr.io/tripviewer:1.0
docker tag tripinsights/userprofile:1.0 registryszc7583.azurecr.io/userprofile:1.0
docker tag tripinsights/user-java:1.0 registryszc7583.azurecr.io/user-java:1.0
docker tag tripinsights/trips:1.0 registryszc7583.azurecr.io/trips:1.0
docker tag tripinsights/poi:1.0 registryszc7583.azurecr.io/poi:1.0
