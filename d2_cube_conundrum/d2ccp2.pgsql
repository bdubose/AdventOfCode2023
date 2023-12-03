-- same data loading as part 1 ----------
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

-- new for part 2 below ---------------
create temp table game_reqs as
select
  r.game_id
, max(r.amount) filter (where r.color = 'blue') as min_blues
, max(r.amount) filter (where r.color = 'green') as min_greens
, max(r.amount) filter (where r.color = 'red') as min_reds
from results r
group by r.game_id
order by r.game_id
;

select
  sum(min_blues * min_greens * min_reds) as answer
from game_reqs
;