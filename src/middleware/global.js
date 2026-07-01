/**
 * Express middleware that adds head asset management functionality to routes.
 * Provides arrays for storing CSS and JS assets with priority support.
 * 
 * Adds these methods to the response object:
 * - res.addStyle(css, priority) - Add CSS/link tags to head
 * 
 * Adds these functions to EJS templates via res.locals:
 * - renderStyles() - Outputs all CSS in priority order (high to low)
 */
const setHeadAssetsFunctionality = (res) => {
    res.locals.styles = [];

    res.addStyle = (css, priority = 0) => {
        res.locals.styles.push({ content: css, priority });
    };

    // These functions will be available in EJS templates
    res.locals.renderStyles = () => {
        return res.locals.styles
            // Sort by priority: higher numbers load first
            .sort((a, b) => b.priority - a.priority)
            .map(item => item.content)
            .join('\n');
    };
};

const addLocalVariables = (req, res, next) => {
    // Convenience variable for UI state based on session state
    res.locals.currentUser = req.session?.user || null;
    res.locals.isLoggedIn = Boolean(res.locals.currentUser);
    res.locals.isAdmin = Boolean(
        res.locals.currentUser && res.locals.currentUser.roleName?.toLowerCase() === 'admin'
    );

    res.locals.currentYear = new Date().getFullYear();

    res.locals.NODE_ENV = process.env.NODE_ENV?.toLowerCase() || 'production';

    res.locals.queryParams = { ...req.query };

    setHeadAssetsFunctionality(res)
    res.addStyle('<link rel="stylesheet" href="/css/main.css">', 1);

    next();

}

export { addLocalVariables };