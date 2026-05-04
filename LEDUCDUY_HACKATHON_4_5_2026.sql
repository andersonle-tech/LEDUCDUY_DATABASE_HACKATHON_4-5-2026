-- MÃ ĐỀ 002
CREATE DATABASE IF NOT EXISTS QuanLyRapPhim_002;
USE QuanLyRapPhim_002;

--  Bảng Movies 
CREATE TABLE Movies (
    movie_id VARCHAR(5) PRIMARY KEY,
    title VARCHAR(150) NOT NULL UNIQUE,
    genre VARCHAR(50) NOT NULL,
    duration INT NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL -- DEFAULT 'Coming Soon',
    -- release_year INT,
   --  CONSTRAINT chk_movies_duration CHECK (duration > 0),
    -- CHECK constraint xem status trong khoảng 3 giá trị ko?
    CONSTRAINT chk_movies_status CHECK (status IN ('Showing', 'Coming Soon', 'Ended')) 
);

-- Bảng Customers 
CREATE TABLE Customers (
    customer_id VARCHAR(5) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL,
    customer_type VARCHAR(50) NOT NULL,
    -- Check constraint customer_type nằm trong khoảng 3 giá trị k
    CONSTRAINT chk_customer_type CHECK (customer_type IN ('Standard', 'VIP', 'Student'))
);

-- Bảng Bookings 
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id VARCHAR(5) NOT NULL,
    customer_id VARCHAR(5) NOT NULL,
    booking_date DATE NOT NULL,
    seat_number VARCHAR(10),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- Bảng Payments 
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    -- Check constraint payment_method nằm trong khoảng 3 giá trị ko?
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Thẻ', 'Ví điện tử', 'Tiền mặt'))
);
-- Thêm ràng buộc
ALTER TABLE Movies
ADD COLUMN release_year INT,
ALTER COLUMN status SET DEFAULT 'Coming Soon',
ADD CONSTRAINT chk_duration_positive CHECK (duration > 0);
-- Insert Data Movies
INSERT INTO Movies (movie_id, title, genre, duration, ticket_price, status, release_year) VALUES
('V01', 'Lật Mặt 7', 'Gia đình', 138, 100000.00, 'Showing', 2024),
('V02', 'Dune 2', 'Hành động', 166, 120000.00, 'Ended', 2024),
('V03', 'Conan 27', 'Hoạt hình', 110, 90000.00, 'Showing', 2024),
('V04', 'Mai', 'Tâm lý', 131, 100000.00, 'Ended', 2024),
('V05', 'Joker 2', 'Tâm lý', 138, 150000.00, 'Showing', 2024);

-- Insert Data Customers
INSERT INTO Customers (customer_id, full_name, email, phone, customer_type) VALUES
('C01', 'Phạm Minh Tuấn', 'tuan.pm@gmail.com', '0912223344', 'VIP'),
('C02', 'Nguyễn Thu Thủy', 'thuy.nt@gmail.com', '0987778899', 'Standard'),
('C03', 'Trần Trung Kiên', 'kien.tt@gmail.com', '0944556677', 'Student'),
('C04', 'Hoàng Bảo Yến', 'yen.hb@gmail.com', '0966112233', 'Standard'),
('C05', 'Ngô Quang Huy', 'huy.nq@gmail.com', '0977889900', 'VIP');

-- Insert Data Bookings
INSERT INTO Bookings (booking_id, movie_id, customer_id, booking_date, seat_number) VALUES
(1, 'V01', 'C01', '2025-11-10', 'A12'),
(2, 'V03', 'C03', '2025-11-12', 'B05'),
(3, 'V05', 'C05', '2025-11-15', 'F01'),
(4, 'V01', 'C02', '2025-12-01', 'A13'),
(5, 'V03', 'C01', '2025-12-05', 'C10'),
(6, 'V05', 'C04', '2025-12-10', 'G08');

-- Insert Data Payments
INSERT INTO Payments (payment_id, booking_id, amount, payment_method) VALUES
(1, 1, 100000.00, 'Ví điện tử'),
(2, 2, 90000.00, 'Tiền mặt'),
(3, 3, 150000.00, 'Thẻ');
-- Cập nhật / Sửa / Xoá
-- 1. Cập nhật customer_type của khách hàng 'C02' thành 'VIP'
UPDATE Customers 
SET customer_type = 'VIP' 
WHERE customer_id = 'C02';

-- 2. Giảm giá vé (ticket_price) đi 5% cho các phim thuộc thể loại 'Tâm lý'
UPDATE Movies 
SET ticket_price = ticket_price * 0.95 
WHERE genre = 'Tâm lý';

-- 3. Xóa các thanh toán (Payments) có số tiền nhỏ hơn 100,000
DELETE FROM Payments 
WHERE amount < 100000;

-- 4. Cập nhật status của các phim sản xuất trước năm 2024 thành 'Ended'
UPDATE Movies 
SET status = 'Ended' 
WHERE release_year < 2024;

