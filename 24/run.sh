#!/bin/sh

set -e

ghc --make -O 24-1
./24-1
ghc --make -O 24-2
./24-2

