# Oberon ML Library

This project provides mathematical functions and a simple perceptron implementation in [Oberon](https://en.wikipedia.org/wiki/Oberon_(programming_language)). It includes modules for common math operations, a perceptron neural network, and unit tests.

## Requirements

- [OBNC](https://miasap.se/obnc/) (Oberon-07 compiler)
- [Akron](https://github.com/AntKrotov/oberon-07-compiler) (Oberon-07 Compiler) - for the o7-akron branch
- `make` (for building and running tests)

## Structure

- [`src/Math.Mod`](src/Math.Mod): Math functions (sin, cos, arctan, sqrt, ln, exp, etc.)
- [`src/Perceptron.Mod`](src/Perceptron.Mod): Perceptron neural network implementation
- [`src/Assert.Mod`](src/Assert.Mod): Simple assertion utilities for testing
- [`src/MathTest.Mod`](src/MathTest.Mod): Unit tests for math functions
- [`src/PerceptronTest.Mod`](src/PerceptronTest.Mod): Unit tests for perceptron

## Building

To build and run all tests:

```sh
cd src
make tests
