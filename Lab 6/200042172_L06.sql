set serveroutput on size 1000000
set verify off

-----2(b)-----
-----function-----
create or replace function
calc_charge(i_sim in sim.sim%type, i_begin in c_log.c_begin%type, i_end in c_log.c_end%type)
return numeric
is
    charge numeric;
    rate plan.charge_per_min%type;
    duration int;

    cursor find_rate(i_sim sim.sim%type)
    is 
        select charge_per_min
        from sim natural join plan
        where sim.sim=i_sim;

begin
    duration := 0;
    charge :=0;
    duration := ceil((to_date(i_end, 'YYYY-MM-DD hh24:mi') - to_date(i_begin, 'YYYY-MM-DD hh24:mi'))*24*60);

    open find_rate(i_sim);
    fetch find_rate into rate;

    charge := rate * duration;

    close find_rate;

return charge;
end;
/

-----call-----
declare
    sim_num varchar2(50);
    call_begin date;
    call_end date;
begin
    sim_num := '& sim_num';
    call_begin := '& call_begin';
    call_end := '& call_end';

    dbms_output.put_line(calc_charge(sim_num, to_date(call_begin), to_date(call_end)));
end;
/

-----2(c)-----
-----function-----
create or replace function new_call_id
return c_log.call_id%type
is
    old_call_id c_log.call_id%type;
    new_call_id c_log.call_id%type;

    cursor get_call_id
    is
        select call_id
        from (select call_id
                from c_log
                where call_id like (call_id || '%')
                order by call_id desc)
        where rownum <= 1;
begin
    old_call_id := 'nothing';
    new_call_id := 'nothing';
    new_call_id := to_char(sysdate, 'yyyymmdd') || '.';

    open get_call_id;
    fetch get_call_id into old_call_id;

    if old_call_id is null then
        new_call_id := new_call_id || '00000001';
    else
        dbms_output.put_line('New Call ID: ' || to_char(to_number(substr(old_call_id, 10, 18)) + 1));
        new_call_id := new_call_id || lpad(to_char(to_number(substr(old_call_id, 10, 18)) + 1), 8, '0');
    end if;

    return new_call_id;
end;
/

create or replace trigger call_id_generate
before insert on c_log
for each row
begin
    :new.call_id := new_call_id();
end;
/

------3-----
-----function-----
create or replace function
ms_details(total_ms in int, per_student in int)
return varchar2
is
    result varchar2(300);
    sc_num int;
    not_selected int;
    total_sc int;
    temp students.id%type;

    cursor find_students
    is
        select  count(id)
        from    students
        where   cgpa >=3.5 and
                program = 'SWE' and
                year = 2 and
                id not in (select distinct studentid
                                            from misconducts)
        order by cgpa desc;
    
    cursor find_students_list
    is
        select  id
        from    students
        where   cgpa >=3.5 and
                program = 'SWE' and
                year = 2 and
                id not in (select distinct studentid
                                            from misconducts)
        order by cgpa desc;

begin
    result := 'nothing';
    sc_num := 0;
    not_selected := 0;

    sc_num := floor(total_ms/per_student);
    
    open find_students;
    fetch find_students into total_sc;

    if total_sc <= sc_num then
        not_selected := 0;
        sc_num := total_sc;
    else
        not_selected := total_sc - sc_num;
    end if;

    result := 'Received SC = ' || sc_num || chr(10);
    result := result || 'Did not receive MS = ' || not_selected;

    open find_students_list;

    for i in 1..sc_num loop
        fetch find_students_list into temp;
        exit when find_students_list%notfound;
        insert into studenttransactions values (temp, sysdate, per_student);
    end loop;

return result;
end;
/

-----call-----
declare
    total_ms int;
    amount_per_student int;
begin
    total_ms := '& total_ms';
    amount_per_student := '& amount_per_student';

    dbms_output.put_line(ms_details(total_ms, amount_per_student));
end;
/
