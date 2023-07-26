drop tablespace tbs1 including contents and datafiles cascade constraints;
drop tablespace tbs2 including contents and datafiles cascade constraints;

-----task 1-----
create tablespace tbs1
datafile 'E:/IUT Classes/4th Semester/CSE 4410 Database Management Systems II Lab/Lab 2/tbs1_data.dbf' size 10m;

create tablespace tbs2
datafile 'E:/IUT Classes/4th Semester/CSE 4410 Database Management Systems II Lab/Lab 2/tbs2_data.dbf' size 10m;

-----task 2-----
create or replace user tb12user
identified by test123;

grant all privileges to tb12user;

alter user tb12user quota 6m on tbs1;
alter user tb12user quota 4m on tbs2;

-----task 3-----
drop table department cascade constraints;
drop table student cascade constraints;
drop table course cascade constraints;

create table department
(
    id int,
    name varchar(25),
    constraint pk_d_id primary key (id)
) tablespace tbs1;

create table student
(
    id int,
    name varchar(25),
    d_id int,
    constraint pk_s_id primary key (id),
    constraint fk_dept foreign key (d_id) references department(id)
) tablespace tbs1;

-----task 4-----
create table course
(
    code int,
    name varchar(25),
    credit number,
    d_id int,
    constraint pk_c_id primary key (code),
    constraint fk_offer_by foreign key (d_id) references department(id)
) tablespace tbs2;

-----task 5-----
create or replace procedure insert_dept
as
begin
    for i in 1..10
    loop
        insert into department (id, name) values (i, 'CSE');
    end loop;
end;
/

exec insert_dept;

create or replace procedure insert_students
as
begin
    for i in 1..10000
    loop
        insert into student (id, name, d_id) values (i, 'Maria', 4);
        commit;
    end loop;
end;
/

exec insert_students;

create or replace procedure insert_courses
as
begin
    for i in 1..5000
    loop
        insert into course (code, name, credit, d_id) values (i, 'DBMS II', 1.5, 2);
        commit;
    end loop;
end;
/

exec insert_courses;

-----task 6-----
select tablespace_name, bytes/1024/1024 MB
from dba_free_space
where tablespace_name = 'TBS1';

-----task 7-----
alter tablespace tbs1 add datafile 'E:/IUT Classes/4th Semester/CSE 4410 Database Management Systems II Lab/Lab 2/tbs1_data2.dbf' size 1m;

-----task 8-----
alter database datafile 'E:/IUT Classes/4th Semester/CSE 4410 Database Management Systems II Lab/Lab 2/tbs1_data.dbf' resize 15m;

-----task 9-----
select tablespace_name, sum(bytes/1024/1024) "Database Size (MB)"
from dba_data_files
group by tablespace_name;

-----task 10-----
drop tablespace tbs1 including contents and datafiles cascade constraints;

-----task 11-----
drop tablespace tbs1 including contents keep datafiles cascade constraints;

-----bonus task-----
-----finding all the tables in a tablespace-----
select segment_name 
from dba_segments 
where segment_type='TABLE' and tablespace_name='TBS1' ;

select segment_name 
from dba_segments 
where segment_type='TABLE' and tablespace_name='TBS2' ;

-----finding the tablespace a table belongs to-----
select tablespace_name
from dba_segments
where segment_name= 'DEPARTMENT';

select tablespace_name
from dba_segments
where segment_name= 'STUDENT';

select tablespace_name
from dba_segments
where segment_name= 'COURSE';
