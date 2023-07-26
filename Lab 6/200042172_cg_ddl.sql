drop table students cascade constraints;
drop table misconducts cascade constraints;
drop table studenttransactions cascade constraints;

create table students
(
    id int,
    name varchar2(100),
    program varchar2(5),
    year int,
    cgpa numeric(3, 2),
    constraint pk_sid primary key(id)
);

create table misconducts
(
    studentid int,
    date_time date,
    description varchar2(250)
);

create table studenttransactions
(
    studentid int,
    date_time date,
    amount int
);

insert into students values (1, 'nazz', 'SWE', 2, 4);
insert into students values (2, 'nafisa', 'SWE', 2, 3.9);
insert into students values (3, 'akash', 'SWE', 2, 3.8);
insert into students values (4, 'shanta', 'SWE', 2, 4);
insert into students values (5, 'loma', 'SWE', 2, 3.5);
