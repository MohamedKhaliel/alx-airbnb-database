-- Performance Analysis and Optimization
-- Initial Complex Query: Retrieve all bookings with user, property, and payment details

USE alx_airbnb;

-- Initial Query (Before Optimization)
-- This query retrieves all bookings along with user details, property details, and payment details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.user_role,
    u.created_at as user_created_at,
    
    -- Property details
    p.property_id,
    p.p_name,
    p.p_description,
    p.location,
    p.price_per_night,
    p.created_at as property_created_at,
    
    -- Host details
    h.user_id as host_id,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    
    -- Payment details
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- Performance Analysis with EXPLAIN
EXPLAIN SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.user_role,
    u.created_at as user_created_at,
    
    -- Property details
    p.property_id,
    p.p_name,
    p.p_description,
    p.location,
    p.price_per_night,
    p.created_at as property_created_at,
    
    -- Host details
    h.user_id as host_id,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    
    -- Payment details
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- ============================================================================
-- OPTIMIZED QUERY (After Performance Improvements)
-- ============================================================================

-- Step 1: Add Performance Indexes
-- These indexes will significantly improve join performance

-- Index on Booking table for foreign keys and ordering
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_created_at ON Booking(created_at DESC);

-- Index on Property table for host_id foreign key
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on Payment table for booking_id foreign key
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- Composite index on User table for common lookups
CREATE INDEX idx_user_lookup ON User(user_id, first_name, last_name, email);

-- Step 2: Optimized Query with Better Performance
-- This query uses the new indexes and optimized join strategy

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details (only essential fields)
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.user_role,
    
    -- Property details (only essential fields)
    p.property_id,
    p.p_name,
    p.location,
    p.price_per_night,
    
    -- Host details (only essential fields)
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    
    -- Payment details (only if exists)
    pay.payment_id,
    pay.amount,
    pay.payment_method
    
FROM Booking b
-- Use STRAIGHT_JOIN hint to force join order optimization
STRAIGHT_JOIN User u ON b.user_id = u.user_id
STRAIGHT_JOIN Property p ON b.property_id = p.property_id
STRAIGHT_JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- Step 3: Performance Analysis of Optimized Query
EXPLAIN SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details (only essential fields)
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.user_role,
    
    -- Property details (only essential fields)
    p.property_id,
    p.p_name,
    p.location,
    p.price_per_night,
    
    -- Host details (only essential fields)
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    
    -- Payment details (only if exists)
    pay.payment_id,
    pay.amount,
    pay.payment_method
    
FROM Booking b
STRAIGHT_JOIN User u ON b.user_id = u.user_id
STRAIGHT_JOIN Property p ON b.property_id = p.property_id
STRAIGHT_JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC;

-- Step 4: Alternative Optimized Query with Pagination
-- For large datasets, use LIMIT and OFFSET for pagination

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.user_role,
    
    -- Property details
    p.property_id,
    p.p_name,
    p.location,
    p.price_per_night,
    
    -- Host details
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    
    -- Payment details
    pay.payment_id,
    pay.amount,
    pay.payment_method
    
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC
LIMIT 50 OFFSET 0;

-- Step 5: Performance Monitoring Queries

-- Check index usage
SHOW INDEX FROM Booking;
SHOW INDEX FROM User;
SHOW INDEX FROM Property;
SHOW INDEX FROM Payment;

-- Analyze table statistics
ANALYZE TABLE Booking;
ANALYZE TABLE User;
ANALYZE TABLE Property;
ANALYZE TABLE Payment;

-- Check query performance with profiling
SET profiling = 1;

-- Run the optimized query
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    u.first_name,
    u.last_name,
    p.p_name,
    h.first_name as host_first_name,
    pay.amount
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
ORDER BY b.created_at DESC
LIMIT 10;

-- Show profiling results
SHOW PROFILES;
