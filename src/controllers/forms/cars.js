import { Router } from 'express';
import { requireLogin } from '../../middleware/auth.js';
import { createSellACarForm, getAllCars, getAllVehicleImages } from '../../models/forms/cars.js';

const router = Router();

/**
 * Display the sell a car form page.
 */
const showSellACarForm = (req, res) => {
    res.render('forms/cars/form', {
        title: 'Sell A Car'
    });
};

/**
 * Display all cars for sale.
 */
const showCarsForSale = async (req, res) => {
    let carsList = [];
    let imagesList = [];

    try {
        carsList = await getAllCars();
    } catch (error) {
        console.error('Error retrieving cars:', error);
    }
    try {
        imagesList = await getAllVehicleImages();
    } catch (error) {
        console.error('Error retrieving vehicle images:', error);
    }   

    res.render('forms/cars/list', {
        title: 'Cars For Sale',
        carsList,
        imagesList
    });
};

function formatNumberInput(input) {
  // Strip out anything that isn't a digit
  let value = input.value.replace(/\D/g, '');
  // Add commas
  input.value = Number(value).toLocaleString('en-US');
}

router.get('/', requireLogin, showSellACarForm, formatNumberInput);

router.get('/list', showCarsForSale);

export default router;