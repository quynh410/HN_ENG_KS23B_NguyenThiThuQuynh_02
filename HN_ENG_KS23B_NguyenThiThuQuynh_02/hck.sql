create database hotel;
use hotel;
-- 2
create table tbl_customers(
	customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    phone varchar(100) not null unique,
    email varchar(100) not null unique,
    address varchar(255)
);

create table tbl_customer_info(
	customer_id int,
	membership_level enum('Standard', 'VIP', 'VVIP'),
    registration_date date,
    total_spent decimal(10,2),
    foreign key (customer_id) references tbl_customers(customer_id)
);

create table tbl_rooms (
	room_id int primary key auto_increment,
    room_number varchar(10) not null unique,
    room_type enum('Single', 'Double', 'Suite'),
    price_per_night decimal(10,2),
    status enum('Available', 'Booked', 'Maintenance')
);

create table tbl_bookings (
	booking_id int primary key auto_increment,
    check_in_date datetime,
    check_out_date datetime,
    customer_id int,
    room_id int,
    foreign key (room_id) references tbl_rooms (room_id),
    foreign key (customer_id) references tbl_customers (customer_id),
	status enum('Confirmed', 'Checked-in', 'Checked-out', 'Cancelled')
);

create table tbl_services(
	service_id int primary key auto_increment,
    service_name varchar(100) not null,
    price decimal(10,2)
);

create table tbl_booking_services (
	booking_service_id int primary key auto_increment,
    booking_id int ,
	service_id int,
    foreign key (booking_id) references tbl_bookings (booking_id),
    foreign key (service_id) references tbl_services (service_id),
    quantity int
);

alter table  tbl_customer_info add column  loyalty_points int;

alter table tbl_customers modify column phone varchar(15);

alter table tbl_customer_info drop column total_spent;

-- 3
insert into tbl_customers
values
(1,'Nguyễn văn A', '0932767326', 'anv@gamil.com','Hà Nội'),
(2,'Trần Thị B', '0992378636', 'btt@gamil.com','Hồ Chí Minh'),
(3,'Lê Văn C', '0932767365 ', 'clv@gamil.com','Đà Nẵng'),
(4,'Phạm Thị D', '0973265632 ', 'dpt@gamil.com','Hà Nội'),
(5,'Nguyễn Thị E', '0923865633', 'ent@gamil.com','Hồ Chí Minh');

--
insert into  tbl_customer_info (customer_id,membership_level,registration_date,total_spent)
values
(1,'VIP','2023-01-01',1500.00),
(2,'Standard','2023-02-15', 800.00 ),
(3,'VVIP','2023-03-10', 2000.00 ),
(4,'Standard','2023-04-05', 500.00 ),
(5,'VIP','2023-05-20', 1500.00 );

insert into  tbl_rooms 
values 
(101, 'A101', 'Single', 500.00, 'Available' ),
(102, 'B202', 'Double', 700.00, 'Maintenance' ),
(103, 'C301', 'Suite' ,1200.00, 'Available' ),
(104, 'D402', 'Double', 500.00, 'Booked' ),
(105, 'E501', 'Single', 800.00, 'Available' );

--
insert into tbl_bookings (booking_id,customer_id,room_id,check_in_date,check_out_date,status)
values
(1001, 1, 101, '2023-06-01', '2023-07-05','Confirmed' ),
(1002, 2, 102, '2023-06-10', NULL ,'Checked-in' ),
(1003, 3, 103, '2023-06-20', '2023-06-25','Cancelled' ),
(1004, 4, 104, NULL,'2023-06-15', 'Cancelled' ),
(1005, 5, 105, '2023-07-01', '2023-07-05','Confirmed' );

insert into tbl_services
values
(1, 'Ăn sáng', 100.00),
(2, 'Giặt ủi', 10.00),
(3, 'Dịch vụ phòng', 20.00),
(4, 'Thuê xe đạp',30.00),
(5, 'Massage', 100.00);

--
insert into tbl_booking_services (booking_service_id,booking_id,service_id,quantity)
values 
(1, 1001,1,2),
(2, 1002,2,2),
(3, 1003,3,1),
(4, 1004,2,1),
(5, 1005,1,2);

-- 4
SELECT room_id AS 'Mã phòng', 
       room_number AS 'Số phòng', 
       room_type AS 'Loại phòng', 
       price_per_night AS 'Giá mỗi đêm', 
       status AS 'Trạng thái'
FROM tbl_rooms;


-- 4b,
SELECT DISTINCT c.customer_name AS 'Tên khách hàng'
FROM tbl_customers c
JOIN tbl_bookings b ON c.customer_id = b.customer_id;


-- 5 
SELECT room_type AS 'Loại phòng', 
       COUNT(*) AS 'Số lượng phòng còn trống'
FROM tbl_rooms
WHERE status = 'Available'
GROUP BY room_type;


SELECT s.service_name AS 'Tên dịch vụ', 
       SUM(bs.quantity) AS 'Tổng số lần sử dụng'
FROM tbl_booking_services bs
JOIN tbl_services s ON bs.service_id = s.service_id
GROUP BY s.service_id
HAVING SUM(bs.quantity) > 0;



