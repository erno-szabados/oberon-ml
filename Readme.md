# Oberon ML Library

This project implements

- Utility functions: 
   - bitwise operations for INTEGER and BYTE types
   - UTF-8 string manipulation
   - Random numbers (PRNG with Lehmer MLCG)
- Classic ML algorithms: 
   - Perceptron, 
   - Linear Regressor,
   - K-Nearest Neighbor with K-D Tree and QuickSelect.
- Unit tests for the above

- Implementation is in [Oberon-07](https://en.wikipedia.org/wiki/Oberon_(programming_language)). 

## Requirements

- [OBNC](https://miasap.se/obnc/) (Oberon-07 compiler) OR
- `make` (for building and running tests)

## Documentation
 - [HTML](https://erno-szabados.github.io/oberon-ml/) - generated with obncdoc

## Structure

- [src](src/): Oberon sources for modules and the test suites.
- [docs](docs/): OBNC API and API documentation for the implemented modules.
- [lib](src/lib) - the runtime source code from the akron compiler source, needed if you use the akron compiler, licensed under BSD-2

## Building

To build, issue the commands from the project root:

```sh
cd src
make -f Makefile
```
The test binaries are generated in the `bin/` folder.


