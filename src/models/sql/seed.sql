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
    ('https://weownanycar.co.uk/wp-content/uploads/2021/07/Used_2017_BLACK_BMW_3-SERIES_2.0-318D-M-SPORT-TOURING-5d-AUTO-148-BHP_Estate_for_sale_in_Manchester-5.jpg', 8, 'front view of a black bmw 3 series', TRUE),
    ('http://images.gtcarlot.com/pictures/116809718.jpg', 8, 'side view of a black bmw 3 series', FALSE),
    ('https://prod.pictures.autoscout24.net/listing-images/134031cd-6a56-4d7d-97a6-838c34098703_6c58c360-28c5-4839-b7e1-8c7e27c647a5.jpg/1920x1080.webp', 8, 'back view of a black bmw 3 series', FALSE),

    -- white mazda cx-5
    ('https://i.ytimg.com/vi/NbsNO7Tyk24/maxresdefault.jpg', 9, 'front view of a white mazda cx-5', TRUE),
    ('http://images.gtcarlot.com/pictures/146669509.jpg', 9, 'side view of a white mazda cx-5', FALSE),
    ('https://autoimage.capitalone.com/stock-media/chrome/2025-Mazda-CX-5-2.5_S_Preferred_Package-51K-cc_2025MAS060010_02_2100_51K.png?width=640&height=480', 9, 'back view of a white mazda cx-5', FALSE),

    -- silver hyundai elantra
    ('https://blog.consumerguide.com/wp-content/uploads/sites/2/2021/04/20210301_161359.jpg', 10, 'front view of a silver hyundai elantra', TRUE),
    ('https://www.earnhardthyundai.com/blogs/4378/wp-content/uploads/2020/09/2021-Hyundai_elantra-Exterior_o.png', 10, 'side view of a silver hyundai elantra', FALSE),
    ('https://bidhistory.org/uploads/8Vuie75RA1u4uTNAgpbRGaEMMb/5nplm4agxmh045623-hyundai-elantra-2021-3.jpg', 10, 'back view of a silver hyundai elantra', FALSE),

    -- blue kia sportage
    ('https://www.motoringresearch.com/wp-content/uploads/2020/05/kia-sportage_2018-3-blue-flame_0001.jpg', 11, 'front view of a blue kia sportage', TRUE),
    ('https://product-detail-www-opennext.snc-prod.aws.cinch.co.uk/_next/image?url=https:%2F%2Feu.cdn.autosonshow.tv%2F6676%2F17710%2FRL19OJT%2F03_md.jpg&w=1080&q=75', 11, 'side view of a blue kia sportage', FALSE),
    ('https://www.kia.tn/sites/default/files/image360/new_kia_sportage_blue10.jpg', 11, 'back view of a blue kia sportage', FALSE),

    -- gray volkswagen jetta
    ('https://images.contentstack.io/v3/assets/blt75c85f063ac4ae63/blt547f395537c3d3d6/65f932f606f1968d3e226661/FCP_Euro_Volkswagen_Mk6_Jetta_GLI_Header.jpg', 12, 'front view of a gray volkswagen jetta', TRUE),
    ('https://s1.cdn.autoevolution.com/images/news/gallery/2019-jetta-gli-show-cool-gray-paint-on-35th-anniversary-edition_13.jpg', 12, 'side view of a gray volkswagen jetta', FALSE),
    ('https://images.contentstack.io/v3/assets/blt75c85f063ac4ae63/blt6f770c392d3ae4ca/6605c3c379ac3ebba0aec385/FCP_Euro_Buyers_Guide_Volkswagen_Jetta_Mk6_GLI.jpg', 12, 'back view of a gray volkswagen jetta', FALSE),

    -- red toyota rav4
    ('https://www.usnews.com/object/image/0000018c-92c6-d954-a7bd-96e7aabd0000/2020-toyota-rav4-limited-hv-rubyflarepearl-12.jpg?update-time=1703269542401&size=responsiveGallery', 13, 'front view of a red toyota rav4', TRUE),
    ('https://www.kbb.com/m/4f37f931e8f7f2ef/OG-2026-toyota-rav4-gr-sport-profile-jpg.jpg', 13, 'side view of a red toyota rav4', FALSE),
    ('https://imagecdnblogsa.carbay.com/wp-content/uploads/2025/05/26170700/2026-toyota-rav4-gr-sport-exteri-2.jpg', 13, 'back view of a red toyota rav4', FALSE),

    -- white chevrolet equinox
    ('https://collisiondocsandiego.com/wp-content/uploads/2025/09/chevrolet-equinox-windshield-replaced-san-diego.png', 14, 'front view of a white chevrolet equinox', TRUE),
    ('http://images.gtcarlot.com/pictures/144376374.jpg', 14, 'side view of a white chevrolet equinox', FALSE),
    ('https://www.dubicars.com/images/d6d26a/w_1300x760/colombia-used-cars/dc7e8373-c13b-4f57-b982-386f6755de7e.jpeg', 14, 'back view of a white chevrolet equinox', FALSE),

    -- black honda cr-v
    ('https://platform.cstatic-images.com/xlarge/in/v2/stock_photos/cf9cbffb-b47e-4295-8120-3d24be9f97d5/397391d4-1d3b-4a08-b065-9fc20ea6804c.png', 15, 'front view of a black honda cr-v', TRUE),
    ('https://media.drive.com.au/obj/tx_q:50,rs:auto:1920:1080:1/driveau/upload/cms/uploads/zegqbqlxnfhocl7cwbwj', 15, 'side view of a black honda cr-v', FALSE),
    ('https://cfwww.hgregoire.com/photos/by-size/615517/3648x2048/6906602.JPG', 15, 'back view of a black honda cr-v', FALSE),

    -- blue ford escape
    ('https://d3kmoxju39w6te.cloudfront.net/315b47f7407335704361bd04716f784f/img_0_lg.jpg', 16, 'front view of a blue ford escape', TRUE),
    ('http://images.gtcarlot.com/pictures/128362257.jpg', 16, 'side view of a blue ford escape', FALSE),
    ('https://carrosrd-media.s3.amazonaws.com/listings/71708/full_174370362203889359.jpg', 16, 'back view of a blue ford escape', FALSE),

    -- silver audi a4
    ('https://images.caricos.com/a/audi/2017_audi_a4_us/images/2560x1440/2017_audi_a4_us_1_2560x1440.jpg', 17, 'front view of a silver audi a4', TRUE),
    ('https://i.ytimg.com/vi/73NZvRFX02M/maxresdefault.jpg', 17, 'side view of a silver audi a4', FALSE),
    ('https://images.caricos.com/a/audi/2016_audi_a4/images/2560x1440/2016_audi_a4_124_2560x1440.jpg', 17, 'back view of a silver audi a4', FALSE),

    -- green subaru forester
    ('https://di-uploads-pod46.dealerinspire.com/rairdonsubaruofauburn/uploads/2022/10/2023-subaru-forester-autumn-green-metallic.png', 18, 'front view of a green subaru forester', TRUE),
    ('https://i.extremetech.com/imagery/content-types/02c4pce3KL3GtuMB5C8pWyp/hero-image.fill.size_1200x675.jpg', 18, 'side view of a green subaru forester', FALSE),
    ('https://pictures.dealer.com/generic-subaru-OEM_VIN_STOCK_PHOTOS/8c19ee1f1172387ec23ed9afec02e8fa.jpg?impolicy=resize&w=1024', 18, 'back view of a green subaru forester', FALSE),

    -- black dodge charger
    ('https://images.hgmsites.net/hug/dodge-charger_100702954_h.jpg', 19, 'front view of a black dodge charger', TRUE),
    ('https://images.fitmentindustries.com/web-compressed/2223220-2-2019-charger-dodge-scat-pack-392-hr-lowering-springs-factory-reproductions-fr77-gloss-black.jpg', 19, 'side view of a black dodge charger', FALSE),
    ('https://img.autobytel.com/chrome/colormatched_02/white/640/cc_2019doc20_02_640/cc_2019doc200016_02_640_px8.jpg', 19, 'back view of a black dodge charger', FALSE),

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