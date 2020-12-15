
// tr , ';' < input > semi_input

external predicate semi_input(string s);

class Colour extends string {
  string line;
  Colour() {
    semi_input(line) and this = line.splitAt(" bags contain ", 0)
  }

  Colour contains() {
    result = line.splitAt(" bags contain ", 1).splitAt("; ").regexpCapture("^[0-9]+ (.*) bags?\\.?$", 1)
  }
}

select count(Colour c | "shiny gold" = c.contains+())

