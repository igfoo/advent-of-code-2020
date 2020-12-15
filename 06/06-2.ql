
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

  int number() {
    result = count(string c | forex(string s | numbered_input([this..this.last()], s) | c = s.charAt(_)))
  }
}

select sum(Group g || g.number())

