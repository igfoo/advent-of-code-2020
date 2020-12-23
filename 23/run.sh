#!/bin/sh

set -e

ghc --make -O 23-1
./23-1
ghc --make -O 23-2
./23-2

