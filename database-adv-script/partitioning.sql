-- Table Partitioning Implementation for Booking Table
-- Objective: Optimize queries on large datasets by partitioning on start_date

USE alx_airbnb;

-- ============================================================================
-- STEP 1: BACKUP AND PREPARATION
-- ============================================================================

-- Create backup of existing Booking table (if it exists)
-- Note: In production, you would create a proper backup before partitioning
CREATE TABLE Booking_backup AS SELECT * FROM Booking;

-- Drop existing indexes on Booking table to prepare for partitioning
-- (Indexes will be recreated after partitioning)
DROP INDEX IF EXISTS idx_booking_user_id ON Booking;
DROP INDEX IF EXISTS idx_booking_property_id ON Booking;
DROP INDEX IF EXISTS idx_booking_created_at ON Booking;
DROP INDEX IF EXISTS idx_booking_status_dates ON Booking;
DROP INDEX IF EXISTS idx_booking_total_price ON Booking;
DROP INDEX IF EXISTS idx_booking_created_at_status ON Booking;

-- ============================================================================
-- STEP 2: CREATE PARTITIONED BOOKING TABLE
-- ============================================================================

-- Drop existing Booking table to recreate with partitioning
DROP TABLE IF EXISTS Booking;

-- Create new Booking table with RANGE partitioning on start_date
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY default(uuid()),
    property_id CHAR(36),
    user_id CHAR(36),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p2026 VALUES LESS THAN (2027),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- ============================================================================
-- STEP 3: RESTORE DATA TO PARTITIONED TABLE
-- ============================================================================

-- Restore data from backup to partitioned table
INSERT INTO Booking 
SELECT * FROM Booking_backup;

-- ============================================================================
-- STEP 4: CREATE OPTIMIZED INDEXES FOR PARTITIONED TABLE
-- ============================================================================

-- Create local indexes on each partition for better performance
-- Note: These indexes will be created on each partition automatically

-- Primary key index (automatically created)
-- Foreign key indexes for join performance
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Composite indexes for common query patterns
CREATE INDEX idx_booking_status_date ON Booking(status, start_date);
CREATE INDEX idx_booking_date_status ON Booking(start_date, status);
CREATE INDEX idx_booking_price_date ON Booking(total_price, start_date);
CREATE INDEX idx_booking_created_at ON Booking(created_at DESC);

-- ============================================================================
-- STEP 5: PERFORMANCE TESTING QUERIES
-- ============================================================================

-- Test 1: Query on specific year partition (should be very fast)
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= '2024-01-01' 
    AND b.start_date <= '2024-12-31'
    AND b.status = 'confirmed'
ORDER BY b.start_date DESC
LIMIT 50;

-- Test 2: Query spanning multiple partitions (should still be optimized)
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= '2023-01-01' 
    AND b.start_date <= '2024-12-31'
    AND b.total_price > 200.00
ORDER BY b.start_date DESC
LIMIT 100;

-- Test 3: Query with complex WHERE conditions on partitioned column
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE YEAR(b.start_date) = 2024 
    AND MONTH(b.start_date) IN (6, 7, 8)  -- Summer months
    AND b.status IN ('confirmed', 'pending')
    AND b.total_price BETWEEN 100.00 AND 1000.00
ORDER BY b.start_date ASC
LIMIT 75;

-- Test 4: Query with date range and additional filters
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    AND b.start_date <= CURDATE()
    AND u.user_role = 'guest'
    AND p.location LIKE '%New York%'
ORDER BY b.start_date DESC
LIMIT 50;

-- ============================================================================
-- STEP 6: PERFORMANCE ANALYSIS WITH EXPLAIN
-- ============================================================================

-- Analyze partition usage for Test 1
EXPLAIN SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= '2024-01-01' 
    AND b.start_date <= '2024-12-31'
    AND b.status = 'confirmed'
