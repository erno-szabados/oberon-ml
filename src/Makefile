# Makefile for Oberon (obnc) project
OBNC=obnc
MODS=$(wildcard $(SRC)/*.Mod)
OBJS=$(MODS:.Mod=.o)

# List of test executables
TESTS=PerceptronTest MathTest RegressorTest

.PHONY: all clean tests

all: $(TESTS)

%: %.Mod $(OBJS)
	$(OBNC) -o $@ $<

tests: $(TESTS)
	@for t in $(TESTS); do echo "Running $$t..."; ./$$t; done

clean:
	rm -rf .obnc 
	rm -f PerceptronTest MathTest RegressorTest
	
