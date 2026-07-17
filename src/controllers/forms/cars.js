import { Router } from 'express';
import { requireLogin } from '../../middleware/auth.js';
import {
    createSellACarForm,
    getAllCars,
    getAllVehicleImages,
    getCarById,
    getVehicleImagesByCarId,
    insertVehicleImage
} from '../../models/forms/cars.js';
import multer from 'multer';
import path from 'path';
import { randomUUID } from 'crypto';

const router = Router();

/**
 * Display the sell a car form page.
 */
const showSellACarForm = (req, res) => {
    res.render('forms/cars/form', {
        title: 'Sell A Car'
    });
};

const uploadsDir = path.join(process.cwd(), 'public', 'uploads');

const upload = multer({
  storage: multer.diskStorage({
    destination: uploadsDir,
    filename: (req, file, cb) => {
      const extension = path.extname(file.originalname).toLowerCase();
      cb(null, `${Date.now()}-${randomUUID()}${extension}`);
    }
  }),
  limits: {
    files: 8,
    fileSize: 5 * 1024 * 1024
  }
});

const processSellACarForm = async (req, res) => {

    // Extract validated data
    const { vin, make, model, category, exteriorColor, interiorColor, fuelType, year, mileage, price } = req.body;

    const uploadedFiles = req.files || [];
    if (!uploadedFiles.length) {
        req.flash('error', 'Please upload at least one car photo.');
        return res.redirect('/cars');
    }

    try {
        const newCar = await createSellACarForm(
            vin,
            make,
            model,
            category,
            exteriorColor,
            interiorColor,
            fuelType,
            Number(year),
            Number(mileage.replace(/,/g, '')),
            Number(price.replace(/,/g, '')),
            req.session?.user?.id || null
        );

        for (const [index, file] of uploadedFiles.entries()) {
            await insertVehicleImage(
                newCar.id,
                `/uploads/${file.filename}`,
                `${make} ${model} photo ${index + 1}`,
                index === 0
            );
        }

        req.flash('success', 'Your car listing has been posted successfully.');
        return res.redirect('/cars/list');
    } catch (error) {
        console.error('Error processing car listing:', error);
        req.flash('error', 'There was an error listing the car. Please try again.');
        return res.redirect('/cars');
    }
}

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

const carDetailPage = async (req, res, next) => {
    const carId = Number(req.params.id);

    try {
        const car = await getCarById(carId);

        if (!car) {
            const err = new Error(`Car ${carId} not found`);
            err.status = 404;
            return next(err);
        }

        const images = await getVehicleImagesByCarId(carId);

        return res.render('forms/cars/detail', {
            title: `${car.year} ${car.make} ${car.model}`,
            car,
            images
        });
    } catch (error) {
        console.error('Error retrieving car detail:', error);
        return next(error);
    }
};

function formatNumberInput(input) {
  // Strip out anything that isn't a digit
  let value = input.value.replace(/\D/g, '');
  // Add commas
  input.value = Number(value).toLocaleString('en-US');
}

router.get('/', requireLogin, showSellACarForm, formatNumberInput);

router.get('/list', showCarsForSale);
router.get('/:id', carDetailPage);
router.post('/', requireLogin, upload.array('carImages', 8), processSellACarForm);

export default router;