# Copilot Instructions for the Oberon-ML Project

- **Project Goal:** Machine learning and related utility functions in Oberon-07. 
- **Language:** Oberon-07
- **Constraints:** 
  - Only fixed-size arrays are allowed by the language. 
  - Open array parameters are allowed as procedure parameters only.
  - Return is only allowed as the last statement in a procedure. Use a `result` variable for returning values.
  - For bitwise operations, use our own implementation from `Bitwise.mod`.
  - Use VAR in procedure parameters for mutable variables.
  - SYSTEM.VAL() does not allow procedure parameters, use a local variable to convert types.
  - Language specification is available in `docs/md/Oberon.md`
  - Collections documentation is available in `docs/md/Collections.md`
  - Compiler tools description for obnc is available in `docs/md/obnc.md`
  **Best Practices**
  - Functions and procedures should be clear, concise, and well-structured.
  - Use modules to encapsulate functionality. Use opaque pointers to expose necessary types. Hide implementation details.
  - Use helper functions to avoid code duplication.
  - Use meaningful names for modules, procedures, and variables.
  - Use PascalCase for module names, constants and procedures and camelCase for variables.
  - Export only what is necessary; keep the interface clean.

## Building

- The project uses **GNU Make** for building.
- New modules and tests **must be added to the Makefile**.
- Tests can be built in the `src` folder with the `make -f Makefile all` target.
- The test XXX can be built in the `src` folder with the `make -f Makefile ../bin/TestXXX` target.

## Testing

- Place unit tests in the `test/` directory, using idiomatic Oberon-07 test patterns.
- Reference style and approach: see `test/TestUTF8.mod`.
- Tests should be granular enough to help identify problems, but avoid excess verbosity.

## Documentation

- Oberon-07 standard libraries provided by obnc (Oakwood API and extensions) are documented in `docs/obnc/*.def`.
- Our own API is documented in `docs/api/*.def`.
- Exported procedures documentation comment lines start with `(**` and end with `*)`, so obncdoc finds them.
- Internal procedures documentation comment lines start with `(*` and end with `*)`, so they are not included in the API documentation.
- Documentation is generated using `obncdoc` and placed in the `docs/` directory.
- The header should contain a copyright notice for the 3 clause BSD license, the module name, a brief description, and the author.