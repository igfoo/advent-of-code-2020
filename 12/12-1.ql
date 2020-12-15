
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

string left(string dir, int angle) {
  (dir in ["N", "S", "E", "W"] and result = dir and angle = 0) or
  (angle < 360 and left(dir, angle - 90) = "N" and result = "W") or
  (angle < 360 and left(dir, angle - 90) = "W" and result = "S") or
  (angle < 360 and left(dir, angle - 90) = "S" and result = "E") or
  (angle < 360 and left(dir, angle - 90) = "E" and result = "N")
}

string right(string dir, int angle) {
  dir = left(result, angle)
}

predicate state(int i, int x, int y, string dir) {
  (i = -1 and x = 0 and y = 0 and dir = "E")
  or
  exists(string s, string c, int v | numbered_input(i, s) and c = s.charAt(0) and v = s.suffix(1).toInt() and
         ((c = "N" and state(i - 1, x, y - v, dir)) or
          (c = "S" and state(i - 1, x, y + v, dir)) or
          (c = "E" and state(i - 1, x - v, y, dir)) or
          (c = "W" and state(i - 1, x + v, y, dir)) or
          (c = "L" and state(i - 1, x, y, right(dir, v))) or
          (c = "R" and state(i - 1, x, y, left(dir, v))) or
          (c = "F" and state(i - 1, x, y - v, dir) and dir = "N") or
          (c = "F" and state(i - 1, x, y + v, dir) and dir = "S") or
          (c = "F" and state(i - 1, x - v, y, dir) and dir = "E") or
          (c = "F" and state(i - 1, x + v, y, dir) and dir = "W")
         )
  )
}

int last() {
  result = max(int i | numbered_input(i, _))
}

from int x, int y
where state(last(), x, y, _)
select x.abs() + y.abs()

