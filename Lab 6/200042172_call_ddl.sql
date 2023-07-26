drop table customer cascade constraints;
drop table plan cascade constraints;
drop table sim cascade constraints;
drop table c_log cascade constraints;
drop table history cascade constraints;

create table customer
(
    cid int,
    c_name varchar2(100),
    dob date,
    c_address varchar2(200),
    constraint pk_cust primary key(cid)
);

create table plan 
(
    pid int,
    p_name varchar2(100),
    charge_per_min numeric(5, 2),
    constraint pk_plan primary key(pid)
);

create table sim
(
    s_id int,
    sim varchar2(50),
    pid int,
    cid int,
    constraint pk_sim primary key(s_id),
    constraint fk_pid foreign key(pid) references plan(pid),
    constraint fk_cid foreign key(cid) references customer(cid)
);

create table c_log
(
    call_id varchar2(50),
    s_id int,
    c_begin date,
    c_end date,
    charge numeric(10, 2),
    constraint pk_call primary key(call_id),
    constraint fk_sid foreign key(s_id) references sim(s_id)
);

create table history
(
    cid int,
    call_id varchar2(50),
    constraint pk_hist primary key(cid, call_id),
    constraint fk_c foreign key(cid) references customer(cid),
    constraint fk_ca foreign key(call_id) references c_log(call_id)
);


insert into plan values(1, 'Robi', 15);
insert into sim values(2, '12345678910', 1, null);

