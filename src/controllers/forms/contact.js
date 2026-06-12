import { Router } from 'express';

const router = Router();

/**
 * Display the contact form page.
 */
const showContactForm = (req, res) => {
    res.render('forms/contact', {
        title: 'Contact Us'
    });
};

/**
 * GET /contact - Display the contact form
 */
router.get('/', showContactForm);

export default router;