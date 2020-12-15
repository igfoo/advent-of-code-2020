
external predicate input(int i);

from int i, int j
where input(i) and input(j) and i + j = 2020
select i * j

