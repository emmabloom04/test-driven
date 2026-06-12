import { Router } from 'express';
import { body, validationResult } from 'express-validator';
import { createContactForm, getAllContactForms } from '../../models/forms/contact.js';
import { requireLogin } from '../../middleware/auth.js';

const router = Router();

/**
 * Display the contact form page.
 */
const showContactForm = (req, res) => {
    res.render('forms/contact/form', {
        title: 'Contact Us'
    });
};

/**
 * GET /contact - Display the contact form
 */
router.get('/', showContactForm);

export default router;