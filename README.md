# Test Driven
CSE 340 personal project

# Project Description
This is a used car web application built with Express JS. It allows users to see various cars for sale, list their own cars for sale, and edit their account. They are able to see specifics about each car, and even purchase one of the cars listed for sale.

# Database Schema
![database erd](public/images/full%20erd%20table.png)

# User Roles
### Standard User
A standard user can purchase cars and list cars for sale. These are the only additional features they have above a nonlogged in user.
### Employee
An employee can do everything that a standard user can do and can also view responses to the contact form.
### Admin
An admin can do everything that an employee can do and can also view all registered users.

# Test Account Credentials
Standard User: standardtestuser@example.com
Employee: testemployee@example.com
Admin: testadmin@example.com

# Known Limitations
There are various limitations to the current project implementation, but the main ones that would be problematic in the long run is the setup of images. Right now, it stores a copy of the image to an uploads folder inside of the project. It doesn't have a clean up function to ensure that images that are no longer needed are being deleted. This was a short term implementation that I was able to do in a small amount of time. Also, there is no verification while users are registering in relation to roles. Anyone could register as an employee or an admin. There are also several other features I would love to add with more time, such as adding service requests, reviews, and allowing employees and admin to have a bit more control over content displayed on the website.

## Current build link
https://test-driven.onrender.com/