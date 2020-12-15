
// /home/ian/code/real/target/intree/codeql/codeql query run 01-2.ql --dataset /home/ian/projects/dbs/util-linux/db-cpp '--external=input=input'

external predicate input(int i);

from int i, int j, int k
where input(i) and input(j) and input(k) and i + j + k = 2020
select i * j * k

