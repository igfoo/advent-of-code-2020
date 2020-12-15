
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

bindingset[right]
int right_slope(int right) {
  result = count(int i, string s | numbered_input(i, s) and s.charAt((i * right) % s.length()) = "#")
}

bindingset[down]
int down_slope(int down) {
  result = count(int i, string s | numbered_input(i, s) and i % down = 0 and s.charAt((i / down) % s.length()) = "#")
}

select right_slope(1) * right_slope(3) * right_slope(5) * right_slope(7) * down_slope(2)

