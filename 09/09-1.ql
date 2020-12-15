
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

int preamble() { result = 25 }

int val(int i) {
  exists(string s |
    numbered_input(i, s) and result = s.toInt()
  )
}

select val(min(int i | exists(val(i)) and
                       i >= preamble() and
                       not exists(int j, int k | j = [i - preamble() .. i - 1] and
                                                 k = [i - preamble() .. i - 1] and
                                                 j != k and // (or their vals are not equal?)
                                                 val(j) + val(k) = val(i))))

