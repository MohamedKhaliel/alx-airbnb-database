use alx_airbnb;
SELECT booking_id FROM booking GROUP BY user_id HAVING count(user_id) > 3 ;
SELECT p_name FROM property WHERE property_id in(SELECT property_id FROM review  GROUP BY property_id HAVING AVG(rating) > 4.0);
SELECT first_name,last_name , user_id FROM user WHERE ( SELECT COUNT(*) FROM booking as b WHERE user_id = b.user_id ) > 3;