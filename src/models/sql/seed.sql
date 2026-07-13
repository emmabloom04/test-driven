
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO categories (name)
VALUES
    ('Sedan'),
    ('SUV'),
    ('Minivan'),
    ('Sports Car'),
    ('Hatchback'),
    ('Truck'),
    ('Convertible')
ON CONFLICT (name) DO NOTHING;

-- Roles table for role-based access control
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed roles (idempotent - safe to run multiple times)
INSERT INTO roles (role_name, role_description) 
VALUES 
    ('user', 'Standard user with basic access'),
    ('employee', 'Employee with access to specific features'),
    ('admin', 'Administrator with full system access')
ON CONFLICT (role_name) DO NOTHING;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INTEGER NOT NULL DEFAULT 1, 
    FOREIGN KEY (role_id) REFERENCES roles(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cars_list (
    id SERIAL PRIMARY KEY,
    vin VARCHAR(17) UNIQUE NOT NULL,
    sold BOOLEAN NOT NULL DEFAULT FALSE,
    make VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    category VARCHAR(255),
    FOREIGN KEY (category) REFERENCES categories(name) ON DELETE SET NULL,
    exterior_color VARCHAR(255) NOT NULL,
    interior_color VARCHAR(255) NOT NULL,
    fuel_type VARCHAR(255) NOT NULL,
    year SMALLINT NOT NULL,
    mileage INTEGER NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    purchased_by INTEGER, 
    FOREIGN KEY (purchased_by) REFERENCES users(id) ON DELETE SET NULL,
    listed_by INTEGER,
    FOREIGN KEY (listed_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS vehicle_images (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    vehicle_id INTEGER NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES cars_list(id) ON DELETE CASCADE,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS contact_form (
    id SERIAL PRIMARY KEY,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    submitted TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS service_request_status (
    id SERIAL PRIMARY KEY,
    request_status VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO service_request_status (request_status)
VALUES
    ('Submitted'),
    ('In Progress'),
    ('Completed'),
    ('Unable to Complete')
ON CONFLICT (request_status) DO NOTHING;

CREATE TABLE IF NOT EXISTS service_requests (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES users(id),
    vehicle_id INTEGER NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES cars_list(id),
    service_description TEXT NOT NULL,
    request_status_id INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (request_status_id) REFERENCES service_request_status(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS service_request_notes (
    id SERIAL PRIMARY KEY,
    service_request_id INTEGER NOT NULL,
    FOREIGN KEY (service_request_id) REFERENCES service_requests(id),
    employee_id INTEGER NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES users(id),
    note TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    car_id INTEGER NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars_list(id),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
