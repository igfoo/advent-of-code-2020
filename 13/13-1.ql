
// tr , ';' < input | nl -ba -s, -w1 -v0 > numbered_semi_input

external predicate numbered_semi_input(int i, string s);

int time() {
  exists(string s | numbered_semi_input(0, s) and result = s.toInt())
}

int bus() {
  exists(string s | numbered_semi_input(1, s) and result = s.splitAt(";").toInt())
}

select min(int b, int next | b = bus() and next = ((time() + b - 1) / b) * b | (next - time()) * b order by next)

