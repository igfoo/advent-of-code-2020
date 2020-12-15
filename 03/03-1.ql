
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

select count(int i, string s | numbered_input(i, s) and s.charAt(i * 3 % s.length()) = "#")

