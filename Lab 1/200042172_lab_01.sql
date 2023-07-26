drop table franchise cascade constraint;
drop table customer cascade constraint;
drop table customer_membership constraint;
drop table menu cascade constraint;
drop table cuisine cascade constraint;
drop table preferred_cuisine cascade constraint;
drop table rating cascade constraint;
drop table branch cascade constraint;
drop table chef cascade constraint;
drop table cuisine_items cascade constraint;
drop table special_menu cascade constraint;
drop table order cascade constraint;
drop table menu_offered cascade constraint;


create table franchise
(
    franchise_id int not null,
    franchise_name varchar2(25),
    constraint pk_franchise_id primary key(franchise_id)
);

create table customer
(
    customer_id int not null,
    customer_name varchar2(25),
    constraint pk_customer_id primary key(customer_id),
);

create table customer_membership
(
    customer_id int not null,
    franchise_id int not null,
    constraint pk_id primary key(franchise_id, customer_id),
    constraint fk_franchise_id foreign key(franchise_id) references franchise(franchise_id)
    constraint fk_customer_id foreign key(franchise_id) references franchise(franchise_id)
);

create table menu
(
    menu_id int not null,
    menu_name varchar2(25),
    main_ingrediant varchar2(25),
    price number,
    calorie_count int,
    constraint pk_menu_id primary key(menu_id)
);

create table cuisine
(
    cuisine_id int not null,
    cuisine_name varchar2(25),
    constraint pk_cuisine_id primary key(cuisine_id),
);

create table preferred_cuisine
(
    customer_id int not null,
    cuisine_id int not null,
    constraint pk_preferred_cuisine_id primary key(cuisine_id, customer_id),
    constraint fk_customer_id foreign key(customer_id) references customer(customer_id),
    constraint fk_cuisine_id foreign key(cuisine_id) references cuisine(cuisine_id)
);

create table rating
(
    customer_id int not null,
    menu_id int not null,
    rating number,
    constraint pk_rating_id primary key(customer_id, menu_id),
    constraint fk_customer_id foreign key(customer_id) references customer(customer_id),
    constraint fk_menu_id foreign key(menu_id) references menu(menu_id)
);

create table branch
(
    branch_id int not null,
    branch_name varchar2(25),
    location varchar2(25),
    franchise_id int not null,
    constraint pk_branch_id primary key(branch_id),
    constraint fk_franchise_id foreign key(franchise_id) references franchise(franchise_id)
);

create table chef
(
    chef_id int not null,
    cuisine_expertise_id int,
    branch_id int not null,
    constraint pk_chef_id primary key(chef_id),
    constraint fk_cuisine_expertise_id foreign key(cuisine_expertise_id) references cuisine(cuisine_id),
    constraint fk_branch_id foreign key(branch_id) references branch(branch_id)
);

create table cuisine_items
(
    cuisine_id int,
    menu_id int,
    constraint pk_c_item primary key(cuisine_id, menu_id),
    constraint fk_cuisine_id_items foreign key (cuisine_id) references cuisine(cuisine_id),
    constraint fk_menu_id_items foreign key (menu_id) references menu(menu_id),
)

create table special_menu
(
    menu_id int not null,
    chef_id int not null,
    menu_number int,
    constraint pk_special_menu_id primary key(menu_id, chef_id, menu_number),
    constraint fk_s_chef_id foreign key(chef_id) references chef(chef_id),
    constraint fk_s_menu_id foreign key(menu_id) references menu(menu_id),
    constraint check_five check (menu_number > 0 and menu_number <= 5)
);

create table order
(
    order_id int not null,
    customer_id int,
    menu_id int,
    constraint pk_order_id primary key(order_id),
    constraint fk_o_customer_id foreign key(customer_id) references customer(customer_id),
    constraint fk_o_menu_id foreign key(menu_id) references menu(menu_id)
);

create table menu_offered
(
    menu_id int,
    franchise_id int,
    constraint pk_menu_offered primary key(menu_id, franchise_id),
    constraint fk_om_menu_id foreign key(menu_id) references menu(menu_id),
    constraint fk_om_franchise_id foreign key(franchise_id) references franchise(franchise_id)
);


-----task(a)-----
select franchise_id, count(customer_id) as customer
from customer_membership
group by franchise_id;

-----task(b)-----
select menu_id, avg(rating) as rating
from rating
group by menu_id;

-----task(c)-----
select menu_id
from (select menu_id, count(order_id)
        from order
        group by menu_id
        order by count(order_id))
where rownum <= 5;

-----task(d)-----
select cid, customer_name
from(select cid, count(fid)
    from (select preferred_cuisine.customer_id as cid, menu_offered.franchise_id as fid 
        from preferred_cuisine, menu_offered, cuisine_items
        where preferred_cuisine.cuisine_id = cuisine_items.cuisine_id and menu_offered.menu_id = cuisine_items.menu_id)
    group by cid
    where count(fid) >= 2), customer
where customer_id = cid;
 
 -----task(e)-----
 select customer_name
 from (select customer_id
        from customer
        minus
        select distinct customer_id
        from order) natural join customer;
