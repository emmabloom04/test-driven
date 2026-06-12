import { Router } from 'express';
import { homePage, testErrorPage } from './index.js';
import contactRoutes from './forms/contact.js';

const router = Router();

router.get('/', homePage);

// Contact form routes
router.use('/contact', contactRoutes);

// Route to trigger a test error
router.get('/test-error', testErrorPage);

export default router;