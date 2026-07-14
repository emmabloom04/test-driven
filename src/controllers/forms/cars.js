import { Router } from 'express';
import { requireLogin } from '../../middleware/auth.js';
import { createSellACarForm, getAllCars } from '../../models/forms/cars.js';

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

    try {
        carsList = await getAllCars();
    } catch (error) {
        console.error('Error retrieving cars:', error);
    }

    res.render('forms/cars/list', {
        title: 'Cars For Sale',
        carsList
    });
};

router.get('/', requireLogin, showSellACarForm);

router.get('/list', showCarsForSale);

export default router;