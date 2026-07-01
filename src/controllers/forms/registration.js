import { Router } from "express";
import { validationResult } from "express-validator";
import bcrypt from "bcrypt";
import {
  emailExists,
  saveUser,
  getAllUsers,
  getUserById,
  updateUser,
  deleteUser,
} from "../../models/forms/registration.js";
import { requireLogin, requireRole } from "../../middleware/auth.js";
import {
  registrationValidation,
  editValidation,
} from "../../middleware/validation/forms.js";

const router = Router();

/**
 * Display the registration form page.
 */
const showRegistrationForm = (req, res) => {
  res.render("forms/registration/form", {
    title: "User Registration",
  });
};

/**
 * Handle user registration with validation and password hashing.
 */
const processRegistration = async (req, res) => {
  // Check for validation errors
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    // Store each validation error as a separate flash message
    errors.array().forEach((error) => {
      req.flash("error", error.msg);
    });
    return res.redirect("/register");
  }

  // Extract validated data from request body
  const { name, email, password } = req.body;

  try {
    // Check if email already exists in database
    const alreadyExists = await emailExists(email);

    if (alreadyExists) {
      req.flash("warning", "An account with this email already exists");
      return res.redirect("/register");
    }

    // Hash the password before saving to database
    const hashedPassword = await bcrypt.hash(password, 10);

    // Save user to database with hashed password
    // Call saveUser(name, email, hashedPassword)
    await saveUser(name, email, hashedPassword);

    req.flash("success", "Registration successful");
    res.redirect("/login");

    // NOTE: Later when we add authentication, we'll change this to require login first
  } catch (error) {
    console.error("Error with registration:", error);
    req.flash("error", "Error with registration. Please try again later.");
    res.redirect("/register");
  }
};

/**
 * Display all registered users.
 */
const showAllUsers = async (req, res) => {
  let users = [];

  try {
    users = await getAllUsers();
  } catch (error) {
    console.error("Error retrieving users:", error);
  }

  res.render("forms/registration/list", {
    title: "Registered Users",
    users,
    user: req.session && req.session.user ? req.session.user : null,
  });
};

/**
 * Display the edit account form.
 */
const showEditAccountForm = async (req, res) => {
  const targetUserId = parseInt(req.params.id, 10);
  const currentUser = req.session?.user;

  if (!Number.isInteger(targetUserId)) {
    req.flash("error", "Invalid user ID.");
    return res.redirect("/register/list");
  }

  const targetUser = await getUserById(targetUserId);

  if (!targetUser) {
    req.flash("error", "User not found.");
    return res.redirect("/register/list");
  }

  const isAdmin = Boolean(
    currentUser &&
    currentUser.roleName &&
    currentUser.roleName.toLowerCase() === "admin",
  );
  const canEdit =
    Boolean(currentUser) && (isAdmin || currentUser.id === targetUserId);

  if (!canEdit) {
    req.flash("error", "You do not have permission to edit this account.");
    return res.redirect("/register/list");
  }

  res.render("forms/registration/edit", {
    title: "Edit Account",
    user: targetUser,
    currentUser,
  });
};

/**
 * Process account edit form submission
 */
const processEditAccount = async (req, res) => {
  const targetUserId = parseInt(req.params.id, 10);
  const currentUser = req.session?.user;
  const { name, email } = req.body;
  const trimmedName = name?.trim();
  const trimmedEmail = email?.trim().toLowerCase();

  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    errors.array().forEach((error) => {
      req.flash("error", error.msg);
    });

    return res.status(400).render("forms/registration/edit", {
      title: "Edit Account",
      currentUser,
      user: {
        id: targetUserId,
        name: trimmedName,
        email: trimmedEmail,
      },
    });
  }

  try {
    const targetUser = await getUserById(targetUserId);

    if (!targetUser) {
      req.flash("error", "User not found.");
      return res.redirect("/register/list");
    }

    const isAdmin = Boolean(
      currentUser &&
      currentUser.roleName &&
      currentUser.roleName.toLowerCase() === "admin",
    );
    const canEdit =
      Boolean(currentUser) && (isAdmin || currentUser.id === targetUserId);

    if (!canEdit) {
      req.flash("error", "You do not have permission to edit this account.");
      return res.redirect("/register/list");
    }

    // Check if new email already exists (and belongs to a different user)
    const emailTaken = await emailExists(trimmedEmail);
    if (emailTaken && targetUser.email !== trimmedEmail) {
      req.flash("error", "An account with this email already exists.");
      return res.status(400).render("forms/registration/edit", {
        title: "Edit Account",
        currentUser,
        user: {
          id: targetUserId,
          name: trimmedName,
          email: trimmedEmail,
        },
      });
    }

    await updateUser(targetUserId, trimmedName, trimmedEmail);

    if (currentUser && currentUser.id === targetUserId) {
      req.session.user.name = trimmedName;
      req.session.user.email = trimmedEmail;
    }

    req.flash("success", "Account updated successfully.");
    return res.redirect("/register/list");
  } catch (error) {
    console.error("Error updating account:", error);
    req.flash("error", "An error occurred while updating the account.");
    return res.redirect(`/register/${targetUserId}/edit`);
  }
};

/**
 * Process account deletion
 * Only admins can delete accounts, and they cannot delete themselves
 */
const processDeleteAccount = async (req, res) => {
  const targetUserId = parseInt(req.params.id, 10);
  const currentUser = req.session?.user;

  if (!currentUser) {
    req.flash("error", "You must be logged in to delete this account.");
    return res.redirect("/login");
  }

  if (currentUser.id !== targetUserId) {
    req.flash("error", "You do not have permission to delete this account.");
    return res.redirect("/register/list");
  }

  try {
    const deleted = await deleteUser(targetUserId);

    if (!deleted) {
      req.flash("error", "User not found or already deleted.");
      return res.redirect("/register/list");
    }

    req.session.destroy((err) => {
      if (err) {
        console.error("Error destroying session after account deletion:", err);
      }

      res.clearCookie("connect.sid");
      return res.redirect("/login");
    });
  } catch (error) {
    console.error("Error deleting user:", error);
    req.flash("error", "An error occurred while deleting the account.");
    return res.redirect("/register/list");
  }
};

/**
 * GET /register - Display the registration form
 */
router.get("/", showRegistrationForm);

/**
 * POST /register - Handle registration form submission with validation
 */
router.post("/", registrationValidation, processRegistration);

/**
 * GET /register/list - Display all registered users
 */
router.get("/list", requireLogin, requireRole("admin"), showAllUsers);

/**
 * GET /register/:id/edit - Display edit account form
 */
router.get("/:id/edit", requireLogin, showEditAccountForm);

/**
 * POST /register/:id/edit - Process account edit
 */
router.post("/:id/edit", requireLogin, editValidation, processEditAccount);

/**
 * POST /register/:id/delete - Delete user account
 */
router.post("/:id/delete", requireLogin, processDeleteAccount);

export default router;
