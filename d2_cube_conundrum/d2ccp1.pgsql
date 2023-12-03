create temp table possible_colors as
select *
from
( values
  ('red', 12)
, ('green', 13)
, ('blue', 14)
) x(color, amount)
;

create temp table raw_games(game_id text, results text);

\copy raw_games from './data.txt' with (delimiter ':')

create temp table games as
select replace(game_id, 'Game ', '')::int as id, results
from raw_games
;

create temp table raw_results as
select
  row_number() over (order by id) as id
, id as game_id
, trim(splits) as all_pulls
from games
cross join lateral string_to_table(results, ';') splits
;

create temp table results as
select
  id
, game_id
, split_part(trim(colors), ' ', 1)::int as amount
, split_part(trim(colors), ' ', 2) as color
from raw_results
cross join lateral string_to_table(all_pulls, ',') colors
;

create temp table all_results as
select
  r.game_id
, count(*) as total_results
from results r
group by r.game_id
;

create temp table ok_results as
select
  r.game_id
, count(*) as good_results
from results r
join possible_colors pc
on pc.color = r.color and pc.amount >= r.amount
group by r.game_id
;

select sum(ar.game_id) as answer
from all_results ar
join ok_results ok on ok.game_id = ar.game_id
where ar.total_results = ok.good_results -- where all games are good
;