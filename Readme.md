# Oberon ML Library

This project implements classic ML algorithms in [Oberon-07](https://en.wikipedia.org/wiki/Oberon_(programming_language)). 

## Requirements

- [OBNC](https://miasap.se/obnc/) (Oberon-07 compiler) OR
- [Akron](https://github.com/AntKrotov/oberon-07-compiler) (Oberon-07 Compiler)
- `make` (for building and running tests)

## Structure

- [`src/Perceptron.Mod`](src/Perceptron.Mod): Single-layer Perceptron implementation.
- [`src/LinearRegressor.Mod`](src/LinearRegressor.Mod): Linear Regressor implementation using Ordinary Least Squares.
- [`src/KNN.Mod`](src/KNN.Mod): K-Nearest Neighbor implementation with QuickSelect.
- [lib](src/lib) - the runtime source code from the akron compiler source, needed if you use the akron compiler, licensed under BSD-2

## Building

To build and run all tests:

```sh
cd src

make -f Makefile.obnc
OR
make -f Makefile.akron

The makefile symlinks the .mod files to .ob07 for the akron compiler, as it accepts this extension only. 

bin/TestRegressor
bin/TestPerceptron
bin/TestKNN
```
