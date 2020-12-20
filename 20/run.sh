#!/bin/sh

set -e

ghc --make -O 20-1
./20-1
ghc --make -O 20-2
./20-2

