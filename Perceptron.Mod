MODULE Perceptron;
IMPORT Math;

  TYPE 
    Perceptron* = RECORD
      weights*: POINTER TO ARRAY OF REAL;
      bias*: REAL;
      learningRate*: REAL;
    END;

  PROCEDURE Init*(VAR p: Perceptron; numInputs: INTEGER; lr: REAL);
  VAR i : INTEGER;
  BEGIN
    NEW(p.weights, numInputs); (* Allocate memory for weights *)
    i := 0;
    WHILE i < numInputs DO
      p.weights[i] := 0.0; (* Initialize weights to 0 or random values *)
      INC(i);
    END;
    p.bias := 0.0;
    p.learningRate := lr;
  END Init;

  PROCEDURE Activate*(x: REAL): REAL;
  BEGIN
    (* Sigmoid activation function *)
    RETURN 1.0 / (1.0 + Math.exp(-x))
  END Activate;

  PROCEDURE Forward*(VAR p: Perceptron; inputs: ARRAY OF REAL): REAL;
    VAR
      sum: REAL;
      i: INTEGER;
  BEGIN
    sum := 0.0;
    i := 0; (* Initialize the counter *)
    WHILE i < LEN(inputs) DO (* Loop while the counter is less than the length *)
      sum := sum + p.weights[i] * inputs[i];
      INC(i); (* Increment the counter *)
    END;
    sum := sum + p.bias;
    RETURN Activate(sum);
  END Forward;

  PROCEDURE Train*(VAR p: Perceptron; inputs: ARRAY OF REAL; target: REAL);
    VAR 
      output, error, gradient: REAL;
      i: INTEGER;
  BEGIN
    output := Forward(p, inputs);
    error := target - output;
    
    (* Update weights and bias *)
    i := 0;
    WHILE i < LEN(inputs) DO
      gradient := error * p.learningRate * output * (1.0 - output) * inputs[i];
      p.weights[i] := p.weights[i] + gradient;
      INC(i);
    END;
    p.bias := p.bias + error * p.learningRate * output * (1.0 - output);
  END Train;

END Perceptron.
