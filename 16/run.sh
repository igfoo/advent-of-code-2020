#!/bin/sh

set -e

ghc --make -O 16-1
./16-1
ghc --make -O 16-2
./16-2

