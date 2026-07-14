BEGIN;

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

INSERT INTO cars_list (vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price)
VALUES
    ('4T1BF1FK5KU123456', 'Toyota', 'Camry', 'Sedan', 'Silver', 'Black', 'Gasoline', 2019, 423000, 18900),
    ('2HGFC2F59LH234567', 'Honda', 'Civic', 'Sedan', 'Blue', 'Gray', 'Gasoline', 2020, 31750, 19500),
    ('1FTFW1E51JKD34578', 'Ford', 'F-150', 'Truck', 'Black', 'Tan', 'Gasoline', 2018, 58200, 27800),
    ('1G1ZD5ST8HF145689', 'Chevrolet', 'Malibu', 'Sedan', 'White', 'Black', 'Gasoline', 2017, 67100, 12400),
    ('4S4BSANC5M3256790', 'Subaru', 'Outback', 'Hatchback', 'Green', 'Gray', 'Gasoline', 2021, 22900, 26300),
    ('1N4BL4BV6KC367801', 'Nissan', 'Altima', 'Sedan', 'Gray', 'Black', 'Gasoline', 2019, 45600, 15700),
    ('1C4RJFAG3JC478912', 'Jeep', 'Grand Cherokee', 'SUV', 'Red', 'Black', 'Gasoline', 2018, 61300, 21900),
    ('WBA8E1C51HK589023', 'BMW', '3 Series', 'Sedan', 'Black', 'Tan', 'Gasoline', 2017, 52000, 19200),
    ('JM3KFBCM8L0690134', 'Mazda', 'CX-5', 'SUV', ' White', 'Black', 'Gasoline', 2020, 28400, 22600),
    ('5NPD84LF2MH701245', 'Hyundai', 'Elantra', 'Sedan', 'Silver', 'Gray', 'Gasoline', 2021, 19800, 16300),
    ('KNDPMCAC5K7812356', 'Kia', 'Sportage', 'SUV', 'Blue', 'Black', 'Gasoline', 2019, 39500, 17900),
    ('3VWC57BU9JM923467', 'Volkswagen', 'Jetta', 'Sedan', 'Gray', 'Black', 'Gasoline', 2018, 49200, 13800),
    ('2T3RWRFV4LW034578', 'Toyota', 'RAV4', 'SUV', 'Red', 'Black', 'Hybrid', 2020, 33600, 24500),
    ('2GNAXKEV3K6145689', 'Chevrolet', 'Equinox', 'SUV', 'White', 'Gray', 'Gasoline', 2019, 44000, 17200),
    ('5J6RW2H85ML256790', 'Honda', 'CR-V', 'SUV', 'Black', 'Black', 'Gasoline', 2021, 25300, 25900),
    ('1FMCU9GD3JUB67801', 'Ford', 'Escape', 'SUV', 'Blue', 'Gray', 'Gasoline', 2018, 56700, 14600),
    ('WAUENAF47HN478912', 'Audi', 'A4', 'Sedan', 'Silver', 'Black', 'Gasoline', 2017, 63900, 18400),
    ('JF2SKAJC1LH589023', 'Subaru', 'Forester', 'SUV', 'Green', 'Tan', 'Gasoline', 2020, 30100, 23700),
    ('2C3CDXHG3KH690134', 'Dodge', 'Charger', 'Sports Car', 'Black', 'Black', 'Gasoline', 2019, 41800, 20300),
    ('3MZBPBCM8MM701245', 'Mazda', 'Mazda3', 'Hatchback', 'White', 'Gray', 'Gasoline', 2021, 21200, 17500)
ON CONFLICT (vin) DO NOTHING;

CREATE TABLE IF NOT EXISTS vehicle_images (
    id SERIAL PRIMARY KEY,
    image_url VARCHAR(255) NOT NULL,
    vehicle_id INTEGER NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES cars_list(id) ON DELETE CASCADE,
    alt_text VARCHAR(255),
    is_primary BOOLEAN DEFAULT FALSE
);

