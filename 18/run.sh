#!/bin/sh

set -e

ghc --make -O 18-1
./18-1
ghc --make -O 18-2
./18-2

