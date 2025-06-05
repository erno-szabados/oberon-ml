COMPILER=obnc
FLAGS= 
SRC = ../src
BIN = ../bin
TEST = ../test
IMPORT_PATH = "../src"

# Find all .mod files in the test directory (without extension)
TEST_MODULES := $(basename $(notdir $(wildcard $(TEST)/*.mod)))

# Build all test binaries
all: $(addprefix $(BIN)/, $(TEST_MODULES))

# Pattern rule to build each test binary from its .mod file
$(BIN)/%: $(TEST)/%.mod
	OBNC_IMPORT_PATH=${IMPORT_PATH} ${COMPILER} $< ${FLAGS} -o $@

clean:
	rm -f ${BIN}/*
	rm -rf ${SRC}/.obnc
	rm -rf ${TEST}/.obnc
	rm -f *.o
	rm -f *.lst
	rm -f *.map
	rm -f *.sym
	rm -f *.dmp
	rm -f *.dbg
	rm -f *.sct
	rm -f *.symtab
	rm -f *.strtab
	rm -f *.rel
	rm -rf obj
	
.PHONY: clean all
