# Database Normalization Analysis for Airbnb Clone

## Current Schema Review

The current database schema consists of 6 main tables:
- `User` - Stores user information
- `Property` - Stores property listings
- `Booking` - Manages reservations
- `Payment` - Handles payment transactions
- `Review` - Stores user reviews
- `Message` - Manages user communications

## Normalization Analysis

### Current State Assessment

The schema is generally well-designed and follows many normalization principles, but there are several areas for improvement to achieve full 3NF compliance.

### Issues Identified

#### 1. **Partial Dependencies (2NF Violations)**

**Issue**: The `Property` table contains location information that could be further normalized.

**Current Structure**:
```sql
Property (
    property_id,
    host_id,
    p_name,
    p_description,
    location,  -- This could be broken down further
    price_per_night,
    created_at,
    updated_at
)
```

**Problem**: The `location` field likely contains multiple pieces of information (city, state, country, postal code) that could be stored separately.

#### 2. **Transitive Dependencies (3NF Violations)**

**Issue**: The `Booking` table contains a calculated field that depends on other data.

**Current Structure**:
```sql
Booking (
    booking_id,
    property_id,
    user_id,
    start_date,
    end_date,
    total_price,  -- This is calculated from price_per_night * duration
    status,
    created_at
)
```

**Problem**: `total_price` is a calculated field that depends on `price_per_night` from the Property table and the date range. This creates a transitive dependency.

#### 3. **Missing Normalization Opportunities**

**Issue**: The `User` table combines different types of user information that could be separated.

**Current Structure**:
```sql
User (
    user_id,
    first_name,
    last_name,
    email,
    password_hash,
    phone_number,
    user_role,  -- This could be in a separate table
    created_at
)
```

## Recommended Normalization Improvements

### 1. **Address Normalization**

Create separate tables for location data:

```sql
-- COUNTRY TABLE
CREATE TABLE Country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    country_code CHAR(2) NOT NULL UNIQUE
);

-- STATE/PROVINCE TABLE
CREATE TABLE State (
    state_id INT PRIMARY KEY AUTO_INCREMENT,
    country_id INT NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    state_code VARCHAR(10),
    FOREIGN KEY (country_id) REFERENCES Country(country_id),
    UNIQUE KEY unique_state (country_id, state_name)
);

-- CITY TABLE
CREATE TABLE City (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    state_id INT NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (state_id) REFERENCES State(state_id),
    UNIQUE KEY unique_city (state_id, city_name)
);

-- ADDRESS TABLE
CREATE TABLE Address (
    address_id CHAR(36) PRIMARY KEY DEFAULT(uuid()),
    city_id INT NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    FOREIGN KEY (city_id) REFERENCES City(city_id)
);
```

### 2. **Property Table Refactoring**

Update the Property table to use the new address structure:

```sql
-- PROPERTY TABLE (Updated)
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY DEFAULT(uuid()),
    host_id CHAR(36) NOT NULL,
    address_id CHAR(36) NOT NULL,
    p_name VARCHAR(255) NOT NULL,
    p_description TEXT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    max_guests INT NOT NULL,
    bedrooms INT NOT NULL,
    bathrooms INT NOT NULL,
    property_type ENUM('apartment', 'house', 'condo', 'villa', 'cabin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES User(user_id),
    FOREIGN KEY (address_id) REFERENCES Address(address_id),
    INDEX (property_id)
);
```

### 3. **Booking Table Refactoring**

Remove the calculated field and add a separate pricing table:

```sql
-- BOOKING TABLE (Updated)
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY DEFAULT(uuid()),
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    num_guests INT NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled', 'completed') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    INDEX (booking_id),
    CHECK (start_date < end_date)
);

-- BOOKING_PRICE TABLE (New)
CREATE TABLE BookingPrice (
    booking_id CHAR(36) PRIMARY KEY,
    base_price DECIMAL(10,2) NOT NULL,
    service_fee DECIMAL(10,2) NOT NULL,
    taxes DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);
```

### 4. **User Role Normalization**

Create a separate table for user roles:

```sql
-- USER_ROLE TABLE
CREATE TABLE UserRole (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name ENUM('guest', 'host', 'admin') NOT NULL UNIQUE,
    role_description TEXT
);

-- USER TABLE (Updated)
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY DEFAULT(uuid()),
    role_id INT NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    date_of_birth DATE,
    profile_picture_url VARCHAR(500),
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES UserRole(role_id),
    INDEX (user_id)
);
```

### 5. **Additional Improvements**

#### Property Amenities
```sql
-- AMENITY TABLE
CREATE TABLE Amenity (
    amenity_id INT PRIMARY KEY AUTO_INCREMENT,
    amenity_name VARCHAR(100) NOT NULL UNIQUE,
    amenity_category ENUM('basic', 'luxury', 'safety', 'accessibility') NOT NULL
);

-- PROPERTY_AMENITY TABLE (Junction Table)
CREATE TABLE PropertyAmenity (
    property_id CHAR(36) NOT NULL,
    amenity_id INT NOT NULL,
    PRIMARY KEY (property_id, amenity_id),
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (amenity_id) REFERENCES Amenity(amenity_id)
);
```

#### Property Images
```sql
-- PROPERTY_IMAGE TABLE
CREATE TABLE PropertyImage (
    image_id CHAR(36) PRIMARY KEY DEFAULT(uuid()),
    property_id CHAR(36) NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    image_type ENUM('main', 'interior', 'exterior', 'amenity') NOT NULL,
    display_order INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    INDEX (property_id, display_order)
);
```

## Normalization Benefits

### 1. **First Normal Form (1NF)**
- ✅ All tables already satisfy 1NF
- ✅ No repeating groups or arrays
- ✅ All attributes are atomic

### 2. **Second Normal Form (2NF)**
- ✅ All tables already satisfy 2NF
- ✅ No partial dependencies on composite keys
- ✅ All non-key attributes depend on the entire primary key

### 3. **Third Normal Form (3NF)**
After implementing the suggested changes:
- ✅ No transitive dependencies
- ✅ Address information is properly normalized
- ✅ Calculated fields are removed
- ✅ User roles are separated

### 4. **Additional Benefits**
- **Data Integrity**: Better referential integrity with proper foreign keys
- **Flexibility**: Easier to add new features (amenities, property types, etc.)
- **Performance**: Better indexing opportunities
- **Maintainability**: Cleaner, more organized structure
- **Scalability**: Easier to extend the system

## Implementation Steps

1. **Create new tables** for Country, State, City, Address, UserRole, Amenity, etc.
2. **Migrate existing data** to the new structure
3. **Update foreign key references** in existing tables
4. **Remove calculated fields** and implement them in application logic
5. **Add appropriate indexes** for performance
6. **Update application code** to work with the new schema

## Conclusion

The current schema is well-designed but can be improved to achieve full 3NF compliance. The main improvements focus on:

1. **Address normalization** for better location management
2. **Removal of calculated fields** to eliminate transitive dependencies
3. **Separation of concerns** (user roles, amenities, images)
4. **Enhanced data integrity** through proper normalization

These changes will result in a more maintainable, scalable, and efficient database design while preserving all existing functionality.
