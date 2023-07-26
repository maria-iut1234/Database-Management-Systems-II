-----DDLs-----

drop table AccountProperty cascade constraint;
drop table Transaction cascade constraint;
drop table Balance cascade constraint;
drop table Account cascade constraint;

create table AccountProperty
(
    id int,
    name varchar2(20),
    ProfitRate numeric(2, 1),
    GracePeriod int,
    constraint pk_accprop primary key(id)
);

create table Account
(
    id int,
    name varchar2(20),
    AccCode int,
    OpeningDate timestamp,
    LastDateInterest timestamp,
    constraint pk_account primary key(id),
    constraint fk_acc_no foreign key(AccCode) references AccountProperty(id)
);

create table Balance
(
    AccNo int,
    PrincipleAmount numeric,
    ProfitAmount numeric,
    constraint pk_balance primary key(AccNo),
    constraint fk_a_no foreign key(AccNo) references Account(id)
);

create table Transaction
(
    tid int,
    AccNo int,
    Amount numeric,
    TransactionDate timestamp,
    constraint pk_transaction primary key(tid),
    constraint fk_acc_no1 foreign key(AccNo) references Account(id)
);


insert into AccountProperty values(2002, 'monthly',   2.8,  1);
insert into AccountProperty values(3003, 'quarterly', 4.2,  4);
insert into AccountProperty values(4004, 'biyearly',  6.8,  6);
insert into AccountProperty values(5005, 'yearly',    8,    12);

insert into Account values(15, 'Mathew',  5005, TO_TIMESTAMP('2021-08-09 13:57:40', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-12-24 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Account values(72, 'Diana',   4004, TO_TIMESTAMP('2010-03-24 08:57:40', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2020-07-20 03:55:03', 'YYYY-MM-DD HH24:MI:SS'));
insert into Account values(33, 'Gerbert', 3003, TO_TIMESTAMP('2003-11-06 17:08:33', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2009-08-14 10:11:11', 'YYYY-MM-DD HH24:MI:SS'));
insert into Account values(29, 'Marcus',  2002, TO_TIMESTAMP('2018-05-13 15:02:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2021-08-09 13:57:40', 'YYYY-MM-DD HH24:MI:SS'));
insert into Account values(18, 'Miriam',  3003, TO_TIMESTAMP('2009-08-14 10:11:11', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2020-07-20 03:55:03', 'YYYY-MM-DD HH24:MI:SS'));
insert into Account values(13, 'Ysabeau', 2002, TO_TIMESTAMP('2020-07-20 03:55:03', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2022-12-24 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));

insert into Transaction values(1, 15, 8046, TO_TIMESTAMP('2023-01-27 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(2, 15, 4027, TO_TIMESTAMP('2023-01-26 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(3, 72, 6460, TO_TIMESTAMP('2023-01-25 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(4, 72, 2284, TO_TIMESTAMP('2023-01-24 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(5, 33, 6545, TO_TIMESTAMP('2023-01-23 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(6, 33, 2984, TO_TIMESTAMP('2023-01-22 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(7, 29, 7634, TO_TIMESTAMP('2023-01-21 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(8, 29, 3763, TO_TIMESTAMP('2023-01-20 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(9, 18, 3576, TO_TIMESTAMP('2023-01-19 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(10, 18, 6297, TO_TIMESTAMP('2023-01-18 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(11, 13, 2535, TO_TIMESTAMP('2023-01-17 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));
insert into Transaction values(12, 13, 2380, TO_TIMESTAMP('2023-01-16 17:15:15', 'YYYY-MM-DD HH24:MI:SS'));

insert into Balance values(15, 54496, null);
insert into Balance values(72, 64190, null);
insert into Balance values(33, 63800, null);
insert into Balance values(29, 46116, null);
insert into Balance values(18, 78044, null);
insert into Balance values(13, 36881, null);