ORDER BY b.start_date DESC
LIMIT 50;

-- Analyze partition usage for Test 2
EXPLAIN SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= '2023-01-01' 
    AND b.start_date <= '2024-12-31'
    AND b.total_price > 200.00
ORDER BY b.start_date DESC
LIMIT 100;

-- ============================================================================
-- STEP 7: PARTITION MANAGEMENT QUERIES
-- ============================================================================

-- Check partition information
SELECT 
    TABLE_NAME,
    PARTITION_NAME,
    PARTITION_ORDINAL_POSITION,
    PARTITION_METHOD,
    PARTITION_EXPRESSION,
    PARTITION_DESCRIPTION,
    TABLE_ROWS,
    AVG_ROW_LENGTH,
    DATA_LENGTH,
    MAX_DATA_LENGTH,
    INDEX_LENGTH,
    DATA_FREE
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = 'alx_airbnb' 
    AND TABLE_NAME = 'Booking'
ORDER BY PARTITION_ORDINAL_POSITION;

-- Check which partitions are being used in queries
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = 'alx_airbnb' 
    AND TABLE_NAME = 'Booking'
ORDER BY PARTITION_ORDINAL_POSITION;

-- ============================================================================
-- STEP 8: ADVANCED PARTITIONING FEATURES
-- ============================================================================

-- Add new partition for future years (example for 2027)
ALTER TABLE Booking ADD PARTITION (
    PARTITION p2027 VALUES LESS THAN (2028)
);

-- Reorganize partitions (example: split a large partition)
-- This would be useful if p2024 becomes too large
-- ALTER TABLE Booking REORGANIZE PARTITION p2024 INTO (
--     PARTITION p2024_q1 VALUES LESS THAN ('2024-04-01'),
--     PARTITION p2024_q2 VALUES LESS THAN ('2024-07-01'),
--     PARTITION p2024_q3 VALUES LESS THAN ('2024-10-01'),
--     PARTITION p2024_q4 VALUES LESS THAN ('2025-01-01')
-- );

-- ============================================================================
-- STEP 9: PERFORMANCE COMPARISON QUERIES
-- ============================================================================

-- Enable profiling for performance measurement
SET profiling = 1;

-- Test query performance on partitioned table
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.first_name,
    u.last_name,
    p.p_name,
    p.location
FROM Booking b
INNER JOIN User u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= '2024-01-01' 
    AND b.start_date <= '2024-12-31'
    AND b.status = 'confirmed'
ORDER BY b.start_date DESC
LIMIT 25;

-- Show profiling results
SHOW PROFILES;

-- ============================================================================
-- STEP 10: MAINTENANCE QUERIES
-- ============================================================================

-- Analyze table statistics for better query planning
ANALYZE TABLE Booking;

-- Check table size and partition distribution
SELECT 
    PARTITION_NAME,
    TABLE_ROWS,
    ROUND(DATA_LENGTH/1024/1024, 2) AS 'Data Size (MB)',
    ROUND(INDEX_LENGTH/1024/1024, 2) AS 'Index Size (MB)',
    ROUND((DATA_LENGTH + INDEX_LENGTH)/1024/1024, 2) AS 'Total Size (MB)'
FROM INFORMATION_SCHEMA.PARTITIONS 
WHERE TABLE_SCHEMA = 'alx_airbnb' 
    AND TABLE_NAME = 'Booking'
ORDER BY PARTITION_ORDINAL_POSITION;

-- Check for partition pruning effectiveness
EXPLAIN PARTITIONS SELECT 
    COUNT(*) as booking_count
FROM Booking 
WHERE start_date >= '2024-01-01' 
    AND start_date <= '2024-12-31';

-- ============================================================================
-- STEP 11: CLEANUP
-- ============================================================================

-- Drop backup table after successful partitioning
-- DROP TABLE Booking_backup;

-- Note: Keep backup until you're confident the partitioning works correctly 