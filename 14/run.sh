#!/bin/sh

ghc --make -O 14-1
./14-1
ghc --make -O 14-2
./14-2