-- 5. Cập nhật seat_number thành 'S00' cho khách 'C01' mượn (đặt) trong tháng 11/2025 mà chưa có số ghế
UPDATE Bookings 
SET seat_number = 'S00' 
WHERE customer_id = 'C01' 
  AND MONTH(booking_date) = 11 
  AND YEAR(booking_date) = 2025 
  AND (seat_number IS NULL OR seat_number = '');
# TRUY VẤN
#CƠ BẢN
-- Liệt kê phim có giá vé từ 80,000 đến 120,000.
SELECT * 
FROM Movies 
WHERE ticket_price BETWEEN 80000 AND 120000;

-- Lấy full_name, email của khách hàng họ 'Nguyễn'.
SELECT full_name, email 
FROM Customers 
WHERE full_name LIKE 'Nguyễn %';

-- Hiển thị title, genre, sắp xếp theo duration giảm dần.
SELECT title, genre 
FROM Movies 
ORDER BY duration DESC;

-- Lấy ra 3 bộ phim mới nhất (theo release_year).
SELECT * 
FROM Movies 
ORDER BY release_year DESC 
LIMIT 3;

-- Hiển thị đơn đặt vé diễn ra trong tháng 11/2025.
SELECT * 
FROM Bookings 
WHERE MONTH(booking_date) = 11 AND YEAR(booking_date) = 2025;

-- Tìm phim có tên bắt đầu bằng 'L' hoặc kết thúc bằng 'i'.
SELECT * 
FROM Movies 
WHERE title LIKE 'L%' OR title LIKE '%i';

-- Lấy đơn đặt vé từ ngày '2025-11-01' đến '2025-12-15'.
SELECT * 
FROM Bookings 
WHERE booking_date BETWEEN '2025-11-01' AND '2025-12-15';

-- Sắp xếp danh sách khách hàng theo tên (A-Z).
SELECT * 
FROM Customers 
ORDER BY full_name ASC;

#NÂNG CAO
-- Hiển thị thông tin đặt vé của khách hàng loại 'VIP'.
SELECT b.*, c.full_name, c.customer_type
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
WHERE c.customer_type = 'VIP';

-- Thống kê mỗi thể loại có bao nhiêu bộ phim.
SELECT genre, COUNT(*) AS total_movies 
FROM Movies 
GROUP BY genre;

-- Liệt kê khách hàng và tổng số lần đặt vé (hiển thị cả người chưa đặt).
SELECT c.customer_id, c.full_name, COUNT(b.booking_id) AS total_bookings
FROM Customers c
LEFT JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.full_name;

-- Tìm các bộ phim chưa từng được đặt vé.
SELECT m.* 
FROM Movies m
LEFT JOIN Bookings b ON m.movie_id = b.movie_id
WHERE b.booking_id IS NULL;

-- Tính tổng số tiền mỗi khách đã thanh toán.
SELECT c.customer_id, c.full_name, COALESCE(SUM(p.amount), 0) AS total_paid
FROM Customers c
LEFT JOIN Bookings b ON c.customer_id = b.customer_id
LEFT JOIN Payments p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.full_name;

-- Hiển thị tên khách đã đặt trên 2 bộ phim khác nhau.
SELECT c.full_name
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(DISTINCT b.movie_id) > 2;

-- Tìm khách đã đặt phim có giá vé cao nhất.
SELECT DISTINCT c.*
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
JOIN Movies m ON b.movie_id = m.movie_id
WHERE m.ticket_price = (SELECT MAX(ticket_price) FROM Movies);

-- Liệt kê phim 'Hành động' đã được đặt vé ít nhất 1 lần.
SELECT DISTINCT m.*
FROM Movies m
JOIN Bookings b ON m.movie_id = b.movie_id
WHERE m.genre = 'Hành động';('V04', 'Mai', 'Tâm lý', 131, 100000.00, 'Ended', 2024),
('V05', 'Joker 2', 'Tâm lý', 138, 150000.00, 'Showing', 2024);

-- Insert Data Customers
INSERT INTO Customers (customer_id, full_name, email, phone, customer_type) VALUES
('C01', 'Phạm Minh Tuấn', 'tuan.pm@gmail.com', '0912223344', 'VIP'),
('C02', 'Nguyễn Thu Thủy', 'thuy.nt@gmail.com', '0987778899', 'Standard'),
('C03', 'Trần Trung Kiên', 'kien.tt@gmail.com', '0944556677', 'Student'),
('C04', 'Hoàng Bảo Yến', 'yen.hb@gmail.com', '0966112233', 'Standard'),
('C05', 'Ngô Quang Huy', 'huy.nq@gmail.com', '0977889900', 'VIP');

-- Insert Data Bookings
INSERT INTO Bookings (booking_id, movie_id, customer_id, booking_date, seat_number) VALUES
(1, 'V01', 'C01', '2025-11-10', 'A12'),
(2, 'V03', 'C03', '2025-11-12', 'B05'),
(3, 'V05', 'C05', '2025-11-15', 'F01'),
(4, 'V01', 'C02', '2025-12-01', 'A13'),
(5, 'V03', 'C01', '2025-12-05', 'C10'),
(6, 'V05', 'C04', '2025-12-10', 'G08');

