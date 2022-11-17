-- Assumptions made:
-- =================
-- 1) date_registered and acc_reward_points (in Customer table) are computed and populated by application upon successful user registration.
-- 
-- 2) Billing table contains only completed transaction i.e. payment reference number (payment_ref_no) cannot be a NULL value.
--    * All fields are captured from the user interface when customer confirms the order.
--    * Meaning Billing table does not extract data directy from Shopping_Cart table.
--    * total_bill_value is added to Billing Table for ease of calcuation
--
-- 3) Shopping_Cart table contains all items that customer have yet to check-out:
--    * if customer doesn't have any items in their shopping cart, there will not be any entry for that client in Shopping_Cart table.
--    * Items will be removed once the shopping cart is checked-out i.e. no outstanding items left in shopping cart.
--    * Application will check whether there are any entries for that client in Shopping_Cart table. 
--    * If so, application will pre-populate information whenever client opens up his/her shopping cart.
--
-- 4) Customer_Preferred_Comm table is the resolving table for many to many relationship between Preferred_Comm table and Customer table:
--    * date_updated (together with his/her choices) will be updated whenever customer confirm his/her communication preference by clicking on "SUBMIT" button in the "Contact Preferences" interface.
--    * Application will querry the latest "date_updated" value to determine what is the user's choice.
--
-- 5) Coupon codes (i.e. CNY18, LABOUR10, OPEN_MTH, YULE15) are generic code, which can be used by any user. However, only 1 coupon can be used per order.
-- 
-- 6) customer_id, login_type, and login_datetime (in Login table) will be updated upon successful login:
--    * Application can querry when is the customer's last successful login to determine whether to populate customer's account details in Customer table.
-- ________________________________________________________________________________________________________________________________________________________


-- Summary Report shows the following:
-- 1) How many transactions has the client completed (i.e. payment transaction approved) in year 2022?
-- 2) When was the last transaction made by client?
-- 3) What is the total value of voucher purchased by the client
--
-- Summary Report is grouped by customer and order by total transaction value in descending order followed by customer's first name in ascending order.

SELECT C.first_name AS "Customer's First Name", 
	C. last_name AS "Customer's Last Name",
    B.customer_id AS "Customer ID", 
    count(B.billing_no) AS "Number of Transactions Made", 
    max(V.voucher_datetimestamp) AS "Latest Transaction Date & Time", 
    sum(V.voucher_value) AS "Total Voucher/Transaction Value"
FROM customer C
INNER JOIN billing B ON C.customer_id = B.customer_id
INNER JOIN billing_has_voucher BV ON B.billing_no = BV.billing_no
INNER JOIN voucher V ON BV.voucher_no = V.voucher_no
WHERE V.voucher_datetimestamp >= '2022-01-01 00:00:00'
GROUP BY 1
ORDER BY 6 DESC, 1;
-- ___________________________________________________________________________________________________________________


-- Assume daily list of orders refers to orders received today i.e. current date

SELECT DATE(V.voucher_datetimestamp) AS "Order Date",
    V.voucher_no AS "Voucher Number",
    V.voucher_type AS "Voucher Type",
    V.voucher_value AS "Voucher Value",
	C.first_name AS "Customer's First Name", 
	C. last_name AS "Customer's Last Name",
    C.email AS "Customer's Email",
    B.billing_no AS "Order Number",
    V.recipient_email AS "Recipient's Email"
FROM customer C
INNER JOIN billing B ON C.customer_id = B.customer_id
INNER JOIN billing_has_voucher BV ON B.billing_no = BV.billing_no
INNER JOIN voucher V ON BV.voucher_no = V.voucher_no
WHERE DATE(V.voucher_datetimestamp) = CURDATE()
ORDER BY 3,4;





