
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

predicate state(int i, int x, int y, int wpx, int wpy) {
  (i = -1 and x = 0 and y = 0 and wpx = 10 and wpy = 1)
  or
  exists(string s, string c, int v | numbered_input(i, s) and c = s.charAt(0) and v = s.suffix(1).toInt() and
         ((c = "N" and state(i - 1, x, y, wpx, wpy - v)) or
          (c = "S" and state(i - 1, x, y, wpx, wpy + v)) or
          (c = "E" and state(i - 1, x, y, wpx - v, wpy)) or
          (c = "W" and state(i - 1, x, y, wpx + v, wpy)) or
          (c = "L" and state(i - 1, x, y, wpy, -wpx) and v = 90) or
          (c = "L" and state(i - 1, x, y, -wpx, -wpy) and v = 180) or
          (c = "L" and state(i - 1, x, y, -wpy, wpx) and v = 270) or
          (c = "R" and state(i - 1, x, y, -wpy, wpx) and v = 90) or
          (c = "R" and state(i - 1, x, y, -wpx, -wpy) and v = 180) or
          (c = "R" and state(i - 1, x, y, wpy, -wpx) and v = 270) or
          (c = "F" and state(i - 1, x - v * wpx, y - v * wpy, wpx, wpy))
         ))
}

int last() {
  result = max(int i | numbered_input(i, _))
}

from int x, int y
where state(last(), x, y, _, _)
select x.abs() + y.abs()

