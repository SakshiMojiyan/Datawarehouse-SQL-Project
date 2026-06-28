/*
=============================================================
Create Database and Schemas (MySQL Version)
=============================================================
Script Purpose:
    This script creates a new data warehouse environment. 
    In MySQL, schemas and databases are identical. Therefore, this script 
    drops and recreates three distinct databases to act as your layers: 
    'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the 'bronze', 'silver', and 'gold' 
    databases if they exist. All data will be permanently deleted. 
    Proceed with caution.
*/

drop database if exists bronze;
drop database if exists silver;
drop database if exists gold;

create schema bronze;
create schema silver;
create schema gold;

use bronze;
