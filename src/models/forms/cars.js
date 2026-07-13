import db from '../db.js';


const createSellACarForm = async (vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price) => {
    const query = `
        INSERT INTO contact_form (vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
        RETURNING *
    `;
    const result = await db.query(query, [vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price]);
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

export { createSellACarForm, getAllCars };