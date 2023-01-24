/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id INT GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered BOOLEAN NOT NULL,
    weight_kg DECIMAL(4,2) NOT NULL
);

ALTER TABLE animals ADD COLUMN species VARCHAR(255) NULL;

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    age INT NOT NULL
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

BEGIN TRANSACTION;
ALTER TABLE animals DROP COLUMN id;
ALTER TABLE animals ADD COLUMN id SERIAL PRIMARY KEY;
COMMIT;

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INT REFERENCES species(id) ON DELETE CASCADE;

ALTER TABLE animals
ADD COLUMN owner_id INTEGER REFERENCES owners(id) ON DELETE CASCADE;

CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    date_of_graduation DATE NOT NULL
);

-- many-to-many join-table
CREATE TABLE specializations (
   species_id INTEGER REFERENCES species(id),
   vet_id INTEGER REFERENCES vets(id),
   UNIQUE (species_id, vet_id)
);

-- many-to-many join-table
CREATE TABLE visits (
   animal_id INTEGER REFERENCES animals(id),
   vet_id INTEGER REFERENCES vets(id),
   date_of_visits DATE NOT NULL,
   UNIQUE (animal_id, vet_id, date_of_visits)
);

CREATE INDEX animal_id_index ON visits (animal_id);
CREATE INDEX vet_id_index ON visits (vet_id);
CREATE INDEX email_index ON owners (email);
