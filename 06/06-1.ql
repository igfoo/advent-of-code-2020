
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

class Group extends int {
  Group() {
    this = 0 or numbered_input(this - 1, "")
  }

  int last() {
    if exists(Group g | g > this)
    then result = min(Group g | g > this) - 2
    else result = max(int i | numbered_input(i, _))
  }

  string getLine(int i) {
    numbered_input(i, result) and
    i = [this .. this.last()]
  }

  int number() {
    result = count(this.getLine(_).charAt(_))
  }
}

select sum(Group g || g.number())

