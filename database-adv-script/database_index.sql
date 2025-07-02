USE alx_airbnb ;
CREATE INDEX primary_idx ON user(user_id);
CREATE INDEX booking_idx ON booking(booking_id);
CREATE INDEX primary_idx ON property(property_id);

EXPLAIN ANALYZE
SELECT 
    p.p_name,
    COUNT(b.booking_id) AS booking_count,
    RANK() OVER (PARTITION BY p.p_name ORDER BY COUNT(b.booking_id) ASC) AS rank_in_name
FROM 
    property p
LEFT JOIN 
    booking b ON p.property_id = b.property_id
GROUP BY 
    p.p_name;