use alx_airbnb;

-- =====================================================
-- SAMPLE DATA FOR AIRBNB CLONE DATABASE
-- =====================================================

-- =====================================================
-- USER TABLE - Sample Users (Hosts, Guests, and Admins)
-- =====================================================

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, user_role, created_at) VALUES
-- Hosts
('550e8400-e29b-41d4-a716-446655440001', 'Sarah', 'Johnson', 'sarah.johnson@email.com', '$2b$10$hashedpassword123', '+1-555-0101', 'host', '2023-01-15 10:30:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Michael', 'Chen', 'michael.chen@email.com', '$2b$10$hashedpassword456', '+1-555-0102', 'host', '2023-02-20 14:15:00'),
('550e8400-e29b-41d4-a716-446655440003', 'Emily', 'Rodriguez', 'emily.rodriguez@email.com', '$2b$10$hashedpassword789', '+1-555-0103', 'host', '2023-03-10 09:45:00'),
('550e8400-e29b-41d4-a716-446655440004', 'David', 'Thompson', 'david.thompson@email.com', '$2b$10$hashedpassword101', '+1-555-0104', 'host', '2023-04-05 16:20:00'),
('550e8400-e29b-41d4-a716-446655440005', 'Lisa', 'Wang', 'lisa.wang@email.com', '$2b$10$hashedpassword112', '+1-555-0105', 'host', '2023-05-12 11:30:00'),

-- Guests
('550e8400-e29b-41d4-a716-446655440006', 'John', 'Smith', 'john.smith@email.com', '$2b$10$hashedpassword131', '+1-555-0106', 'guest', '2023-01-20 08:15:00'),
('550e8400-e29b-41d4-a716-446655440007', 'Maria', 'Garcia', 'maria.garcia@email.com', '$2b$10$hashedpassword415', '+1-555-0107', 'guest', '2023-02-25 13:45:00'),
('550e8400-e29b-41d4-a716-446655440008', 'James', 'Wilson', 'james.wilson@email.com', '$2b$10$hashedpassword161', '+1-555-0108', 'guest', '2023-03-15 10:20:00'),
('550e8400-e29b-41d4-a716-446655440009', 'Jennifer', 'Brown', 'jennifer.brown@email.com', '$2b$10$hashedpassword718', '+1-555-0109', 'guest', '2023-04-10 15:30:00'),
('550e8400-e29b-41d4-a716-446655440010', 'Robert', 'Davis', 'robert.davis@email.com', '$2b$10$hashedpassword192', '+1-555-0110', 'guest', '2023-05-18 12:00:00'),
('550e8400-e29b-41d4-a716-446655440011', 'Amanda', 'Miller', 'amanda.miller@email.com', '$2b$10$hashedpassword202', '+1-555-0111', 'guest', '2023-06-01 09:15:00'),
('550e8400-e29b-41d4-a716-446655440012', 'Christopher', 'Taylor', 'christopher.taylor@email.com', '$2b$10$hashedpassword212', '+1-555-0112', 'guest', '2023-06-10 14:45:00'),

-- Admins
('550e8400-e29b-41d4-a716-446655440013', 'Admin', 'User', 'admin@airbnb-clone.com', '$2b$10$adminhashedpass', '+1-555-0001', 'admin', '2023-01-01 00:00:00');

-- =====================================================
-- PROPERTY TABLE - Sample Properties
-- =====================================================

INSERT INTO Property (property_id, host_id, p_name, p_description, location, price_per_night, created_at, updated_at) VALUES
-- Sarah's Properties
('660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Cozy Downtown Apartment', 'Modern 1-bedroom apartment in the heart of downtown. Walking distance to restaurants, shops, and public transportation. Fully equipped kitchen and comfortable living space.', 'San Francisco, CA', 150.00, '2023-01-20 10:00:00', '2023-01-20 10:00:00'),
('660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Ocean View Beach House', 'Stunning 3-bedroom beach house with panoramic ocean views. Private beach access, large deck, and fully equipped kitchen. Perfect for family vacations.', 'Malibu, CA', 350.00, '2023-02-15 14:30:00', '2023-02-15 14:30:00'),

