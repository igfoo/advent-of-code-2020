
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

Instruction start() { result = 0 }
int end() { result = max(int i | numbered_input(i, _)) + 1 }

class Instruction extends int {
  string kind;
  int value;
  Instruction() {
    exists(string s | numbered_input(this, s) and
                      kind = s.prefix(3) and
                      value = s.suffix(4).toInt())
  }

  predicate isJump(Instruction flip) {
    kind = "jmp" and flip != this
    or
    kind = "nop" and flip = this
  }

  int next(Instruction flip) {
    if this.isJump(flip) then result = this + value else result = this + 1
  }

  int nextTrans(Instruction flip) {
    result = this.next(flip) or
    result = this.nextTrans(flip).(Instruction).next(flip)
  }

  int valueBefore(NonLoopingFlip flip) {
    if this = 0 then result = 0
    else result = any(Instruction i | this = i.next(flip)).valueAfter(flip)
  }

  int valueAfter(NonLoopingFlip flip) {
    if kind = "acc"
    then result = valueBefore(flip) + value
    else result = valueBefore(flip)
  }
}

class NonLoopingFlip extends Instruction {
  NonLoopingFlip() {
    start().nextTrans(this) = end()
  }
}

from NonLoopingFlip f, Instruction last
where start().nextTrans(f) = last
  and last.next(f) = end()
select f, last, last.valueAfter(f)
