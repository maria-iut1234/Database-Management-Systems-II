drop table franchise cascade Constraint;
drop table customer cascade Constraint;
drop table customer_franchise cascade Constraint;
drop table cuisine cascade Constraint;
drop table preferred_cuisine cascade Constraint;
drop table rating cascade Constraint;
drop table branch cascade Constraint;
drop table chef cascade Constraint;
drop table menu cascade Constraint;
drop table menu_items cascade Constraint;
drop table created_by cascade Constraint;
drop table orders cascade Constraint;
drop table offered_menu cascade Constraint;

-- menu is taken to be a list of dishes
-- cuisine is taken to be a particular dish

create table franchise(
    f_name varchar2(20) primary key
);

create table customer(
    c_id number primary key,
    c_name varchar2(20)
);

create table customer_franchise(
    c_id number,
    f_name varchar2(20),
    Constraint pk_customer primary key (c_id, f_name),
    Constraint fk_fname_customer foreign key (f_name) references franchise(f_name)
);

create table cuisine(
    cuisine_id number primary key,
    main_ingredient varchar2(20),
    price number,
    calorie_count number
);

create table preferred_cuisine(
    c_id number,
    cuisine_id number,
    Constraint fk_cid_preferredCuisine foreign key (c_id) references customer(c_id),
    Constraint fk_Cuisineid_preferredcuisine foreign key (cuisine_id) references cuisine(cuisine_id),
    Constraint pk_preferredCusine primary key (c_id, cuisine_id)
);

create table rating(
    c_id number,
    cuisine_id number,
    rating number
);

create table branch(
    b_id number primary key,
    location varchar2(20),
    f_name varchar2(20),
    Constraint fk_fname_branch foreign key (f_name) references franchise(f_name)
);

create table chef(
    chef_id number primary key,
    b_id number,
    cuisine_expertise number,
    Constraint fk_bid_chef foreign key (b_id) references branch(b_id),
    Constraint fk_cuisine_expertise foreign key (chef_id) references cuisine(cuisine_id)
);

create table menu(
    menu_name varchar2(20) primary key
);

create table menu_items(
    menu_name varchar2(20),
    cuisine_id number,
    Constraint fk_cuisineid_menuitems foreign key (cuisine_id) references cuisine(cuisine_id),
    Constraint fk_menuname_menuitems foreign key (menu_name) references menu(menu_name)
);

create table created_by(
    menu_name varchar2(20),
    chef_id number,
    menu_number number,
    Constraint pk_createdby primary key (menu_name, chef_id, menu_number),
    Constraint fk_chefid_createdby foreign key (chef_id) references chef(chef_id),
    Constraint menu_less_than_5 check (menu_number > 0 and menu_number <= 5)
);

create table orders(
    o_id number primary key,
    c_id number,
    cuisine_id number,
    Constraint cid_order foreign key (c_id) references customer(c_id),
    Constraint cuisineid_order foreign key (cuisine_id) references cuisine(cuisine_id)
);

create table offered_menu( 
    menu_name varchar2(20),
    f_name varchar2(20),
    Constraint fk_menu_offered_by foreign key (menu_name) references menu(menu_name),
    Constraint fk_fname_offeredby foreign key (f_name) references franchise(f_name)
);


-- SQL queries

select f_name, count(c_id) as total
from customer_franchise
group by f_name;

--

select cuisine_id, avg(rating)
from rating
group by cuisine_id;

--

select cuisine_id
from (select cuisine_id, count(o_id) as total
    from orders
    group by cuisine_id
    order by total)
where rownum <=5;

--

select c_name
from (
    select c_id, cuisine_id
    from (
        select preferred_cuisine.c_id as c_id, preferred_cuisine.cuisine_id as cuisine_id, offered_menu.f_name as f_name
        from preferred_cuisine, offered_menu, menu_items
        where preferred_cuisine.cuisine_id = menu_items.cuisine_id and offered_menu.menu_name = menu_items.menu_name
    )
    group by c_id, cuisine_id
    having count(f_name) >=2
) A, customer
where A.c_id = customer.c_id;

--

select c_name
from (select c_id from customer
    minus
    select distinct c_id from orders) A, customer
where A.c_id = customer.c_id;
