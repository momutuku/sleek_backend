# Sleek Property Management Backend

Welcome to the Sleek Property Management laravel backend.


## Table of Contents
1. [Introduction](#introduction)  
2. [Minimum Requirements](#minimum-requirements)  
3. [Project Setup](#project-setup)  
4. [Populate Dummy Data](#populate-dummy-data)  
5. [Authentication](#authentication)  
6. [CRUD Endpoints Explained](#crud-endpoints-explained)  
7. [Postman collection](#postman)


## 1. Introduction  

The **Sleek Property Management** backend provides the following key features:  
- **User Authentication:** Secure login, registration, and profile management using **Laravel Passport**.  
- **Property Management:** APIs to create, read, update, and delete property listings.  
- **Dummy Data:** Easily populate the database with realistic dummy data using seeders and factories.  
- **RESTful API Structure:** Clean and consistent API design for easy integration with any frontend or third-party system.  



## 2. Minimum Requirements  

To run the Laravel backend, ensure your environment meets the following requirements:  

- **PHP 8.0 or higher**  
- **MySQL database** (or compatible database engine)  
- **Composer** (Dependency manager for PHP)  
- **Node.js and npm** (optional, for building assets)  


## 3. Project Setup  

To set up the Laravel backend:  

1. **Clone the repository:**  
   ```bash
   git clone https://github.com/momutuku/sleek_backend.git
   cd sleek
   ```

2. **Install dependencies:**  
   Ensure you have Composer installed, then run:  
   ```bash
   composer install
   ```

3. **Environment configuration:**  
   Copy the `.env.example` file to `.env`:  
   ```bash
   cp .env.example .env
   ```  
   Update the `.env` file with your database credentials and other necessary configurations.

4. **Generate application key:**  
   ```bash
   php artisan key:generate
   ```

5. **Run migrations:**  
   Create the database tables:  
   ```bash
   php artisan migrate
   ```

6. **Install Passport for authentication:**  
   ```bash
   php artisan passport:install
   ```  
   Add the `Passport::routes` to `AuthServiceProvider` to register the routes.  

7. **Serve the application:**  
   Start the Laravel development server:  
   ```bash
   php artisan serve
   ```

Your backend is now set up and running.


## 4. Populate Dummy Data  

To populate your database with dummy data:  

1. **Run the seeders:**  
   Use Laravel seeders and factories to populate data:  
   ```bash
   php artisan db:seed
   ```  

2. **Available seeders:**  
   - `UserSeeder`: Creates dummy users.  
   - `PropertySeeder`: Populates dummy properties.  

Make sure the factories for your models are configured for dummy data generation.


## 5. Authentication  

Sleek Property Management uses **Laravel Passport** for API authentication. Below are the authentication endpoints:

### Endpoints  

#### **POST /register**  
Registers a new user.  
**Body Parameters:**  
- `email` (string)  
- `password` (string)  
- `firstname` (string)  
- `lastname` (string)  

#### **POST /login**  
Logs in an existing user and returns an access token.  
**Body Parameters:**  
- `email` (string)  
- `password` (string)  


## 6. CRUD Endpoints Explained  

The property endpoints handle operations like adding, updating, deleting, and fetching property details.

### Property Endpoints  
- The post, put and delete requests require a valid `Authorization: Bearer <access_token>` header.
#### **POST /property/add**  
Adds a new property.  
**Body Parameters:**  
- `name` (string)  
- `location` (string)  
- `description` (string)  
- `cost` (float)  
- `profile_image` (string - URL of profile image)  
- `images` (array of strings - URLs of property images)  
- `city` (string)  
- `country` (string)  
- `gps_location` (object with `lat` and `long`)  
- `type` (string - e.g., residential, commercial)

#### **PUT /property/update**  
Updates an existing property.  
**Body Parameters:** (same as `POST /property/add`)  

#### **DELETE /property/{id}**  
Deletes a property by ID.

#### **GET /property/{id}**  
Fetches details of a specific property by ID.

#### **GET /property/all**  
Retrieves all properties.

#### **GET /user/properties**  
Fetches all properties owned by the authenticated user.  


### 7. Postman :**  
[Postman Collection](./Sleek.postman_collection.json)
