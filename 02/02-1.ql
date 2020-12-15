
external predicate input(string s);

bindingset[lower, upper, c, s]
predicate check(int lower, int upper, string c, string s) {
  exists(int j | j = strictcount(int i | s.charAt(i) = c) and lower <= j and j <= upper)
}

bindingset[s]
predicate valid(string s) {
  check(s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 1).toInt(),
        s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 2).toInt(),
        s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 3),
        s.regexpCapture("^([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)$", 4))
}

select count(string s | input(s) and valid(s))

