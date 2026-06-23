import { homePage, testErrorPage } from './index.js';
import contactRoutes from './forms/contact.js';
import loginRoutes from './forms/login.js';
import { processLogout, showDashboard } from './forms/login.js';
import { requireLogin } from '../middleware/auth.js';
import { Router } from 'express';

const router = Router();

// Add contact-specific styles to all contact routes
router.use('/contact', (req, res, next) => {
    res.addStyle('<link rel="stylesheet" href="/css/contact.css">');
    next();
});

// Add login-specific styles to all login routes
router.use('/login', (req, res, next) => {
    res.addStyle('<link rel="stylesheet" href="/css/login.css">');
    next();
});

router.get('/', homePage);

// Contact form routes
router.use('/contact', contactRoutes);

// Route to trigger a test error
router.get('/test-error', testErrorPage);

// Login routes (form and submission)
router.use('/login', loginRoutes);

// Authentication-related routes at root level
router.get('/logout', processLogout);

export default router;