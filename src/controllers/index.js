// route handlers for static pages

const homePage = (req, res) => {
    res.render('home', { title: 'Test Driven' });
};

const aboutPage = (req, res) => {
    res.render('about', { title: 'About Test Driven' })
}

const testErrorPage = (req, res, next) => {
    const err = new Error('This is a test error');
    err.status = 500;
    next(err);
}

export { homePage, aboutPage, testErrorPage };