
// nl -ba -s, -w1 -v0 < input > numbered_input

external predicate numbered_input(int i, string s);

int width() {
  exists(string s | numbered_input(_, s) and result = s.length())
}

int height() {
  result = strictcount(int i | numbered_input(i, _))
}

class PRow extends int {
  PRow() { this in [0 .. height() + 1] }
}

class PCol extends int {
  PCol() { this in [0 .. width() + 1] }
}

class PCoord extends int {
  PRow prow;
  PCol pcol;

  PCoord() {
    this = (width() + 2) * prow + pcol
  }

  predicate is(PRow r, PCol c) {
    r = prow and c = pcol
  }

  PRow row() {
    result = prow
  }

  PCol col() {
    result = pcol
  }

  PCoord neighbour() {
    prow != 0 and prow != (height() + 1) and
    pcol != 0 and pcol != (width() + 1) and
    (
      result = min(PCoord coord, int i | coord.is(prow + i, pcol    ) and i > 0 and (initial_padded(coord) != "." or prow + i = height() + 1                          ) | coord order by i) or
      result = min(PCoord coord, int i | coord.is(prow - i, pcol    ) and i > 0 and (initial_padded(coord) != "." or prow - i = 0                                     ) | coord order by i) or
      result = min(PCoord coord, int i | coord.is(prow    , pcol + i) and i > 0 and (initial_padded(coord) != "."                            or pcol + i = width() + 1) | coord order by i) or
      result = min(PCoord coord, int i | coord.is(prow    , pcol - i) and i > 0 and (initial_padded(coord) != "."                            or pcol - i = 0          ) | coord order by i) or
      result = min(PCoord coord, int i | coord.is(prow + i, pcol + i) and i > 0 and (initial_padded(coord) != "." or prow + i = height() + 1 or pcol + i = width() + 1) | coord order by i) or
      result = min(PCoord coord, int i | coord.is(prow + i, pcol - i) and i > 0 and (initial_padded(coord) != "." or prow + i = height() + 1 or pcol - i = 0          ) | coord order by i) or
      result = min(PCoord coord, int i | coord.is(prow - i, pcol + i) and i > 0 and (initial_padded(coord) != "." or prow - i = 0            or pcol + i = width() + 1) | coord order by i) or
      result = min(PCoord coord, int i | coord.is(prow - i, pcol - i) and i > 0 and (initial_padded(coord) != "." or prow - i = 0            or pcol - i = 0          ) | coord order by i)
    )
  }
}

string initial_padded(PCoord coord) {
  exists(string s | numbered_input(coord.row() - 1, s) and result = s.charAt(coord.col() - 1))
  or
  (coord.row() in [0, height() + 1] and coord.col() in [0 .. width() + 1] and result = ".")
  or
  (coord.col() in [0, width() + 1] and coord.row() in [0 .. height() + 1] and result = ".")
}

predicate hasChanges(int i) {
   exists(PCoord c | iter(i - 1, c) != iter(i, c))
}

string iterNewHash(int i, PCoord coord) {
  hasChanges(i - 1) and
  result = "#" and
  iter(i - 1, coord) = "L" and
  forex(PCoord c | c = coord.neighbour() | iter(i - 1, c) != "#")
}

string iterKeepL(int i, PCoord coord) {
  hasChanges(i - 1) and
  result = "L" and
  iter(i - 1, coord) = "L" and
  iter(i - 1, coord.neighbour()) = "#"
}

pragma[noopt]
string iterNewL(int i, PCoord coord) {
  exists(PCoord c1, PCoord c2, PCoord c3, PCoord c4, PCoord c5 |
         hasChanges(i) and
         iter(i, coord) = "#" and
         c1 = coord.neighbour() and
         iter(i, c1) = "#" and
         c2 = coord.neighbour() and
         c1 < c2 and
         iter(i, c2) = "#" and
         c3 = coord.neighbour() and
         c1 < c3 and
         c2 < c3 and
         iter(i, c3) = "#" and
         c4 = coord.neighbour() and
         c1 < c4 and
         c2 < c4 and
         c3 < c4 and
         iter(i, c4) = "#" and
         c5 = coord.neighbour() and
         c1 < c5 and
         c2 < c5 and
         c3 < c5 and
         c4 < c5 and
         iter(i, c5) = "#" and
         result = "L")
}

string iterKeepHash(int i, PCoord coord) {
  hasChanges(i - 1) and
  iter(i - 1, coord) = "#" and
  result = "#" and
  exists(PCoord c1, PCoord c2, PCoord c3, PCoord c4 |
         c1 = coord.neighbour() and
         c2 = coord.neighbour() and
         c3 = coord.neighbour() and
         c4 = coord.neighbour() and
         c1 < c2 and c1 < c3 and c1 < c4 and c2 < c3 and c2 < c4 and c3 < c4 and
         iter(i - 1, c1) != "#" and
         iter(i - 1, c2) != "#" and
         iter(i - 1, c3) != "#" and
         iter(i - 1, c4) != "#")
}

string iterKeepDot(int i, PCoord coord) {
  hasChanges(i - 1) and
  result = "." and
  iter(i - 1, coord) = "."
}

string iter(int i, PCoord coord) {
  (i = -1 and result = ".") or
  (i = 0 and result = initial_padded(coord)) or
  result = iterNewHash(i, coord) or
  result = iterKeepL(i, coord) or
  result = iterNewL(i - 1, coord) or
  result = iterKeepHash(i, coord) or
  result = iterKeepDot(i, coord)
}

int lastIter() {
  result = max(int i | hasChanges(i))
}

select strictcount(PCoord c | iter(lastIter(), c) = "#")

