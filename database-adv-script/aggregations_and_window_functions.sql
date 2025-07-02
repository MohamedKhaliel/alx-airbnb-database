use alx_airbnb;
SELECT user_id , COUNT(*) FROM booking GROUP BY user_id;
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