#!/bin/sh

set -e

ghc --make -O 17-1
./17-1
ghc --make -O 17-2
./17-2

