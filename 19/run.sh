#!/bin/sh

set -e

ghc --make -O 19-1
./19-1
ghc --make -O 19-2
./19-2