INSERT INTO vehicle_images (image_url, vehicle_id, alt_text, is_primary)
VALUES
    -- silver toyota camry
    ('http://images.gtcarlot.com/pictures/130357801.jpg', 1, 'front view of silver toyota camry', TRUE),
    ('http://images.gtcarlot.com/pictures/138679820.jpg', 1, 'side view of silver toyota camry', FALSE),
    ('http://images.gtcarlot.com/pictures/130357764.jpg', 1, 'back view of silver toyota camry', FALSE),

    -- blue honda civic
    ('https://www.usnews.com/object/image/0000018b-ac16-d133-a3ff-bddee3010000/https-cars-dms-usnews-com-static-uploads-images-auto-custom-14219-original-2020-honda-civic-18.jpg?update-time=1568743572000&size=responsiveGallery', 2, 'front view of blue honda civic', TRUE),
    ('https://s3.amazonaws.com/di-honda-enrollment/2020-civic-si-coupe/model-image-2020-civic-si-coupe-front.png', 2, 'side view of blue honda civic', FALSE),
    ('https://newengland.hondadealers.com/-/media/Honda-Automobiles/Vehicles/2019/Civic-Sedan/00-NEW-VLP/Exterior/1-Styling/MY19-CIVIC-SEDAN-transfer-EXTERIOR-Styling-06-Sport-1400-2x.jpg', 2, 'back view of blue honda civic', FALSE),

    -- black ford f-150
    ('https://cdn.dealeraccelerate.com/adrenalin/1/2606/68940/1920x1440/2018-ford-f-150-raptor', 3, 'front view of black ford f-150', TRUE),
    ('https://boostcarimages.blob.core.windows.net/carimages/176/5296084/2018%20Ford%20F-150%20637449063567732427_3.jpg', 3, 'side view of black ford f-150', FALSE),
    ('https://i.pinimg.com/originals/f6/25/43/f62543e6a4cd5da35ef99acb70c52433.jpg', 3, 'back view of black ford f-150', FALSE),

    -- white chevrolet malibu
    ('https://di-uploads-pod10.dealerinspire.com/chevycenter/uploads/2020/07/2017-Chevrolet-Malibu-PREMIER-Summit-White.jpg', 4, 'front view of white chevrolet malibu', TRUE),
    ('http://images.gtcarlot.com/pictures/115902550.jpg', 4, 'side view of white chevrolet malibu', FALSE),
    ('https://platform.cstatic-images.com/in/v2/stock_photos/dab8048a-8834-4cdc-ac48-32a095e9c741/41b125db-22ad-429c-9662-fd60ee642965.png', 4, 'back view of white chevrolet malibu', FALSE),

    -- green subaru outback
    ('https://s1.cdn.autoevolution.com/images/news/forget-about-wilderness-even-the-base-2021-subaru-outback-is-costlier-in-uk-160774_1.jpg', 5, 'front view of green subaru outback', TRUE),
    ('https://i2.wp.com/subarucarusa.com/wp-content/uploads/2019/09/2021-Subaru-Outback-Touring-Price-Colors.jpg?ssl=1', 5, 'side view of green subaru outback', FALSE),
    ('https://cdn.jdpower.com/JDPA_2022%20Subaru%20Outback%20Wilderness%20Green%20Rear%20Quarter%20View.jpg', 5, 'back view of green subaru outback', FALSE),

    -- gray nissan altima
    ('https://www.dubicars.com/images/c52cf0/fw_1300x760/syria-motors/e6cbd1aa-8afc-45f2-b7eb-8c90ae8e4836.jpg', 6, 'front view of a gray nissan altima', TRUE),
    ('http://images.gtcarlot.com/pictures/145884778.jpg', 6, 'side view of a gray nissan altima', FALSE),
    ('https://bidhistory.org/uploads/8Vui164gdHA4jpK7uXaniMRKWg/1n4bl4bv3kc166469-nissan-altima-2019-2.jpg', 6, 'back view of a gray nissan altima', FALSE),

    -- red jeep grand cherokee
    ('https://www.primemotorz.com/imagetag/857/main/l/Used-2019-Jeep-Grand-Cherokee-LIMITED-X-4X4-Limited-X-1628629322.jpg', 7, 'front view of a red jeep grand cherokee', TRUE),
    ('https://st3.stat.vin/files/1C4RJFLG5JC212215/IAAI/37543608/photo/photo_11.jpg', 7, 'side view of a red jeep grand cherokee', FALSE),
    ('https://s1.cdn.autoevolution.com/images/news/gallery/2015-jeep-grand-cherokee-srt-red-vapor-special-edition-now-available-to-order-in-the-uk-photo-gallery_7.jpg', 7, 'back view of a red jeep grand cherokee', FALSE),

    -- black bmw 3 series
    ('image_url', 8, 'alt_text', TRUE),
    ('image_url', 8, 'alt_text', FALSE),
    ('image_url', 8, 'alt_text', FALSE),

    -- white mazda cx-5
    ('image_url', 9, 'alt_text', TRUE),
    ('image_url', 9, 'alt_text', FALSE),
    ('image_url', 9, 'alt_text', FALSE),

    -- silver hyundai elantra
    ('image_url', 10, 'alt_text', TRUE),
    ('image_url', 10, 'alt_text', FALSE),
    ('image_url', 10, 'alt_text', FALSE),

    -- blue kia sportage
    ('image_url', 11, 'alt_text', TRUE),
    ('image_url', 11, 'alt_text', FALSE),
    ('image_url', 11, 'alt_text', FALSE),

    -- gray volkswagen jetta
    ('image_url', 12, 'alt_text', TRUE),
    ('image_url', 12, 'alt_text', FALSE),
    ('image_url', 12, 'alt_text', FALSE),

    -- red toyota rav4
    ('image_url', 13, 'alt_text', TRUE),
    ('image_url', 13, 'alt_text', FALSE),
    ('image_url', 13, 'alt_text', FALSE),

    -- white chevrolet equinox
    ('image_url', 14, 'alt_text', TRUE),
    ('image_url', 14, 'alt_text', FALSE),
    ('image_url', 14, 'alt_text', FALSE),

    -- black honda cr-v
    ('image_url', 15, 'alt_text', TRUE),
    ('image_url', 15, 'alt_text', FALSE),
    ('image_url', 15, 'alt_text', FALSE),

    -- blue ford escape
    ('image_url', 16, 'alt_text', TRUE),
    ('image_url', 16, 'alt_text', FALSE),
    ('image_url', 16, 'alt_text', FALSE),

    -- silver audi a4
    ('image_url', 17, 'alt_text', TRUE),
    ('image_url', 17, 'alt_text', FALSE),
    ('image_url', 17, 'alt_text', FALSE),

    -- green subaru forester
    ('image_url', 18, 'alt_text', TRUE),
    ('image_url', 18, 'alt_text', FALSE),
    ('image_url', 18, 'alt_text', FALSE),

    -- black dodge charger
    ('image_url', 19, 'alt_text', TRUE),
    ('image_url', 19, 'alt_text', FALSE),
    ('image_url', 19, 'alt_text', FALSE),

    -- white mazda mazda3
    ('image_url', 20, 'alt_text', TRUE),
    ('image_url', 20, 'alt_text', FALSE),
    ('image_url', 20, 'alt_text', FALSE)

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
    FOREIGN KEY (vehicle_id) REFERENCES cars_list(id) ON DELETE CASCADE,
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
    employee_id INTEGER,
    FOREIGN KEY (employee_id) REFERENCES users(id) ON DELETE SET NULL,
    note TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    car_id INTEGER,
    FOREIGN KEY (car_id) REFERENCES cars_list(id) ON DELETE SET NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMIT;