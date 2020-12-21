#!/bin/sh

set -e

ghc --make -O 21-1
./21-1
ghc --make -O 21-2
./21-2

