use alx_airbnb;
select first_name , last_name , booking_id from user as u inner join booking as o ON u.user_id = o.user_id;
select p_name , r_comment from property as p left join review as r on p.property_id = r.property_id ;
SELECT u.first_name, u.last_name, o.booking_id
FROM user u
LEFT JOIN booking o ON u.user_id = o.user_id
UNION
SELECT u.first_name, u.last_name, o.booking_id
FROM user u
RIGHT JOIN booking o ON u.user_id = o.user_id;