create temp table raw_cards(card_id text, results text);

\copy raw_cards from './data.txt' with (delimiter ':')

create temp table cards as
select
  trim(replace(card_id, 'Card ', ''))::int as id
, split_part(trim(results), '|', 1) as winning_numbers
, split_part(trim(results), '|', 2) as numbers_pulled
from raw_cards
;

create temp table pulls as
select
  row_number() over (order by x.card_id) as id
, x.*
from
(
  select
    id as card_id
  , trim(wins)::int as number
  , true as is_winning_number
  from cards
  cross join lateral string_to_table(winning_numbers, ' ') wins
  where trim(wins) != ''
  union all
  select
    id as card_id
  , trim(pulls)::int as number
  , false as is_winning_number
  from cards
  cross join lateral string_to_table(numbers_pulled, ' ') pulls
  where trim(pulls) != ''
) x
;

create temp table card_wins as
select
  p.card_id
, count(*) as wins
, p.card_id + count(*) as stop_with
from pulls p
join pulls w on p.card_id = w.card_id
and p.number = w.number
and p.is_winning_number = false
and w.is_winning_number = true
group by p.card_id
;

create temp table card_collection as
select
  null as copied_from_id
, card_id
from card_wins
union all
select
  og.card_id as copied_from_id
, copies.card_id as card_id
from card_wins og
join card_wins copies
on copies.card_id <= og.stop_with
and copies.card_id > og.card_id
;

with recursive x as
(
  select
    card_id
  , wins
  from card_wins cw
  union all
  select
    card_id
  , wins - 1
  from x
  where wins > 0
)
select *
from x
order by wins;

-- going to swap languages

-- create temp table card_counts as
-- select
--   cw.card_id
-- , count(*) available
-- from card_collection cc
-- join card_wins cw on cw.card_id = cc.card_id
-- group by cw.card_id, cw.wins
-- order by card_id;


-- 820 too low
-- select sum(available) as answer
-- from card_counts;
