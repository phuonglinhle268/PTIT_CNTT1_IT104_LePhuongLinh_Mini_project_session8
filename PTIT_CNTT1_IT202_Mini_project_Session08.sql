create database mini_project_session08;
use mini_project_session08;

create table guests (
    guest_id int auto_increment primary key,
    guest_name varchar(100),
    phone varchar(20)
);

-- Bảng phòng
create table rooms (
    room_id int auto_increment primary key,
    room_type varchar(50),
    price_per_day decimal(10,0)
);

-- Bảng đặt phòng
create table bookings (
    booking_id int auto_increment primary key,
    guest_id int,
    room_id int,
    check_in date,
    check_out date,
    foreign key (guest_id) references guests(guest_id),
    foreign key (room_id) references rooms(room_id)
);

insert into guests (guest_name, phone) values
	('Nguyễn Văn An', '0901111111'),
	('Trần Thị Bình', '0902222222'),
	('Lê Văn Cường', '0903333333'),
	('Phạm Thị Dung', '0904444444'),
	('Hoàng Văn Em', '0905555555');

insert into rooms (room_type, price_per_day) values
	('Standard', 500000),
	('Standard', 500000),
	('Deluxe', 800000),
	('Deluxe', 800000),
	('VIP', 1500000),
	('VIP', 2000000);

insert bookings (guest_id, room_id, check_in, check_out) values
	(1, 1, '2024-01-10', '2024-01-12'), -- 2 ngày
	(1, 3, '2024-03-05', '2024-03-10'), -- 5 ngày
	(2, 2, '2024-02-01', '2024-02-03'), -- 2 ngày
	(2, 5, '2024-04-15', '2024-04-18'), -- 3 ngày
	(3, 4, '2023-12-20', '2023-12-25'), -- 5 ngày
	(3, 6, '2024-05-01', '2024-05-06'), -- 5 ngày
	(4, 1, '2024-06-10', '2024-06-11'); -- 1 ngày
    
-- PHẦN 1
-- Liệt kê tên khách và số điện thoại của tất cả khách hàng
select guest_name, phone from guests;
-- Liệt kê các loại phòng khác nhau trong khách sạn
select room_type from rooms;
-- Hiển thị loại phòng và giá thuê theo ngày, sắp xếp theo giá tăng dần
select 
	room_type,
    price_per_day
from rooms order by price asc;
-- Hiển thị các phòng có giá thuê lớn hơn 1.000.000
select * from rooms where price_per_day > 1000000;
-- Liệt kê các lần đặt phòng diễn ra trong năm 2024
select * from bookings where year(chec_in) = 2024;
-- Cho biết số lượng phòng của từng loại phòng
select 
	room_type,
    count(*) as room_each_type
from rooms group by room_type;

-- PHẦN 2
-- Hãy liệt kê danh sách các lần đặt phòng, Với mỗi lần đặt phòng, hãy hiển thị:
-- Tên khách hàng
-- Loại phòng đã đặt
-- Ngày nhận phòng (check_in)
select 
    gue.guest_name,
    r.room_type,
    b.check_in
from bookings b
join guests gue on b.guest_id = gue.guest_id
join rooms r on b.room_id = r.room_id;
    
-- Cho biết mỗi khách đã đặt phòng bao nhiêu lần
select
	gue.guest_name,
    count(b.booking_id) as total_bookings
from guests gue
left join bookings b on b.guest_id = gue.guest_id
group by gue.guest_id, gue.guest_name;

-- Tính doanh thu của mỗi phòng, với công thức: “Doanh thu = số ngày ở × giá thuê theo ngày”
select 
	b.booking_id,
	r.room_type,
    r.price_per_day,
    datediff(b.check_out, b.check_in) as stay_day,
    datediff(b.check_out, b.check_in) * r.price_per_day as revenue
from bookings b
join rooms r on b.room_id = r.room_id;
    
-- Hiển thị tổng doanh thu của từng loại phòng
select
	r.room_type,
    sum(datediff(check_out, check_in) * r.price_per_day) as total_revenue
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_type;

-- Tìm những khách đã đặt phòng từ 2 lần trở lên
select 
    gue.guest_name,
    count(b.booking_id) as total_booking
from guests gue
join bookings b on gue.guest_id = b.guest_id
group by gue.guest_id, gue.guest_name
having count(b.booking_id) >= 2;

-- Tìm loại phòng có số lượt đặt phòng nhiều nhất
select 
    r.room_type,
    count(b.booking_id) as booking_count
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_type
order by booking_count desc limit 1;
