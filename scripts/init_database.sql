/*
=========================================
Create Database and Schema
=========================================
script porpuse:
  This script creates a new database named 'DataWarehouse' after checking if it already existts.
  if the database exists, it is dropped and recreated. additionaly, the script sets up three schemas
  within the database: 'bronze','silver','gold'

Waring:
  Running the script will drop the entire 'DataWarehouse' database if it exists.
*/


-- Create new database

CREATE DATABASE DataWarehouse;

USE DataWarehouse;
GO
-- Create The Schemas

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
--GO : separate batched when working with multible sql statments (separator)
