# Oberon ML Library

This project implements classic ML algorithms in [Oberon-07](https://en.wikipedia.org/wiki/Oberon_(programming_language)). 

## Requirements

- [Akron](https://github.com/AntKrotov/oberon-07-compiler) (Oberon-07 Compiler) - for the o7-akron branch
- `make` (for building and running tests)

## Structure

- [`src/Perceptron.Mod`](src/Perceptron.Mod): Perceptron neural network implementation
- [`src/LinearRegressor.Mod`](src/LinearRegressor.Mod): Linear Regressor implementation using Ordinary Least Squares
- [lib](lib) - the runtime source code from the akron compiler source, licensed under BSD-2

## Building

To build and run all tests:

```sh
cd src
make regressor
make perceptron
bin/TestRegressor
bin/TestPerceptron
```
