/* Queary database */

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name = 'Agumon' OR 
name = 'Pikachu';
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.50;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.40 AND 17.30;

BEGIN TRANSACTION;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN TRANSACTION;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE name NOT LIKE '%mon';
COMMIT;
SELECT * FROM animals;

BEGIN TRANSACTION;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN TRANSACTION;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT savepoint_1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO savepoint_1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;
SELECT * FROM animals;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;
SELECT SUM(escape_attempts) FROM animals WHERE neutered = true;
SELECT neutered, COUNT(*) FROM animals WHERE escape_attempts > 1 GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
SELECT species, AVG(escape_attempts) as avg_escape FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

SELECT A.name as animals_name, O.full_name as owner_name
FROM animals A
JOIN owners O ON A.owner_id = O.id
WHERE O.full_name = 'Melody Pond';

SELECT A.name as animals_name, S.name as animals_species
FROM animals A
JOIN species S ON A.species_id = S.id
WHERE S.name = 'Pokemon';

SELECT full_name as owner_name, name as animals_name
FROM owners O
FULL OUTER JOIN animals A
ON O.id = A.owner_id;

SELECT S.name as animals_species, COUNT(A.name) as number_animals_per_species
FROM animals A
JOIN species S ON A.species_id = S.id
GROUP BY S.name;

SELECT A.name as animals_name, O.full_name as owner_name,
S.name as animals_species
FROM animals A
JOIN owners O ON A.owner_id = O.id
JOIN species S ON A.species_id = S.id
WHERE O.full_name = 'Jennifer Orwell'
AND S.name = 'Digimon';

SELECT A.name as animals_name, O.full_name as owner_name, A.escape_attempts
FROM animals A
JOIN owners O ON A.owner_id = O.id
WHERE O.full_name = 'Dean Winchester'
AND A.escape_attempts = 0;

SELECT O.full_name as owner_name, COUNT(A.name) as number_animals
FROM animals A
JOIN owners O ON A.species_id = O.id
GROUP BY O.full_name
ORDER BY COUNT(A.name) DESC
LIMIT 1;

SELECT A.name as animals_name, V.date_of_visits, VE.name as vet_name
FROM animals A
JOIN visits V ON A.id = V.animal_id
JOIN vets VE ON VE.id = V.vet_id 
WHERE VE.name = 'William Tatcher'
ORDER BY date_of_birth ASC
LIMIT 1;

SELECT COUNT(A.name) as animals, VE.name as vet_name
FROM animals A
JOIN visits V ON A.id = V.animal_id
JOIN vets VE ON VE.id = V.vet_id
WHERE VE.name = 'Stephanie Mendez'
GROUP BY VE.name;

SELECT VE.name as vet_name, S.name as speciality
FROM vets VE
FULL OUTER JOIN specializations SP ON SP.vet_id = VE.id
FULL OUTER JOIN species S ON S.id = SP.species_id;

SELECT A.name as animals_name, V.date_of_visits, VE.name as vet_name
FROM animals A
JOIN visits V ON A.id = V.animal_id
JOIN vets VE ON VE.id = V.vet_id 
WHERE VE.name = 'Stephanie Mendez'
AND V.date_of_visits 
BETWEEN '2020-04-01' AND '2020-08-30';

SELECT A.name as animals_name, COUNT(V.date_of_visits) as number_of_visits
FROM animals A
JOIN visits V ON A.id = V.animal_id
JOIN vets VE ON VE.id = V.vet_id
GROUP BY A.name
ORDER BY COUNT(V.date_of_visits) DESC
LIMIT 1;

SELECT A.name as animals_name, V.date_of_visits as last_visit_date, VE.name as vet_name
FROM animals A
JOIN visits V ON A.id = V.animal_id
JOIN vets VE ON VE.id = V.vet_id 
WHERE VE.name = 'Maisy Smith'
ORDER BY V.date_of_visits ASC
LIMIT 1;

SELECT A.name as animals_info, VE.name as vet_info, V.date_of_visits
FROM animals A
JOIN visits V ON A.id = V.animal_id
JOIN vets VE ON VE.id = V.vet_id
WHERE a.name = (
SELECT A.name FROM animals A JOIN visits V ON A.id = V.animal_id
JOIN vets VE ON VE.id = V.vet_id GROUP BY A.name
ORDER BY COUNT(V.date_of_visits) DESC LIMIT 1
);

-- create a Common Table Expression (CTE)
WITH visits_not_specialized AS (
    SELECT V.*, A.*, SP.*
    FROM visits V
    JOIN animals A ON V.animal_id = A.id
    LEFT JOIN specializations SP ON A.species_id = SP.species_id AND V.vet_id = SP.vet_id
    WHERE SP.species_id IS NULL
)
SELECT COUNT(*) as visits_not_specialized
FROM visits_not_specialized;

WITH animals_by_species_count AS (
    SELECT S.name, A.species_id, COUNT(*) as number_of_animals
    FROM visits V
    JOIN animals A ON V.animal_id = A.id
    JOIN vets VE ON V.vet_id = VE.id
    JOIN species S ON S.id = A.species_id
    WHERE VE.name = 'Maisy Smith'
    GROUP BY A.species_id, S.name
    ORDER BY number_of_animals DESC
)  
SELECT *
FROM animals_by_species_count
LIMIT 1;

EXPLAIN ANALYSE SELECT COUNT(*) FROM visits where animal_id = 4;
EXPLAIN ANALYSE SELECT * FROM visits where vet_id = 2;
EXPLAIN ANALYSE SELECT * FROM owners where email = 'owner_18327@mail.com';
