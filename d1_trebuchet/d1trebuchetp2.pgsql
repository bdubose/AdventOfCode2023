create temporary table coordinates_list(val text);

\copy coordinates_list from './data.txt'

select sum(c.coord::int) as answer
from
(
    select concat(left(d.digits, 1), right(d.digits, 1)) as coord
    from
    (
        select regexp_replace(p.parsed, '\D', '', 1, 0) as digits
        from
        (
            select
                replace(
                    replace(
                        replace(
                            replace(
                                replace(
                                    replace(
                                        replace(
                                            replace(
                                                replace(cl.val
                                                , 'nine', '9')
                                            , 'eight', '8')
                                        , 'seven', '7')
                                    , 'six', '6')
                                , 'five', '5')
                            , 'four', '4')
                        , 'three', '3')
                    , 'two', '2')
                , 'one', '1') as parsed
            from coordinates_list cl
        ) p
    ) d
) c
;

drop table if exists coordinates_list;

-- fails. Too high.
-- I think this fails because there is an order to the string numbers that I was turning into digits.
-- The true solution must evaluate each number at the same time.