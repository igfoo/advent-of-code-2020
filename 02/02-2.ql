
external predicate input(string s);

bindingset[first, second, c, s]
predicate check(int first, int second, string c, string s) {
  s.charAt([first, second] - 1) = c
  and
  s.charAt([first, second] - 1) != c
}

bindingset[s]
predicate valid(string s) {
  check(s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 1).toInt(),
        s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 2).toInt(),
        s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 3),
        s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 4))
}

select count(string s | input(s) and valid(s))

