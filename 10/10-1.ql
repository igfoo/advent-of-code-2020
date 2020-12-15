
external predicate input(int i);

select count(int i | (i = 0 or input(i)) and input(i + 1)) *
       (count(int i | (i = 0 or input(i)) and not input(i + 1) and not input(i + 2) and input(i + 3)) + 1)

