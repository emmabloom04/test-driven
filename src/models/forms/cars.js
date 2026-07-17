import db from '../db.js';


const createSellACarForm = async (vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price) => {
    const query = `
        INSERT INTO cars_list (vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING *
    `;
    const result = await db.query(query, [vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price]);
    return result.rows[0];
};

const insertVehicleImage = async (vehicleId, imageUrl, altText = '', isPrimary = false) => {
    const query = `
        INSERT INTO vehicle_images (image_url, vehicle_id, alt_text, is_primary)
        VALUES ($1, $2, $3, $4)
        RETURNING *
    `;

    const result = await db.query(query, [imageUrl, vehicleId, altText, isPrimary]);
    return result.rows[0];
};

/**
 * Retrieves all cars in the database.
 * 
 * @returns {Promise<Array>} Array of cars
 */
const getAllCars = async () => {
    const query = `
        SELECT id, vin, sold, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price, purchased_by, listed_by
        FROM cars_list
    `;
    const result = await db.query(query);
    return result.rows;
};

const getAllVehicleImages = async () => {
    const query = `
        SELECT id, image_url, vehicle_id, alt_text, is_primary
        FROM vehicle_images
    `;
    const result = await db.query(query);
    return result.rows;
}

const getCarById = async (id) => {
    const query = `
        SELECT id, vin, sold, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price, purchased_by, listed_by
        FROM cars_list
        WHERE id= $1
    `;
    const result = await db.query(query, [id]);
    return result.rows[0];
}

const getVehicleImagesByCarId = async (vehicleId) => {
    const query = `
        SELECT id, image_url, vehicle_id, alt_text, is_primary
        FROM vehicle_images
        WHERE vehicle_id = $1
    `;
    const result = await db.query(query, [vehicleId])
    return result.rows[0];
}

export { createSellACarForm, insertVehicleImage, getAllCars, getAllVehicleImages, getCarById, getVehicleImagesByCarId };