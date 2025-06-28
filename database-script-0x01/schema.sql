use alx_airbnb;

-- USER TABLE
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY default(uuid()),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    user_role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX (user_id)
);

-- PROPERTY TABLE
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY default(uuid()),
    host_id CHAR(36),
    p_name VARCHAR(255) NOT NULL,
    p_description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES User(user_id),
    INDEX (property_id)
);

-- BOOKING TABLE
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
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    INDEX (booking_id)
);

-- PAYMENT TABLE
CREATE TABLE Payment (
    payment_id CHAR(36) PRIMARY KEY default(uuid()),
    booking_id CHAR(36),
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id),
    INDEX (payment_id)
);

-- REVIEW TABLE
CREATE TABLE Review (
    review_id CHAR(36) PRIMARY KEY default(uuid()),
    property_id CHAR(36),
    user_id CHAR(36),
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    r_comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    INDEX (review_id)
);

-- MESSAGE TABLE
CREATE TABLE Message (
    message_id CHAR(36) PRIMARY KEY default(uuid()),
    sender_id CHAR(36),
    recipient_id CHAR(36),
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES User(user_id),
    FOREIGN KEY (recipient_id) REFERENCES User(user_id),
    INDEX (message_id)
);
