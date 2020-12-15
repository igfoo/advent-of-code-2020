
external predicate input(string s);

bindingset[s]
int fromBinary(string s) {
  result = sum(int i || s.charAt(i).regexpReplaceAll("[LF]","").length().bitShiftLeft(9 - i))
}

select max(string s | input(s) | fromBinary(s))

