
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

class Instruction extends int {
  string kind;
  int value;
  Instruction() {
    exists(string s | numbered_input(this, s) and
                      kind = s.prefix(3) and
                      value = s.suffix(4).toInt())
  }

  Instruction next() {
    if kind = "jmp" then result = this + value else result = this + 1
  }
}

class ReachableInstruction extends Instruction {
  ReachableInstruction() {
    this = 0.(Instruction).next*()
  }

  predicate inLoop() {
    this = this.next+()
  }

  ReachableInstruction nextNoLoop() {
    result = this.next() and
    (this.inLoop() implies this = unique(ReachableInstruction i | i.next() = this.next()))
  }

  int valueBefore() {
    if this = 0 then result = 0
    else result = any(ReachableInstruction i | this = i.nextNoLoop()).valueAfter()
  }

  int valueAfter() {
    if kind = "acc"
    then result = valueBefore() + value
    else result = valueBefore()
  }
}

select any(ReachableInstruction i | not exists(i.nextNoLoop())).valueAfter()