-- Michael's Properties
('660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Luxury Penthouse Suite', 'Exclusive penthouse with city skyline views. 2 bedrooms, 2 bathrooms, gourmet kitchen, and private balcony. Access to building amenities including pool and gym.', 'New York, NY', 500.00, '2023-02-25 11:15:00', '2023-02-25 11:15:00'),
('660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Mountain Cabin Retreat', 'Rustic 2-bedroom cabin surrounded by pine trees. Wood-burning fireplace, hot tub, and hiking trails nearby. Perfect for nature lovers.', 'Aspen, CO', 200.00, '2023-03-05 16:45:00', '2023-03-05 16:45:00'),

-- Emily's Properties
('660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Historic Townhouse', 'Beautifully restored 19th-century townhouse. 3 bedrooms, original hardwood floors, and period details. Located in a charming historic district.', 'Boston, MA', 280.00, '2023-03-15 09:30:00', '2023-03-15 09:30:00'),
('660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'Modern Studio Loft', 'Contemporary studio loft with high ceilings and industrial design. Open floor plan, full kitchen, and rooftop access. Ideal for solo travelers or couples.', 'Austin, TX', 120.00, '2023-04-01 13:20:00', '2023-04-01 13:20:00'),

-- David's Properties
('660e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440004', 'Lakeside Cottage', 'Charming 2-bedroom cottage on the lake. Private dock, fishing gear included, and stunning sunset views. Perfect for a peaceful getaway.', 'Lake Tahoe, CA', 180.00, '2023-04-10 15:00:00', '2023-04-10 15:00:00'),
('660e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440004', 'Urban Garden Apartment', 'Spacious 1-bedroom apartment with private garden. Modern amenities, bike storage, and close to public transportation. Pet-friendly.', 'Portland, OR', 140.00, '2023-05-01 10:45:00', '2023-05-01 10:45:00'),

-- Lisa's Properties
('660e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440005', 'Desert Villa', 'Luxurious 4-bedroom villa with private pool and mountain views. Gourmet kitchen, outdoor dining area, and stargazing deck. Perfect for large groups.', 'Palm Springs, CA', 400.00, '2023-05-15 12:30:00', '2023-05-15 12:30:00'),
('660e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440005', 'Coastal Bungalow', 'Charming 2-bedroom bungalow steps from the beach. Ocean views, outdoor shower, and beach equipment included. Family-friendly location.', 'Santa Barbara, CA', 220.00, '2023-06-01 08:15:00', '2023-06-01 08:15:00');

-- =====================================================
-- BOOKING TABLE - Sample Bookings
-- =====================================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- Confirmed Bookings
('770e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', '2023-07-01', '2023-07-05', 600.00, 'confirmed', '2023-06-15 10:30:00'),
('770e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440007', '2023-07-10', '2023-07-15', 2500.00, 'confirmed', '2023-06-20 14:15:00'),
('770e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440008', '2023-07-20', '2023-07-25', 1400.00, 'confirmed', '2023-06-25 09:45:00'),
('770e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440009', '2023-08-01', '2023-08-07', 1080.00, 'confirmed', '2023-07-01 16:20:00'),
('770e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440010', '2023-08-15', '2023-08-22', 2800.00, 'confirmed', '2023-07-10 11:30:00'),

-- Pending Bookings
('770e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440011', '2023-09-01', '2023-09-05', 1400.00, 'pending', '2023-07-15 13:45:00'),
('770e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440012', '2023-09-10', '2023-09-12', 400.00, 'pending', '2023-07-20 10:15:00'),
('770e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440006', '2023-09-15', '2023-09-18', 360.00, 'pending', '2023-07-25 15:30:00'),

-- Canceled Bookings
('770e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440007', '2023-08-05', '2023-08-08', 420.00, 'canceled', '2023-07-05 12:00:00'),
('770e8400-e29b-41d4-a716-446655440010', '660e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440008', '2023-08-20', '2023-08-25', 1100.00, 'canceled', '2023-07-12 14:20:00');

-- =====================================================
-- PAYMENT TABLE - Sample Payments
-- =====================================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
-- Payments for Confirmed Bookings
('880e8400-e29b-41d4-a716-446655440001', '770e8400-e29b-41d4-a716-446655440001', 600.00, '2023-06-15 10:35:00', 'credit_card'),
('880e8400-e29b-41d4-a716-446655440002', '770e8400-e29b-41d4-a716-446655440002', 2500.00, '2023-06-20 14:20:00', 'stripe'),
('880e8400-e29b-41d4-a716-446655440003', '770e8400-e29b-41d4-a716-446655440003', 1400.00, '2023-06-25 09:50:00', 'paypal'),
('880e8400-e29b-41d4-a716-446655440004', '770e8400-e29b-41d4-a716-446655440004', 1080.00, '2023-07-01 16:25:00', 'credit_card'),
('880e8400-e29b-41d4-a716-446655440005', '770e8400-e29b-41d4-a716-446655440005', 2800.00, '2023-07-10 11:35:00', 'stripe'),

-- Partial Payments for Pending Bookings
('880e8400-e29b-41d4-a716-446655440006', '770e8400-e29b-41d4-a716-446655440006', 700.00, '2023-07-15 13:50:00', 'credit_card'),
('880e8400-e29b-41d4-a716-446655440007', '770e8400-e29b-41d4-a716-446655440007', 200.00, '2023-07-20 10:20:00', 'paypal'),

-- Refunded Payments for Canceled Bookings
('880e8400-e29b-41d4-a716-446655440008', '770e8400-e29b-41d4-a716-446655440009', 420.00, '2023-07-05 12:05:00', 'credit_card'),
('880e8400-e29b-41d4-a716-446655440009', '770e8400-e29b-41d4-a716-446655440010', 1100.00, '2023-07-12 14:25:00', 'stripe');

-- =====================================================
-- REVIEW TABLE - Sample Reviews
-- =====================================================

INSERT INTO Review (review_id, property_id, user_id, rating, r_comment, created_at) VALUES
-- Positive Reviews
('990e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', 5, 'Amazing apartment in a perfect location! The place was spotless and had everything we needed. Sarah was a fantastic host who responded quickly to all our questions. Highly recommend!', '2023-07-06 14:30:00'),
('990e8400-e29b-41d4-a716-446655440002', '660e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440007', 5, 'Absolutely stunning penthouse! The views were incredible and the amenities were top-notch. Michael was very accommodating and the check-in process was seamless.', '2023-07-16 16:45:00'),
('990e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440008', 4, 'Beautiful historic townhouse with lots of character. The location was perfect for exploring Boston. Emily was a great host and provided excellent recommendations for local restaurants.', '2023-07-26 11:20:00'),
('990e8400-e29b-41d4-a716-446655440004', '660e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440009', 5, 'Perfect lakeside getaway! The cottage was cozy and the lake views were breathtaking. David was very helpful and the fishing equipment was a nice bonus.', '2023-08-08 09:15:00'),
('990e8400-e29b-41d4-a716-446655440005', '660e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440010', 5, 'Luxury villa exceeded all expectations! The pool was perfect and the mountain views were spectacular. Lisa was an excellent host who thought of every detail.', '2023-08-23 13:40:00'),

-- Mixed Reviews
('990e8400-e29b-41d4-a716-446655440006', '660e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440011', 4, 'Beautiful beach house with amazing ocean views. The location was perfect and the house was well-equipped. Only minor issue was the WiFi was a bit slow.', '2023-08-10 15:30:00'),
('990e8400-e29b-41d4-a716-446655440007', '660e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440012', 3, 'Nice cabin in a beautiful location. The hot tub was great and the hiking trails were amazing. However, the kitchen could use some updates and the road access was a bit rough.', '2023-08-15 12:45:00'),

-- Critical Reviews
('990e8400-e29b-41d4-a716-446655440008', '660e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440006', 2, 'The loft was smaller than expected and the rooftop access was not available during our stay. The location was good but the value for money was disappointing.', '2023-08-20 10:10:00'),
('990e8400-e29b-41d4-a716-446655440009', '660e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440007', 1, 'Very disappointed with this apartment. The garden was not maintained and the apartment was not clean when we arrived. The host was unresponsive to our concerns.', '2023-08-25 14:20:00');

-- =====================================================
-- MESSAGE TABLE - Sample Messages
-- =====================================================

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Guest to Host Messages
('aa0e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440001', 'Hi Sarah! I\'m interested in your downtown apartment. What time is check-in and check-out?', '2023-06-10 09:30:00'),
('aa0e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', 'Hi John! Check-in is at 3 PM and check-out is at 11 AM. I can be flexible if needed. Let me know if you have any other questions!', '2023-06-10 10:15:00'),
('aa0e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440002', 'Hello Michael! Is parking available at your penthouse? We\'ll be driving from the airport.', '2023-06-15 14:20:00'),
('aa0e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440007', 'Hi Maria! Yes, there\'s a parking garage in the building. I\'ll send you the access code before your arrival.', '2023-06-15 15:00:00'),

-- Host to Guest Messages
('aa0e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440008', 'Hi James! Welcome to Boston! I\'ve left some local restaurant recommendations in the welcome book. Enjoy your stay!', '2023-07-20 16:30:00'),
('aa0e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440009', 'Hello Jennifer! The weather is perfect for fishing this week. I\'ve stocked the cottage with some basic supplies. Have a great time!', '2023-08-01 11:45:00'),

-- Guest to Guest Messages (friends traveling together)
('aa0e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440011', 'Hey Amanda! Are you still planning to join us for the Palm Springs trip? The villa looks amazing!', '2023-07-25 13:20:00'),
('aa0e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440010', 'Yes! I\'m so excited! I just booked my flight. Can\'t wait to see you there!', '2023-07-25 14:05:00'),

-- Support Messages
('aa0e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440006', 'Hi John! We noticed you had a great stay with Sarah. Would you like to leave a review?', '2023-07-05 10:00:00'),
('aa0e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440013', '550e8400-e29b-41d4-a716-446655440007', 'Hello Maria! Thank you for choosing our platform. How was your experience with Michael\'s penthouse?', '2023-07-15 16:00:00'),

-- Follow-up Messages
('aa0e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440006', 'Hi John! I hope you enjoyed your stay. Please let me know if you need anything else!', '2023-07-06 12:30:00'),
('aa0e8400-e29b-41d4-a716-446655440012', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440007', 'Maria, thank you for being such a great guest! You\'re welcome back anytime.', '2023-07-16 09:15:00');

-- =====================================================
-- SAMPLE DATA SUMMARY
-- =====================================================
/*
This seed file contains realistic sample data for the Airbnb clone database:

USERS: 13 total (5 hosts, 7 guests, 1 admin)
PROPERTIES: 10 properties across different locations and types
BOOKINGS: 10 bookings (5 confirmed, 3 pending, 2 canceled)
PAYMENTS: 9 payments (5 full, 2 partial, 2 refunded)
REVIEWS: 9 reviews with varying ratings (1-5 stars)
MESSAGES: 12 messages between users and hosts

The data includes:
- Realistic names, locations, and property descriptions
- Varied booking statuses and payment methods
- Authentic review content with different ratings
- Natural conversation flow in messages
- Proper foreign key relationships maintained
- Timestamps that create a logical timeline

This provides a good foundation for testing the application functionality.
*/ 