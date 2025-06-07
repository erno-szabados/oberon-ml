# Oberon ML Library

This project implements

- Utility functions: 
   - bitwise operations for INTEGER and BYTE types
   - UTF-8 string manipulation
   - Random numbers (PRNG with Lehmer MLCG)
   - Collections: linked lists, deque (TODO: hashmap)
- Classic ML algorithms: 
   - Perceptron, 
   - Linear Regressor,
   - K-Nearest Neighbor with K-D Tree and QuickSelect.
- Unit tests for the above, using the Tests module from the [Artemis 
  framework]: (https://github.com/rsdoiel/Artemis)

- Implementation is in [Oberon-07](https://en.wikipedia.org/wiki/Oberon_(programming_language)). 

## Requirements

- [OBNC](https://miasap.se/obnc/) (Oberon-07 compiler) OR
- `make` (for building and running tests)

## Documentation
 - [HTML](https://erno-szabados.github.io/oberon-ml/) - generated with obncdoc
 - [Collections](docs/md/Collections.md) - documents our collections API
 - [Oberon](docs/md/Oberon.md) - The Oberon report in markdown format

## Structure

- [src](src/): Oberon sources for modules and the test suites.
- [examples](examples/): Simple examples to demonstrate API use
- [docs](docs/): OBNC API and API documentation for the implemented modules.

## Building

To build, issue the commands from the project root:

```sh
cd src
make -f Makefile
```

To build the examples, issue

```sh
cd src
make -f Makefile examples
```

The test binaries are generated in the `bin/` folder.


