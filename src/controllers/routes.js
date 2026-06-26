import { homePage, testErrorPage } from './index.js';
import contactRoutes from './forms/contact.js';
import registrationRoutes from './forms/registration.js';
import loginRoutes from './forms/login.js';
import carsRoutes from './forms/cars.js';
import { processLogout } from './forms/login.js';
import { requireLogin } from '../middleware/auth.js';
import { Router } from 'express';

const router = Router();

// Add contact-specific styles to all contact routes
router.use('/contact', (req, res, next) => {
    res.addStyle('<link rel="stylesheet" href="/css/contact.css">');
    next();
});

// Add registration-specific styles to all registration routes
router.use('/register', (req, res, next) => {
    res.addStyle('<link rel="stylesheet" href="/css/registration.css">');
    next();
});

// Add login-specific styles to all login routes
router.use('/login', (req, res, next) => {
    res.addStyle('<link rel="stylesheet" href="/css/login.css">');
    next();
});

// Add car-specific styles to all car routes
router.use('/cars', (req, res, next) => {
    res.addStyle('<link rel="stylesheet" href="/css/cars.css">')
    next();
})

router.get('/', homePage);

// Contact form routes
router.use('/contact', contactRoutes);

// Registration routes
router.use('/register', registrationRoutes);

// Login routes (form and submission)
router.use('/login', loginRoutes);

// Authentication-related routes at root level
router.get('/logout', processLogout);

// Route to trigger a test error
router.get('/test-error', testErrorPage);

export default router;