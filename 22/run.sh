#!/bin/sh

set -e

ghc --make -O 22-1
./22-1
ghc --make -O 22-2
./22-2

