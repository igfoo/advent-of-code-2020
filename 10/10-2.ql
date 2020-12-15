
external predicate input(int i);

int maxi() {
  result = max(int i | input(i))
}

bindingset[xlow, xhigh, ylow, yhigh]
predicate sumx(int xlow, int xhigh, int ylow, int yhigh, int rlow, int rhigh) {
  if xlow + ylow >= 1000000000
  then (rlow = xlow + ylow - 1000000000 and
        rhigh = xhigh + yhigh + 1)
  else (rlow = xlow + ylow and
        rhigh = xhigh + yhigh)
}

predicate numberFrom(int i, int low, int high) {
  (i = maxi() and low = 1 and high = 0)
  or
  (i in [1 .. maxi() + 2] and not input(i) and low = 0 and high = 0)
  or
  ((i = 0 or input(i)) and
   exists(int low1, int high1, int low2, int high2, int low3, int high3, int low12, int high12 |
          numberFrom(i + 1, low1, high1) and
          numberFrom(i + 2, low2, high2) and
          numberFrom(i + 3, low3, high3) and
          sumx(low1, high1, low2, high2, low12, high12) and
          sumx(low12, high12, low3, high3, low, high)))
}

from int low, int high, string s
where numberFrom(0, low, high)
  and if high > 0 then s = high.toString() + ("00000000" + low.toString()).regexpCapture(".*(.........)$", 1)
      else s = low.toString()
select s

