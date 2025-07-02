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

-- Performance Analysis and Optimization with WHERE & AND Clauses
-- Filtered Complex Queries: Retrieve bookings with user, property, and payment details

USE alx_airbnb;

-- ============================================================================
-- INITIAL QUERY WITH WHERE & AND CLAUSES (Before Optimization)
-- ============================================================================

-- Query 1: Bookings for confirmed status with specific date range
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
WHERE b.status = 'confirmed' 
    AND b.start_date >= '2024-01-01' 
    AND b.end_date <= '2024-12-31'
    AND b.total_price > 100.00
ORDER BY b.created_at DESC;

-- Query 2: Bookings for specific user role and location
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
WHERE u.user_role = 'guest' 
    AND p.location LIKE '%New York%'
    AND b.status IN ('confirmed', 'pending')
    AND p.price_per_night BETWEEN 50.00 AND 500.00
ORDER BY b.created_at DESC;

-- Query 3: Bookings with payment method and host role filter
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
WHERE h.user_role = 'host' 
    AND pay.payment_method = 'credit_card'
    AND b.created_at >= '2024-06-01'
    AND pay.amount > 0
ORDER BY b.created_at DESC;

-- ============================================================================
-- OPTIMIZED QUERIES WITH WHERE & AND CLAUSES (After Performance Improvements)
-- ============================================================================

-- Step 1: Add Performance Indexes for WHERE clauses
-- These indexes will significantly improve WHERE clause performance

-- Index on Booking table for status and date filtering
CREATE INDEX idx_booking_status_dates ON Booking(status, start_date, end_date);
CREATE INDEX idx_booking_total_price ON Booking(total_price);
CREATE INDEX idx_booking_created_at_status ON Booking(created_at DESC, status);

-- Index on Property table for location and price filtering
CREATE INDEX idx_property_location_price ON Property(location, price_per_night);

-- Index on User table for role filtering
CREATE INDEX idx_user_role ON User(user_role);

-- Index on Payment table for method and amount filtering
CREATE INDEX idx_payment_method_amount ON Payment(payment_method, amount);

-- Step 2: Optimized Query 1 - Confirmed bookings with date range
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
STRAIGHT_JOIN User u ON b.user_id = u.user_id
STRAIGHT_JOIN Property p ON b.property_id = p.property_id
STRAIGHT_JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed' 
    AND b.start_date >= '2024-01-01' 
    AND b.end_date <= '2024-12-31'
    AND b.total_price > 100.00
ORDER BY b.created_at DESC
LIMIT 50;

-- Step 3: Optimized Query 2 - Guest bookings in specific location
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
STRAIGHT_JOIN User u ON b.user_id = u.user_id
STRAIGHT_JOIN Property p ON b.property_id = p.property_id
STRAIGHT_JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE u.user_role = 'guest' 
    AND p.location LIKE '%New York%'
    AND b.status IN ('confirmed', 'pending')
    AND p.price_per_night BETWEEN 50.00 AND 500.00
ORDER BY b.created_at DESC
LIMIT 50;

-- Step 4: Optimized Query 3 - Host bookings with credit card payments
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
STRAIGHT_JOIN User u ON b.user_id = u.user_id
STRAIGHT_JOIN Property p ON b.property_id = p.property_id
STRAIGHT_JOIN User h ON p.host_id = h.user_id
INNER JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE h.user_role = 'host' 
    AND pay.payment_method = 'credit_card'
    AND b.created_at >= '2024-06-01'
    AND pay.amount > 0
ORDER BY b.created_at DESC
LIMIT 50;

-- ============================================================================
-- PERFORMANCE ANALYSIS WITH EXPLAIN
-- ============================================================================

-- Analyze optimized query 1
EXPLAIN SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.user_role,
    p.property_id,
    p.p_name,
    p.location,
    p.price_per_night,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    pay.payment_id,
    pay.amount,
    pay.payment_method
FROM Booking b
STRAIGHT_JOIN User u ON b.user_id = u.user_id
STRAIGHT_JOIN Property p ON b.property_id = p.property_id
STRAIGHT_JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed' 
    AND b.start_date >= '2024-01-01' 
    AND b.end_date <= '2024-12-31'
    AND b.total_price > 100.00
ORDER BY b.created_at DESC
LIMIT 50;

-- ============================================================================
-- ADDITIONAL FILTERED QUERIES WITH COMPLEX WHERE CONDITIONS
-- ============================================================================

-- Query 4: High-value bookings with specific payment methods
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    p.p_name,
    p.location,
    h.first_name as host_first_name,
    pay.payment_method,
    pay.amount
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
INNER JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.total_price >= 500.00 
    AND pay.payment_method IN ('credit_card', 'stripe')
    AND b.status = 'confirmed'
    AND b.start_date >= CURDATE()
    AND u.user_role = 'guest'
    AND h.user_role = 'host'
ORDER BY b.total_price DESC
LIMIT 25;

-- Query 5: Recent bookings with pending payments
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    p.p_name,
    p.location,
    h.first_name as host_first_name,
    pay.payment_method,
    pay.amount
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    AND (pay.payment_id IS NULL OR pay.amount = 0)
    AND b.status IN ('pending', 'confirmed')
    AND p.price_per_night > 100.00
    AND u.user_role = 'guest'
ORDER BY b.created_at DESC
LIMIT 50;

-- Query 6: Bookings with specific date patterns and user criteria
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at as booking_created_at,
    u.first_name,
    u.last_name,
    u.email,
    p.p_name,
    p.location,
    h.first_name as host_first_name,
    pay.payment_method,
    pay.amount
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE YEAR(b.start_date) = 2024 
    AND MONTH(b.start_date) IN (6, 7, 8)  -- Summer months
    AND b.total_price BETWEEN 200.00 AND 1000.00
    AND p.location NOT LIKE '%New York%'
    AND p.location NOT LIKE '%Los Angeles%'
    AND b.status = 'confirmed'
    AND pay.payment_method IS NOT NULL
    AND u.user_role = 'guest'
    AND h.user_role = 'host'
ORDER BY b.start_date ASC, b.total_price DESC
LIMIT 100;

-- ============================================================================
-- PERFORMANCE MONITORING FOR FILTERED QUERIES
-- ============================================================================

-- Check index usage for WHERE clause columns
SHOW INDEX FROM Booking WHERE Key_name LIKE '%status%' OR Key_name LIKE '%date%';
SHOW INDEX FROM Property WHERE Key_name LIKE '%location%' OR Key_name LIKE '%price%';
SHOW INDEX FROM User WHERE Key_name LIKE '%role%';
SHOW INDEX FROM Payment WHERE Key_name LIKE '%method%' OR Key_name LIKE '%amount%';

-- Analyze table statistics for better query planning
ANALYZE TABLE Booking;
ANALYZE TABLE User;
ANALYZE TABLE Property;
ANALYZE TABLE Payment;

-- Enable query profiling for performance measurement
SET profiling = 1;

-- Test performance of filtered query
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location,
    h.first_name as host_first_name,
    pay.payment_method
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
INNER JOIN User h ON p.host_id = h.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.status = 'confirmed' 
    AND b.start_date >= '2024-01-01' 
    AND b.total_price > 100.00
    AND u.user_role = 'guest'
ORDER BY b.created_at DESC
LIMIT 10;

-- Show profiling results
SHOW PROFILES;
