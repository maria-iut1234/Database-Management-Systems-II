set serveroutput on size 1000000
set verify off

-----1-----
-----function-----
create or replace
function current_balance(a_num in Account.id%type)
return numeric
is

    p_amount Balance.PrincipleAmount%type; ---principle amount---
    t_amount Transaction.Amount%type; ---transaction amount---
    curr_balance numeric;

    cursor transaction_amount(a_num Account.id%type)
    is
        select sum(amount) amount
        from transaction
        where AccNo = a_num;

    cursor prin_am(a_num Account.id%type)
    is
        select PrincipleAmount as pm
        from balance
        where AccNo = a_num;

begin
    curr_balance := 0.0;

    open prin_am(a_num);
    fetch prin_am into p_amount;

    curr_balance := p_amount;

    open transaction_amount(a_num);
    fetch transaction_amount into t_amount;

    curr_balance := curr_balance + t_amount;

    close prin_am;
    close transaction_amount;

return curr_balance;
end;
/

-----call-----
declare
    acc_num int;
begin
    acc_num := '& acc_num';
    dbms_output.put_line('Current Balance: ' || current_balance(acc_num));
end;
/

-----2-----
-----function-----
create or replace
function profit(acc_num in Account.id%type)
return varchar2
is
    result varchar2(200);
    pr AccountProperty.ProfitRate%type; ---profit rate---
    pa Balance.PrincipleAmount%type; ---principle amount---
    gp AccountProperty.GracePeriod%type; ---grace period---
    month_num int;
    total_profit numeric;
    temp_profit numeric;
    after_balance numeric;

    cursor info(acc_num Account.id%type)
    is
        select AccountProperty.ProfitRate, AccountProperty.GracePeriod, Balance.PrincipleAmount
        from Account, AccountProperty, Balance
        where Account.id = Balance.AccNo and Account.AccCode = AccountProperty.id and Account.id=acc_num;


    cursor month_diff(acc_num Account.id%type)
    is
        select floor(months_between(cast(systimestamp as date), cast(LastDateInterest as date)))
        from Account, dual
        where id = acc_num;

begin
    after_balance := 0;
    total_profit := 0;
    temp_profit := 0;
    result := 'nothing';

    open info(acc_num);
    fetch info into pr, gp, pa;

    open month_diff(acc_num);
    fetch month_diff into month_num;

    for i in 1..month_num loop

        temp_profit := temp_profit + (pa * (pr/100));
        total_profit := total_profit + temp_profit;

        if(mod(i, gp) = 0) then
            pa := pa + temp_profit;
            temp_profit := 0;
        end if;

    end loop;

    after_balance := pa + total_profit;

    result := 'Profit = ' || total_profit || chr(10);
    result := result || 'Balance before Profit = ' || pa || chr(10);
    result := result || 'Balance after Profit = ' || after_balance || chr(10);

return result;
end;
/

-----call-----
declare
    acc_num int;
begin
    acc_num := '& acc_num';
    dbms_output.put_line(profit(acc_num));
end;
/

-----3-----
-----function----
create or replace
function profit_for_insertion(acc_num in Account.id%type)
return numeric
is
    pr AccountProperty.ProfitRate%type; ---profit rate---
    pa Balance.PrincipleAmount%type; ---principle amount---
    gp AccountProperty.GracePeriod%type; ---grace period---
    month_num int;
    total_profit numeric;
    temp_profit numeric;
    after_balance numeric;

    cursor info(acc_num Account.id%type)
    is
        select AccountProperty.ProfitRate, AccountProperty.GracePeriod, Balance.PrincipleAmount
        from Account, AccountProperty, Balance
        where Account.id = Balance.AccNo and Account.AccCode = AccountProperty.id and Account.id=acc_num;


    cursor month_diff(acc_num Account.id%type)
    is
        select floor(months_between(cast(systimestamp as date), cast(LastDateInterest as date)))
        from Account, dual
        where id = acc_num;

begin
    after_balance := 0;
    total_profit := 0;
    temp_profit := 0;

    open info(acc_num);
    fetch info into pr, gp, pa;

    open month_diff(acc_num);
    fetch month_diff into month_num;

    for i in 1..month_num loop

        temp_profit := temp_profit + (pa * (pr/100));
        total_profit := total_profit + temp_profit;

        if(mod(i, gp) = 0) then
            pa := pa + temp_profit;
            temp_profit := 0;
        end if;

    end loop;

return total_profit;
end;
/

-----procedure-----
create or replace
procedure insert_profit
is
    acc_num Account.id%type;
    prof Balance.ProfitAmount%type;

    cursor find_acc
    is
        select id
        from account;

begin
    open find_acc;

    loop
        fetch find_acc into acc_num;
        exit when find_acc%notfound;

        prof := profit_for_insertion(acc_num);

        update balance set ProfitAmount = prof where AccNo = acc_num;
    
    end loop;

end;
/

-----call-----
begin
    insert_profit;
end;
/
