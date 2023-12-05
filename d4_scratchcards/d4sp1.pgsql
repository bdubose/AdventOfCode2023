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

create temp table card_points as
select
  p.card_id
, 2^(count(*)-1) as points
from pulls p
join pulls w on p.card_id = w.card_id
and p.number = w.number
and p.is_winning_number = false
and w.is_winning_number = true
group by p.card_id
;

select sum(points) as answer
from card_points
;