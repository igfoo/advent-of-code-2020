
// tr , ';' < input > semi_input

external predicate semi_input(string s);

class Colour extends string {
  string line;
  Colour() {
    semi_input(line) and this = line.splitAt(" bags contain ", 0)
  }

  predicate contains(Colour c, int n) {
    exists(string s | s = line.splitAt(" bags contain ", 1).splitAt("; ")
                    | n = s.regexpCapture("^([0-9]+) (.*) bags?\\.?$", 1).toInt() and
                      c = s.regexpCapture("^([0-9]+) (.*) bags?\\.?$", 2))
  }

  language[monotonicAggregates]
  int size() {
    result = 1 + sum(Colour c, int n | this.contains(c, n) | n * c.size())
  }
}

select "shiny gold".(Colour).size() - 1

