-- ==========================================================
-- EcoRide Non-Commercial Carpooling Database Schema
-- Database: PostgreSQL 15+ with PostGIS Extension
-- ==========================================================

-- Enable PostGIS for high-performance geospatial route matching
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    firebase_uid VARCHAR(128) UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20) NOT NULL CHECK (gender IN ('male', 'female', 'other')),
    profile_image_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    rating NUMERIC(3, 2) DEFAULT 5.00,
    total_rides INT DEFAULT 0,
    cancellation_count INT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Vehicles Table
CREATE TABLE IF NOT EXISTS vehicles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    make VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    color VARCHAR(50),
    fuel_type VARCHAR(30) NOT NULL CHECK (fuel_type IN ('petrol', 'diesel', 'cng', 'electric')),
    avg_mileage NUMERIC(5, 2) NOT NULL, -- in km/L or km/kWh strictly for non-commercial cost recovery
    number_plate VARCHAR(30) NOT NULL UNIQUE,
    total_seats INT NOT NULL DEFAULT 4,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Driver Legal Documents (DL & RC)
CREATE TABLE IF NOT EXISTS driver_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    dl_number VARCHAR(50) NOT NULL,
    dl_front_url TEXT NOT NULL,
    dl_back_url TEXT NOT NULL,
    rc_number VARCHAR(50) NOT NULL,
    rc_doc_url TEXT NOT NULL,
    status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
    reviewed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Rides Table (Driver Posted Carpools)
CREATE TABLE IF NOT EXISTS rides (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    driver_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vehicle_id UUID NOT NULL REFERENCES vehicles(id) ON DELETE RESTRICT,
    origin_point GEOMETRY(Point, 4326) NOT NULL,
    destination_point GEOMETRY(Point, 4326) NOT NULL,
    origin_address TEXT NOT NULL,
    destination_address TEXT NOT NULL,
    route_polyline GEOMETRY(LineString, 4326), -- PostGIS Linestring for accurate route overlap intersection
    departure_time TIMESTAMP WITH TIME ZONE NOT NULL,
    total_seats INT NOT NULL,
    available_seats INT NOT NULL,
    fuel_price NUMERIC(6, 2) NOT NULL, -- Official daily fuel price per Liter
    women_only BOOLEAN DEFAULT FALSE,
    status VARCHAR(30) DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'in_progress', 'completed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Spatial Indexes for sub-millisecond route proximity matching
CREATE INDEX IF NOT EXISTS idx_rides_origin ON rides USING GIST (origin_point);
CREATE INDEX IF NOT EXISTS idx_rides_destination ON rides USING GIST (destination_point);
CREATE INDEX IF NOT EXISTS idx_rides_route_polyline ON rides USING GIST (route_polyline);
CREATE INDEX IF NOT EXISTS idx_rides_departure ON rides (departure_time);

-- 5. Bookings Table (Rider Seat Reservations)
CREATE TABLE IF NOT EXISTS bookings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
    rider_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    pickup_point GEOMETRY(Point, 4326) NOT NULL,
    dropoff_point GEOMETRY(Point, 4326) NOT NULL,
    pickup_address TEXT NOT NULL,
    dropoff_address TEXT NOT NULL,
    seats_booked INT NOT NULL DEFAULT 1,
    fuel_share_amount NUMERIC(8, 2) NOT NULL, -- Option B non-commercial shared fuel amount
    status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'cancelled', 'completed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_bookings_ride ON bookings (ride_id);
CREATE INDEX IF NOT EXISTS idx_bookings_rider ON bookings (rider_id);

-- 6. Subscriptions Table (Yearly Pass & Free Trial)
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    plan VARCHAR(50) NOT NULL DEFAULT '₹120 / Year Pass',
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    expiry_date TIMESTAMP WITH TIME ZONE NOT NULL,
    payment_id VARCHAR(100),
    status VARCHAR(30) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_subscriptions_user ON subscriptions (user_id);

-- 7. Reviews Table (Two-Way Rating System)
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reviewer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reviewee_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ride_id UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
    rating NUMERIC(2, 1) NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_reviews_reviewee ON reviews (reviewee_id);
