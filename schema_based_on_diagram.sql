CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL
);

CREATE TABLE treatments (
    id SERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE medical_histories (
    id SERIAL PRIMARY KEY,
    admitted_at TIMESTAMP NOT NULL,
    patient_id INT NOT NULL REFERENCES patients(id),
    status VARCHAR(255) NOT NULL
);

CREATE INDEX medical_histories_patient_id_idx ON medical_histories (patient_id);

CREATE TABLE invoices (
    id SERIAL PRIMARY KEY,
    total_amount DECIMAL(4,2) NOT NULL,
    generated_at TIMESTAMP NOT NULL,
    payed_at TIMESTAMP NOT NULL,
    medical_history_id INT NOT NULL REFERENCES medical_histories(id)
);
CREATE INDEX invoices_medical_history_id_idx ON invoices (medical_history_id);

CREATE TABLE invoice_items (
    id SERIAL PRIMARY KEY,
    unit_price DECIMAL(4,2) NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(4,2) NOT NULL,
    invoice_id INT NOT NULL REFERENCES invoices(id),
    treatment_id INT NOT NULL REFERENCES treatments(id)
);
CREATE INDEX invoice_items_invoice_id_idx ON invoice_items (invoice_id);
CREATE INDEX invoice_items_treatment_id_idx ON invoice_items (treatment_id);

CREATE TABLE medical_history_treatment (
    id SERIAL PRIMARY KEY,
    medical_history_id INT NOT NULL REFERENCES medical_histories(id),
    treatment_id INT NOT NULL REFERENCES treatments(id)
);
CREATE INDEX medical_history_treatment_medical_history_id_idx ON medical_history_treatment (medical_history_id);
CREATE INDEX medical_history_treatment_treatment_id_idx ON medical_history_treatment (treatment_id);