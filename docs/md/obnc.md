OBNC-COMPILE(1)                                                          General Commands Manual                                                         OBNC-COMPILE(1)

NAME
       obnc-compile - compile an Oberon module to C

SYNOPSIS
       obnc-compile [-e | -l] INFILE
       obnc-compile (-h | -v)

DESCRIPTION
       obnc-compile  compiles  an  Oberon module to C. The input filename is expected to end with .obn, .Mod or .mod.  All output files (C implementation file, C header
       file, symbol file etc.) are stored in the subdirectory .obnc.

       The compiler accepts the Oberon language as defined in "The Programming Language Oberon", revision 2013-10-01 / 2016-05-03 (Oberon-07). The  module  SYSTEM  pro‐
       vides  the  generally applicable procedures plus VAL, as defined in the language report. The underscore character is also accepted as a word separator in identi‐
       fiers. The target language is ANSI C (C89).

       The generated C file uses the exception codes below. If an exception occurs the trap handler is called. By default it writes the exception code to  the  standard
       error stream and aborts the program.

       E1 = destination array too short for assignment
       E2 = array index out of bounds
       E3 = nil pointer dereference
       E4 = nil procedure variable call
       E5 = source in assignment is not an extension of target
       E6 = type guard failure
       E7 = unmatched expression in case statement
       E8 = assertion failure

OPTIONS
       -e     Create an entry point function (main).

       -h     Display help and exit.

       -l     Print names of imported modules to standard output and exit.

       -v     Display version and exit.

ENVIRONMENT
       OBNC_IMPORT_PATH
              See obnc-path(1)

AUTHOR
       Written by Karl Landström

SEE ALSO
       obnc(1), obnc-path(1)

                                                                                                                                                         OBNC-COMPILE(1)
OBNC(1)                                                                  General Commands Manual                                                                 OBNC(1)

NAME
       obnc - build an executable for an Oberon module

SYNOPSIS
       obnc [-o OUTFILE] [-v | -V] [-x] INFILE
       obnc (-h | -v)

DESCRIPTION
       obnc  builds  an  executable  file  for  an Oberon module. Before the module is compiled, object files for imported modules are recursively created or updated as
       needed. Oberon modules are first compiled to C with obnc-compile.  Each C file is then compiled to object code with an external C compiler. Finally,  the  object
       files  are  linked into an executable program. Oberon source filenames are expected to end with .obn, .Mod or .mod.  All output files except the final executable
       are stored in the subdirectory .obnc.

       If for any module M there exists a file named M.c in the same directory as the Oberon source file then M.c will be used as the input to the C compiler instead of
       the generated file .obnc/M.c.  This provides a mechanism to implement a module in C.

       For  any  module M, environment variables for the C compiler specific to M and environment variables for the linker can be defined in a file named M.env, located
       in the same directory as the Oberon source file.

OPTIONS
       -h     Display help and exit.

       -o OUTFILE
              Use pathname OUTFILE for the generated executable file.

       -v     Without argument, display version and exit. Otherwise, output progress of compiled modules.

       -V     Output progress of compiled modules with compiler and linker subcommands.

       -x     Compile and link modules from C source (if available) in a single command. When a program is cross-compiled, this option prevents using object files  com‐
              piled for the host system. It also prevents leaving behind object files which are incompatible with the host system.

ENVIRONMENT
       CC     Specifies the C compiler to use (default is cc).

       CFLAGS Options for the C compiler. The following constants can be customized with the flag -D name=value and are intended to be used with the option -x:

              OBNC_CONFIG_C_INT_TYPE
                     Controls the size of type INTEGER and SET. The value is OBNC_CONFIG_SHORT, OBNC_CONFIG_INT, OBNC_CONFIG_LONG or OBNC_CONFIG_LONG_LONG.

              OBNC_CONFIG_C_REAL_TYPE
                     Controls the size of type REAL. The value is OBNC_CONFIG_FLOAT, OBNC_CONFIG_DOUBLE or OBNC_CONFIG_LONG_DOUBLE.

              OBNC_CONFIG_NO_GC
                     Value 1 builds an executable without the garbage collector. Calls to NEW invokes the standard memory allocation functions in C instead. This option
                     can be used if the program does not use dynamic memory allocation or if the total size of the allocated memory is bounded.

              OBNC_CONFIG_TARGET_EMB
                     Value 1 builds an executable for a freestanding execution environment (embedded platform). With this option the C main function  takes  no  parame‐
                     ters. The garbage collector is disabled and any call to NEW is invalidated. The executable is not linked with the math library libm.

       LDFLAGS
              Additional options for the linker.

       LDLIBS Additional libraries to link with.

       OBNC_IMPORT_PATH
              See obnc-path(1)

EXAMPLES
   Getting Started
       In Oberon, the program to print "hello, world" is

              MODULE hello;

                     IMPORT Out;

              BEGIN
                     Out.String("hello, world");
                     Out.Ln
              END hello.

       Save the above module in a file named hello.obn and compile it with the command

              obnc hello.obn

       This will create an executable file named hello.  When you run hello with the command

              ./hello

       it should print

              hello, world

   Interfacing to C
       To implement a module M in C:

       1. Create a file named M.obn with the the exported declarations

       2. Create a file named MTest.obn which imports M (and preferably write unit tests for M)

       3. Build MTest with the command

              obnc MTest.obn

       4. Copy  the  generated file .obnc/M.c to the current directory. In M.c, delete the generator comment on the first line and change the path in the include direc‐
          tive from M.h to .obnc/M.h.

       5. Implement M.c.

       Note: The initialization function M__Init is called each time a client module imports M. Its statements should therefore be guarded with an  initialization  flag
       to make sure they are executed only once.

AUTHOR
       Written by Karl Landström

SEE ALSO
       obnc-compile(1), obnc-path(1)

                                                                                                                                                                 OBNC(1)
OBNC-PATH(1)                                                             General Commands Manual                                                            OBNC-PATH(1)

NAME
       obnc-path - print directory path for Oberon module

SYNOPSIS
       obnc-path [-v] MODULE
       obnc-path (-h | -v)

DESCRIPTION
       obnc-path  prints  the directory path for an Oberon module. For a module M, the printed path is the first directory found which contains either the Oberon source
       file, .obnc/M.sym or M.sym.

       First the current directory is searched. Then paths in OBNC_IMPORT_PATH are searched. Finally the default library directory in  the  OBNC  installation  path  is
       searched.

       For  each  path P, modules are searched both in P and in first-level subdirectories of P. Subdirectories represent individual libraries and are expected to be in
       lowercase. For the modules in a subdirectory L, only modules prefixed with L followed by an uppercase letter are searched. The other modules in L are  considered
       local to the library.

OPTIONS
       -h     Display help and exit.

       -v     Without argument, display version and exit. Otherwise, print each inspected directory path to standard output.

ENVIRONMENT
       OBNC_IMPORT_PATH
              List of directory paths to search Oberon modules in. Paths are separated with a colon on POSIX systems, and with a semicolon on MS Windows.

AUTHOR
       Written by Karl Landström

SEE ALSO
       obnc(1), obnc-compile(1)

                                                                                                                                                            OBNC-PATH(1)
