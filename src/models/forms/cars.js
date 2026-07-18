import db from "../db.js";

const createSellACarForm = async (
  vin,
  make,
  model,
  category,
  exterior_color,
  interior_color,
  fuel_type,
  year,
  mileage,
  price,
  listed_by,
) => {
  const query = `
        INSERT INTO cars_list (vin, make, model, category, exterior_color, interior_color, fuel_type, year, mileage, price, listed_by)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
        RETURNING *
    `;
  const result = await db.query(query, [
    vin,
    make,
    model,
    category,
    exterior_color,
    interior_color,
    fuel_type,
    year,
    mileage,
    price,
    listed_by,
  ]);
  return result.rows[0];
};

const insertVehicleImage = async (
  vehicleId,
  imageUrl,
  altText = "",
  isPrimary = false,
) => {
  const query = `
        INSERT INTO vehicle_images (image_url, vehicle_id, alt_text, is_primary)
        VALUES ($1, $2, $3, $4)
        RETURNING *
    `;

  const result = await db.query(query, [
    imageUrl,
    vehicleId,
    altText,
    isPrimary,
  ]);
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

const getAllCategories = async () => {
  const query = `
        SELECT id, name
        FROM categories
    `;
  const result = await db.query(query);
  return result.rows;
};

const getCarById = async (id) => {
  const query = `
    SELECT
      c.id,
      c.vin,
      c.sold,
      c.make,
      c.model,
      c.category,
      c.exterior_color,
      c.interior_color,
      c.fuel_type,
      c.year,
      c.mileage,
      c.price,
      c.purchased_by,
      c.listed_by,
      seller.name AS seller_name,
      buyer.name AS purchaser_name
    FROM cars_list c
    LEFT JOIN users seller ON seller.id = c.listed_by
    LEFT JOIN users buyer ON buyer.id = c.purchased_by
    WHERE c.id = $1
  `;

  const result = await db.query(query, [id]);
  return result.rows[0];
};

const purchaseCar = async (userId, id) => {
  const query = `
    UPDATE cars_list
    SET sold = TRUE,
        purchased_by = $1
    WHERE id = $2 AND sold = FALSE
    RETURNING *`;

  const result = await db.query(query, [userId, id]);
  return result.rows[0];
};

const getAllVehicleImages = async () => {
  const query = `
        SELECT id, image_url, vehicle_id, alt_text, is_primary
        FROM vehicle_images
    `;
  const result = await db.query(query);
  return result.rows;
};

const getVehicleImagesByCarId = async (vehicleId) => {
  const query = `
        SELECT id, image_url, vehicle_id, alt_text, is_primary
        FROM vehicle_images
        WHERE vehicle_id = $1
    `;
  const result = await db.query(query, [vehicleId]);
  return result.rows;
};

export {
  createSellACarForm,
  insertVehicleImage,
  getAllCars,
  getAllCategories,
  getAllVehicleImages,
  getCarById,
  getVehicleImagesByCarId,
  purchaseCar
};
