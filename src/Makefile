all: regressor perceptron knn

regressor:
	akron64 TestRegressor.ob07 linux64exe -out bin/TestRegressor -stk 2

perceptron:
	akron64 TestPerceptron.ob07 linux64exe -out bin/TestPerceptron -stk 2

knn:
	akron64 TestKnn.ob07 linux64exe -out bin/TestKnn -stk

clean:
	rm -f bin/TestRegressor bin/TestPerceptron bin/TestKnn
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
	
.PHONY: regressor perceptron knn clean 