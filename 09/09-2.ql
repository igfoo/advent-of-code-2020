
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

int preamble() { result = 25 }

int val(int i) {
  exists(string s |
    numbered_input(i, s) and result = s.toInt()
  )
}

from int target, int low, int high
where target = val(min(int i | exists(val(i)) and
                               i >= preamble() and
                               not exists(int j, int k | j = [i - preamble() .. i - 1] and
                                                         k = [i - preamble() .. i - 1] and
                                                         j != k and // (or their vals are not equal?)
                                                         val(j) + val(k) = val(i))))
  and exists(val(low))
  and exists(val(high))
  and high >= low + 2
  and strictsum(int i | i = [low .. high] | val(i)) = target
select min(int i | i = [low .. high] | val(i)) + max(int i | i = [low .. high] | val(i))

