set serveroutput on size 1000000
set verify off

-----1-----
-----function-----
drop sequence acc_seq;
create sequence acc_seq
minvalue 123456
maxvalue 999999
start with 123456
increment by 1
cache 500;

create or replace
function gen_id(i_name in Account.name%type, i_AccCode in Account.AccCode%type, i_OpeningDate in Account.OpeningDate%type)
return varchar2
is
begin
    new_acc_id varchar2(100);

    new_acc_id:= 'nothing';
    new_acc_id := i_AccCode;
    new_acc_id := new_acc_id || extract(year from i_OpeningDate);
    new_acc_id := new_acc_id || lpad(extract(month from i_OpeningDate), 2, 0);
    new_acc_id := new_acc_id || lpad(extract(day from i_OpeningDate), 2, 0);
    new_acc_id := new_acc_id || ".";
    new_acc_id := new_acc_id || rpad(i_name, 3);
    new_acc_id := new_acc_id || ".";
    new_acc_id := new_acc_id || acc_seq.nextval;

return new_acc_id;
end;
/

-----call-----

-----2-----


-----3-----


-----4-----


-----5-----