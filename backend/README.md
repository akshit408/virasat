# VIRASAT — MERN Backend API Service

Production REST API service built with Node.js, Express.js, and MongoDB for **VIRASAT — Crafted by India**.

---

## Technical Features

- **Authentication**: JWT authentication with Bcrypt password hashing. Role-based access control (`buyer`, `artisan`, `admin`).
- **Database**: MongoDB Mongoose schemas for Users, Artisans, Products, Orders, Festivals, Crafts, and Wishlists.
- **Image Storage**: Multer file uploads with local storage fallback (`/uploads`) & Cloudinary API integration.
- **AI Placeholders**: Simulated endpoints for Image Scanning, Pricing Engine, Heritage Story Generator, and Multilingual Translator.
- **Security**: CORS, Helmet security headers, rate limiting (200 requests/15 mins per IP), input validation.

---

## Directory Structure

```
backend/
├── src/
│   ├── config/          # Database configuration (db.js)
│   ├── controllers/     # Express route handlers
│   ├── middleware/      # Auth (JWT), Multer Upload & Error Handler
│   ├── models/          # Mongoose Schema definitions
│   ├── routes/          # API route definitions
│   ├── seed/            # MongoDB automatic database seed script
│   ├── services/ai/     # AI scanner & generator placeholder services
│   ├── app.js           # Express app setup & middleware mounting
│   └── server.js        # Server listener
├── uploads/             # Local image upload directory
├── .env.example         # Environment template
├── package.json
└── README.md
```

---

## Installation & Setup

1. **Navigate to the backend directory**:
   ```bash
   cd backend
   ```

2. **Install Dependencies**:
   ```bash
   npm install
   ```

3. **Configure Environment Variables**:
   Copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

4. **Seed the Database**:
   Populate MongoDB with 50 crafts, 28 states, 15 festivals, 10 sample artisan profiles, and 100 marketplace products:
   ```bash
   npm run seed
   ```

5. **Start Development Server**:
   ```bash
   npm run dev
   ```

---

## Core API Endpoints

### Authentication (`/api/auth`)
- `POST /api/auth/register` — Register Buyer or Artisan
- `POST /api/auth/login` — JWT Authentication Login
- `POST /api/auth/logout` — Logout user
- `GET /api/auth/me` — Current user profile

### Marketplace (`/api/marketplace`)
- `GET /api/marketplace/home` — Banners, Featured Crafts, GI Collection, Artisans, and Newly Listed

### Products (`/api/products`)
- `GET /api/products` — Filterable/searchable product listing
- `GET /api/products/featured` — Featured crafts
- `GET /api/products/gi` — GI Tagged collection
- `GET /api/products/:id` — Product details
- `POST /api/products` — Create listing (Artisan/Admin)

### Artisans (`/api/artisans`)
- `GET /api/artisans` — List master artisans
- `GET /api/artisans/:id` — Artisan profile & bio
- `GET /api/artisans/:id/stats` — Artisan statistics

### Discover & Crafts (`/api`)
- `GET /api/states` — List of 28 Indian states
- `GET /api/crafts` — List of 50 Indian heritage crafts
- `GET /api/crafts/search?q=` — Craft search

### Orders (`/api/orders`)
- `POST /api/orders` — Place order
- `GET /api/orders/my` — Buyer order history
- `GET /api/orders/artisan` — Artisan received orders

### Wishlist (`/api/wishlist`)
- `GET /api/wishlist` — View wishlist items
- `POST /api/wishlist/:productId` — Add item
- `DELETE /api/wishlist/:productId` — Remove item

---

## Flutter Integration

The Flutter app connects to this backend via Dio repositories (`lib/repositories/`).
Default Base URL: `http://localhost:5000/api` (or `http://10.0.2.2:5000/api` for Android Emulator).
