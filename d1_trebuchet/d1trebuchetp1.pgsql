create temporary table coordinates_list(val text);

\copy coordinates_list from './data.txt'

select sum(c.coord::int) as answer
from
(
    select concat(left(d.digits, 1), right(d.digits, 1)) as coord
    from
    (
        select regexp_replace(cl.val, '\D', '', 1, 0) as digits
        from coordinates_list cl
    ) d
) c
;

drop table if exists coordinates_list;