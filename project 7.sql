create database library_demo;

use library_demo;

create table readers( reader_id varchar(6),
fname varchar(30),
mname varchar(30),
ltname varchar(30),
city varchar(15),
mobileno varchar(10),
occupation varchar(10),
dob Date,
constraint reader_pk Primary key(reader_id)

);

insert into readers values('C00001','Ramesh','Chandra','Sharma','Delhi','9543198345','Service','1976-12-06');
insert into readers values('C00002','Avinash','Sunder','Minha','Delhi','9876532109','Service','1974-10-16');
insert into readers values('C00003','Rahul',null,'Rastogi','Delhi','9765178901','Student','1981-09-26');
insert into readers values('C00004','Parul',null, 'Gandhi','Delhi','9876532109','Housewife','1976-11-03');
insert into readers values('C00005','Naveen','Chandra','Aedekar','Mumbai','8976','Service','1976-09-19');
insert into readers values('C00006','Chitesh',null,'Barwe','Mumbai','7651298321','Student','1992-11-06');
insert into readers values('C00007','Amit','Kumar','Borkar','Mumbai','9875189761','Syudent','1981-09-06');
insert into readers values('C00008','Nisha',null,'Damle','Mumbai','7954198761','Service','1975-12-03');
insert into readers values('C00009','Abhishek',null,'Dutta','Kolkata','9856198761','Service','1973-05-22');
insert into readers values('C00010','Shankar',null,'Nair','Chennai','8765489076','Service','1976-07-12');

create table Book
(
bid varchar(6),
bname varchar(40),
bdomain varchar(30),
constraint book_bid_pk primary key(bid)

);

insert into book values('B00001','The Cat in the hat','Story');
insert into book values('B00002','Charlie and the Chocolate Factory','Story');
insert into book values('B00003','The very Hungry Caterpillar','Story');

create table active_readers (

account_id varchar(6),
reader_id varchar(6),
bid varchar(6),
atype varchar(10),
astatus varchar(10),
constraint activereaders_acnumber_pk primary key(account_id),
constraint account_readerid_fk foreign key(reader_id) references readers(reader_id),
constraint account_bid_fk foreign key(bid) references book(bid)

);
SELECT * FROM library_demo.active_readers;

insert into active_readers values('A00001','C00001','B00001','Premium','Active');
insert into active_readers values('A00002','C00002','B00002','Regular','Active');
insert into active_readers values('A00003','C00003','B00002','Premium','Active');
insert into active_readers values('A00004','C00002','B00003','Premium','Active');
insert into active_readers values('A00005','C00006','B00002','Regular','Active');
insert into active_readers values('A00006','C00007','B00001','Premium','Suspended');
insert into active_readers values('A00007','C00007','B00001','Premium','Active');
insert into active_readers values('A00008','C00001','B00003','Regular','Terminated');
insert into active_readers values('A00009','C00003','B00002','Premium','Terminated');
insert into active_readers values('A00010','C00004','B00001','Regular','Active');

create table bookissue_details
(
 issuenumber varchar(6),
 account_id varchar(6),
 bid varchar(20),
 bookname varchar(50),
 constraint trandetails_tnmuber_pk primary key(issuenumber)

);
 show tables ;

insert into bookissue_details values('T00001','A00001','B00001','The cat in the  hat');
insert into bookissue_details values('T00002','A00001','B00002','Charlie and the Chocolate Factory');
insert into bookissue_details values('T00003','A00002','B00001','The cat in the hat');
insert into bookissue_details values('T00004','A00002','B00003','The very Hungry Caterpillar');

select * from active_readers;


select * from active_readers where astatus ='Terminated' ;


select * from active_readers where astatus ='Active';

select count(account_id) from active_readers where atype =" Premium";