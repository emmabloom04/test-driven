import { Router } from 'express';
import { homePage, testErrorPage } from './index.js';

const router = Router();

router.get('/', homePage);

// Route to trigger a test error
router.get('/test-error', testErrorPage);

export default router;