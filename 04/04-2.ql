
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

class Field extends string {
  Field() { this = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] }
}

class Passport extends int {
  Passport() {
    (this = 0 or numbered_input(this, ""))
  }

  string getLine(int i) {
    numbered_input(i, result) and
    i >= this and
    forall(Passport p | p > this | i < p)
  }

  string text() {
    result = concat(this.getLine(_), " ")
  }

  string getField(Field name) {
    result = this.text().splitAt(" ").regexpCapture(name + ":(.*)", 1)
  }

  int getIntField(Field name) {
    result = this.getField(name).toInt()
  }

  int getCmField(Field name) {
    result = this.getField(name).regexpCapture("([0-9]+)cm", 1).toInt()
  }

  int getInField(Field name) {
    result = this.getField(name).regexpCapture("([0-9]+)in", 1).toInt()
  }

  predicate valid() {
    this.getIntField("byr") = [1920..2002] and
    this.getIntField("iyr") = [2010..2020] and
    this.getIntField("eyr") = [2020..2030] and
    (this.getCmField("hgt") = [150..193] or this.getInField("hgt") = [59..76]) and
    this.getField("hcl").regexpMatch("^#[0-9a-f]{6}$") and
    this.getField("ecl") = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] and
    this.getField("pid").regexpMatch("^[0-9]{9}$")
  }
}

select count(Passport p | p.valid())

