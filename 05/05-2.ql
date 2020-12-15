
external predicate input(string s);

int seatId(string s) {
  input(s) and
  result = sum(int i || s.charAt(i).regexpReplaceAll("[LF]","").length().bitShiftLeft(9 - i))
}

from int i
where i = seatId(_) and i + 2 = seatId(_) and not i + 1 = seatId(_)
select i + 1

