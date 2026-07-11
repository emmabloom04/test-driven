
CREATE TABLE IF NOT EXISTS cars_list (
    id SERIAL PRIMARY KEY,
    sold BOOLEAN NOT NULL,
    make VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    color VARCHAR(255) NOT NULL,
    year SMALLINT NOT NULL,
    mileage FLOAT NOT NULL,
    price FLOAT NOT NULL,
    purchased_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    listed_by INTEGER REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS contact_form (
    id SERIAL PRIMARY KEY,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    submitted TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INTEGER NOT NULL DEFAULT 1 REFERENCES roles(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Roles table for role-based access control
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS service_request_status (
    id SERIAL PRIMARY KEY,
    request_status VARCHAR(50) UNIQUE NOT NULL
);

-- Seed roles (idempotent - safe to run multiple times)
INSERT INTO roles (role_name, role_description) 
VALUES 
    ('user', 'Standard user with basic access'),
    ('employee', 'Employee with access to specific features'),
    ('admin', 'Administrator with full system access')
ON CONFLICT (role_name) DO NOTHING;

INSERT INTO service_request_status (request_status)
VALUES
    ('Submitted'),
    ('In Progress'),
    ('Completed'),
    ('Unable to Complete')
ON CONFLICT (request_status) DO NOTHING;