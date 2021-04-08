
CREATE USER aleksey PASSWORD '123';
CREATE USER ivan PASSWORD '123';

GRANT worker TO aleksey, ivan;

GRANT ALL ON prisoner TO worker;
GRANT ALL ON work_prisoner TO worker;
GRANT ALL ON work TO worker;
GRANT ALL ON category TO worker;
GRANT ALL ON prison_sentence TO worker;

CREATE USER anzur PASSWORD '123';
CREATE USER zurab PASSWORD '123';
CREATE USER zorik PASSWORD '123';

GRANT cook TO anzur, zurab, zorik;

REVOKE ALL ON prison FROM cook;
ALTER ROLE cook NOCREATEDB NOCREATEROLE;
--GRANT USAGE ON SCHEMA nutrition TO cook;
GRANT SELECT ON nutrition.food_sets TO cook;
GRANT SELECT ON nutrition.food_intake TO cook;