-- Insert Data Payments
INSERT INTO Payments (payment_id, booking_id, amount, payment_method) VALUES
(1, 1, 100000.00, 'Ví điện tử'),
(2, 2, 90000.00, 'Tiền mặt'),
(3, 3, 150000.00, 'Thẻ');
-- Cập nhật / Sửa / Xoá
-- 1. Cập nhật customer_type của khách hàng 'C02' thành 'VIP'
UPDATE Customers 
SET customer_type = 'VIP' 
WHERE customer_id = 'C02';

-- 2. Giảm giá vé (ticket_price) đi 5% cho các phim thuộc thể loại 'Tâm lý'
UPDATE Movies 
SET ticket_price = ticket_price * 0.95 
WHERE genre = 'Tâm lý';

-- 3. Xóa các thanh toán (Payments) có số tiền nhỏ hơn 100,000
DELETE FROM Payments 
WHERE amount < 100000;

-- 4. Cập nhật status của các phim sản xuất trước năm 2024 thành 'Ended'
UPDATE Movies 
SET status = 'Ended' 
WHERE release_year < 2024;

-- 5. Cập nhật seat_number thành 'S00' cho khách 'C01' mượn (đặt) trong tháng 11/2025 mà chưa có số ghế
UPDATE Bookings 
SET seat_number = 'S00' 
WHERE customer_id = 'C01' 
  AND MONTH(booking_date) = 11 
  AND YEAR(booking_date) = 2025 
  AND (seat_number IS NULL OR seat_number = '');
# TRUY VẤN
#CƠ BẢN
-- Liệt kê phim có giá vé từ 80,000 đến 120,000.
SELECT * 
FROM Movies 
WHERE ticket_price BETWEEN 80000 AND 120000;

-- Lấy full_name, email của khách hàng họ 'Nguyễn'.
SELECT full_name, email 
FROM Customers 
WHERE full_name LIKE 'Nguyễn %';

-- Hiển thị title, genre, sắp xếp theo duration giảm dần.
SELECT title, genre 
FROM Movies 
ORDER BY duration DESC;

-- Lấy ra 3 bộ phim mới nhất (theo release_year).
SELECT * 
FROM Movies 
ORDER BY release_year DESC 
LIMIT 3;

-- Hiển thị đơn đặt vé diễn ra trong tháng 11/2025.
SELECT * 
FROM Bookings 
WHERE MONTH(booking_date) = 11 AND YEAR(booking_date) = 2025;

-- Tìm phim có tên bắt đầu bằng 'L' hoặc kết thúc bằng 'i'.
SELECT * 
FROM Movies 
WHERE title LIKE 'L%' OR title LIKE '%i';

-- Lấy đơn đặt vé từ ngày '2025-11-01' đến '2025-12-15'.
SELECT * 
FROM Bookings 
WHERE booking_date BETWEEN '2025-11-01' AND '2025-12-15';

-- Sắp xếp danh sách khách hàng theo tên (A-Z).
SELECT * 
FROM Customers 
ORDER BY full_name ASC;

#NÂNG CAO
-- Hiển thị thông tin đặt vé của khách hàng loại 'VIP'.
SELECT b.*, c.full_name, c.customer_type
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
WHERE c.customer_type = 'VIP';

-- Thống kê mỗi thể loại có bao nhiêu bộ phim.
SELECT genre, COUNT(*) AS total_movies 
FROM Movies 
GROUP BY genre;

-- Liệt kê khách hàng và tổng số lần đặt vé (hiển thị cả người chưa đặt).
SELECT c.customer_id, c.full_name, COUNT(b.booking_id) AS total_bookings
FROM Customers c
LEFT JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.full_name;

-- Tìm các bộ phim chưa từng được đặt vé.
SELECT m.* 
FROM Movies m
LEFT JOIN Bookings b ON m.movie_id = b.movie_id
WHERE b.booking_id IS NULL;

-- Tính tổng số tiền mỗi khách đã thanh toán.
SELECT c.customer_id, c.full_name, COALESCE(SUM(p.amount), 0) AS total_paid
FROM Customers c
LEFT JOIN Bookings b ON c.customer_id = b.customer_id
LEFT JOIN Payments p ON b.booking_id = p.booking_id
GROUP BY c.customer_id, c.full_name;

-- Hiển thị tên khách đã đặt trên 2 bộ phim khác nhau.
SELECT c.full_name
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(DISTINCT b.movie_id) > 2;

-- Tìm khách đã đặt phim có giá vé cao nhất.
SELECT DISTINCT c.*
FROM Customers c
JOIN Bookings b ON c.customer_id = b.customer_id
JOIN Movies m ON b.movie_id = m.movie_id
WHERE m.ticket_price = (SELECT MAX(ticket_price) FROM Movies);

-- Liệt kê phim 'Hành động' đã được đặt vé ít nhất 1 lần.
SELECT DISTINCT m.*
FROM Movies m
JOIN Bookings b ON m.movie_id = b.movie_id
WHERE m.genre = 'Hành động';
