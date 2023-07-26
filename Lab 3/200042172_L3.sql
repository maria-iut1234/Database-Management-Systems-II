set serveroutput on size 1000000
set verify off

------1------
-----procedure-----
create or replace
procedure cinema_time(m_title in movie.mov_title%type)
is
    mov_time movie.mov_time%type;
    count_hours number;
    count_mins number;
    count_int number;

    cursor find_movie(m_title movie.mov_title%type)
    is
        select mov_time
        from movie
        where mov_title = m_title;

begin
    open find_movie(m_title);
    loop
        fetch find_movie into mov_time;
        exit when find_movie%notfound;

            count_int := floor(mov_time/70);
            mov_time := mov_time + (count_int * 15);
            count_hours := floor(mov_time/60);
            count_mins := mov_time - (60*count_hours);

            dbms_output.put_line('Cinema Time: ' || to_char(count_hours) || 
            ' hours and ' || to_char(count_mins) || ' minutes.');
   
    end loop;
    close find_movie;
end;
/

-----call-----
declare
    m_title varchar(50);
begin
    m_title := '& m_title';
    cinema_time(m_title);
end;
/

------2------
-----procedure-----
create or replace
procedure top_rated(n in number)
is
    row_num int;
    mov_title movie.mov_title%type;
    rev_stars rating.rev_stars%type;

    cursor find_movies(n number)
    is
        select *
        from
        (
            select mov_title, round(avg(rev_stars), 2) as r_stars
            from movie natural join rating
            group by mov_title
            order by avg(rev_stars) desc
        )
        where rownum<=n;
begin
    for row in (select count(*) as c from movie) loop
        if n>row.c then
            raise_application_error(-2000, 'Number exceeds total number of movies!');
        else
            open find_movies(n);
            row_num := 1;
            loop
                fetch find_movies into mov_title, rev_stars;
                exit when find_movies%notfound;

                dbms_output.put_line(row_num);
                dbms_output.put_line('Movie Title: ' || mov_title);
                dbms_output.put_line('Average Rev Stars: ' || rev_stars);
                dbms_output.put_line('-----');

                row_num := row_num + 1;

            end loop;
            close find_movies;
        end if;
    end loop;
end;
/

-----call-----
declare
    num int;
begin
    num := '& num';
    top_rated(num);
end;
/

------3------
-----function-----
create or replace
function yearly_earning(m_title in movie.mov_title%type)
return varchar2
is
    yearly_earning varchar2(20);
    mov_releasedate movie.mov_releasedate%type;
    temp_calc number;
    r_date number;
    c int;

    cursor find_rev_stars(m_title movie.mov_title%type)
    is
        select mov_releasedate, rev_stars as c
        from movie natural join rating
        where mov_title=m_title and rev_stars>=6;

begin
    temp_calc := 0;
    open find_rev_stars(m_title);

    loop
        fetch find_rev_stars into mov_releasedate, c;
        exit when find_rev_stars%notfound;
            temp_calc := temp_calc + (10*(10-c));
    end loop;

    r_date := extract(year from mov_releasedate);
    temp_calc := round((temp_calc/(2023-r_date)), 2);
    yearly_earning := to_char(temp_calc);

    close find_rev_stars;
return yearly_earning;
end;
/

-----call-----
declare
    movie varchar2(25);
begin
    movie := '& movie';
    dbms_output.put_line(yearly_earning(movie));
end;
/

------4------
-----function-----
create or replace
function genre_status(g_id in number)
return varchar2
is
    result varchar2(100);
    avg_rev number;
    avg_rating number;
    g_status varchar2(25);
    rev_count number;
    rating number;

    -----to find the details of the specified genre-----
    cursor find_gen_details(g_id number)
    is
        select count(rev_id) as rev_count, round(avg(rev_stars), 2) as rating
        from genres natural join mtype natural join 
        movie natural join rating
        where gen_id = g_id
        group by gen_id;

    -----to find the average details of all genres-----
    cursor diff_gen
    is
        select avg(rev_count) as avg_rev, avg(rating) as avg_rating
        from
            (select count(rev_id) as rev_count, avg(rev_stars) as rating
            from genres natural join mtype natural join 
            movie natural join rating
            group by gen_id);

begin
    -----initialising variables-----
    result := 'nothing';
    g_status := 'nothing';
    rev_count := 0;
    rating := 0;
    avg_rating := 0;
    avg_rev := 0;

    open diff_gen;
    fetch diff_gen into avg_rev, avg_rating;

    open find_gen_details(g_id);
    fetch find_gen_details into rev_count, rating;

    if rev_count>avg_rev and rating<avg_rating then
        g_status := 'Widely Watched';
    elsif rev_count<avg_rev and rating>avg_rating then
        g_status := 'Highly Rated';
    elsif rev_count>avg_rev and rating>avg_rating then
        g_status := 'People' || 's Favorite';
    else
        g_status := 'So So';
    end if;

    result := 'Genre Status: ' || g_status || chr(10);
    result := result || 'Review Count: ' || rev_count || chr(10);
    result := result || 'Average Rating: ' || rating || chr(10);

    -----chr(10) = new line character-----

    close find_gen_details;
    close diff_gen;

return result;
end;
/

-----call-----
declare
    gen_id genres.gen_id%type;
begin
    gen_id := '& gen_id';
    dbms_output.put_line(genre_status(gen_id));
end;
/

------5------
-----function-----
create or replace
function freq_gen(d1 in date, d2 in date)
return varchar2
is
    result varchar2(100);
    gen_title genres.gen_title%type;
    mov_count number;

    cursor find_freq_gen(d1 date, d2 date)
    is
        select max(gen_title) as gen_title, count(mov_id) as mov_count
        from movie natural join mtype natural join genres
        where mov_releasedate>d1 and mov_releasedate<d2
        group by gen_id
        order by mov_count desc;  

begin
    result := 'nothing';

    open find_freq_gen(d1, d2);
    fetch find_freq_gen into gen_title, mov_count;

    result := 'Frequent Genre: ' || gen_title || chr(10);
    result := result || 'Movie Count: ' || mov_count;

    close find_freq_gen;
    return result;
end;
/

-----call-----
declare
    d1 varchar2(10);
    d2 varchar2(10);
begin
    d1 := '& d1';
    d2 := '& d2';

    dbms_output.put_line(freq_gen(to_date(d1), to_date(d2)));
end;
/
