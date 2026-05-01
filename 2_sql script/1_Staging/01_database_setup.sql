-- Creating Database

DROP DATABASE IF EXISTS global_electronics_dw;

CREATE DATABASE global_electronics_dw
    WITH OWNER = postgres
    ENCODING = 'UTF8'
    TEMPLATE = template0;