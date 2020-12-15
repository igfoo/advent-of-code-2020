
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

class Passport extends int {
  Passport() {
    this = 0 or numbered_input(this, "")
  }

  string getLine(int i) {
    numbered_input(i, result) and
    i >= this and
    forall(Passport p | p > this | i < p)
  }

  string text() {
    result = concat(this.getLine(_), " ")
  }

  predicate valid() {
    forall(string s | s = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
                    | this.text().matches("%" + s + ":%"))
  }
}

select count(Passport p | p.valid())

