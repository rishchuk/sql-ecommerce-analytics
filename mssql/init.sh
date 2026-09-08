#!/bin/bash

set -e

echo "Waiting for database..."

until /opt/mssql-tools/bin/sqlcmd \
    -S db \
    -U sa \
    -P "$DB_PASSWORD" \
    -C \
    -Q "SELECT 1"
do
    echo "SQL Server is not ready..."
    sleep 2
done

echo "SQL Server is ready."

echo "Creating database..."

until /opt/mssql-tools/bin/sqlcmd \
    -S db \
    -U sa \
    -P "$DB_PASSWORD" \
    -C \
    -Q "IF DB_ID('ecommerce') IS NULL CREATE DATABASE ecommerce"
do
    echo "Waiting for ecommerce database..."
    sleep 2
done

echo "Database is ready."

echo "Executing schema.sql..."

until /opt/mssql-tools/bin/sqlcmd \
    -S db \
    -U sa \
    -P "$DB_PASSWORD" \
    -C \
    -d ecommerce \
    -i /schema.sql
do
    echo "Schema execution failed, retrying..."
    sleep 2
done

echo "Checking tables..."

until /opt/mssql-tools/bin/sqlcmd \
    -S db \
    -U sa \
    -P "$DB_PASSWORD" \
    -C \
    -d ecommerce \
    -Q "IF OBJECT_ID('dbo.Categories') IS NULL THROW 50000, 'Categories table does not exist', 1"
do
    echo "Tables are not ready..."
    sleep 2
done

echo "Database initialization completed."

sleep 2
