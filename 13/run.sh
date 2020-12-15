#!/bin/sh

rq 13-1.ql --external numbered_semi_input=numbered_semi_input
ghc --make -O 13-2
./13-2

