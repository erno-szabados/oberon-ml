COMPILER=obnc
FLAGS=
SRC=src
BIN=bin
TEST=test

#OBNC_IMPORTS="/home/eszabados/workspace/oberon-ml/src"
OBNC_IMPORTS="src"


all: bitwise regressor perceptron knn utf8 utf8Strings

bitwise:
	OBNC_IMPORT_PATH=${OBNC_IMPORTS} ${COMPILER} ${TEST}/TestBitwise.mod ${FLAGS} -o ${BIN}/TestBitwise

regressor:
	OBNC_IMPORT_PATH=${OBNC_IMPORTS} ${COMPILER} ${TEST}/TestRegressor.mod ${FLAGS} -o ${BIN}/TestRegressor

perceptron:
	OBNC_IMPORT_PATH=${OBNC_IMPORTS} ${COMPILER} ${TEST}/TestPerceptron.mod ${FLAGS} -o ${BIN}/TestPerceptron

knn:
	OBNC_IMPORT_PATH=${OBNC_IMPORTS} ${COMPILER} ${TEST}/TestKnn.mod ${FLAGS} -o ${BIN}/TestKnn

utf8:
	OBNC_IMPORT_PATH=${OBNC_IMPORTS} ${COMPILER} ${TEST}/TestUtf8.mod ${FLAGS} -o ${BIN}/TestUtf8

utf8Strings:
	OBNC_IMPORT_PATH=${OBNC_IMPORTS} ${COMPILER} ${TEST}/TestUtf8Strings.mod ${FLAGS} -o ${BIN}/TestUtf8Strings

clean:
	rm -f ${BIN}/TestRegressor ${BIN}/TestPerceptron ${BIN}/TestKnn ${BIN}/TestUtf8 ${BIN}/TestBitwise ${BIN}/TestUtf8Strings
	rm -f *.o *.lst *.map *.sym *.dmp *.dbg *.sct *.symtab *.strtab *.rel
	rm -rf obj

.PHONY: regressor perceptron knn clean bitwise utf8 utf8Strings
