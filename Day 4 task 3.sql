use krgcamp;
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    user_id INT,
    submit_date DATE,
    restaurant_id INT,
    rating INT
);

INSERT INTO reviews (review_id, user_id, submit_date, restaurant_id, rating)
VALUES 
(1001, 501, '2022-01-15', 101, 4),
(1002, 502, '2022-01-20', 101, 5),
(1003, 503, '2022-01-25', 102, 3),
(1004, 504, '2022-01-15', 102, 4),
(1005, 505, '2022-02-20', 101, 5),
(1006, 506, '2022-02-26', 101, 4),
(1007, 507, '2022-03-01', 101, 4),
(1008, 508, '2022-03-05', 102, 2);

Select month,restaurant_id,avg_rating
from 
(select month(submit_date)as month,restaurant_id,avg(rating) as avg_rating,count(*) as cnt from reviews 
group by restaurant_id, month) as a
where cnt>=2
order by restaurant_id;
   
