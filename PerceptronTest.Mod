MODULE PerceptronTest;

IMPORT Perceptron, Assert, Math, Out;

PROCEDURE TestInit*;
  VAR p: Perceptron.Perceptron; i: INTEGER; initializedCorrectly: BOOLEAN;
BEGIN
  Out.String("Testing Init..."); Out.Ln;
  Perceptron.Init(p, 3, 0.01);
  initializedCorrectly := TRUE;

  (* Check weights are initialized to 0 *)
  i := 0;
  WHILE  i < LEN(p.weights^) DO
    IF p.weights[i] # 0.0 THEN
      initializedCorrectly := FALSE;
    END;
    INC(i);
  END;

  (* Check bias and learning rate *)
  IF (p.bias # 0.0) OR (p.learningRate # 0.01) THEN
    (*Out.Real(p.bias, 10);Out.Ln;Out.Real(p.learningRate, 10);*)
    initializedCorrectly := FALSE;
  END;

  IF initializedCorrectly THEN
    Out.String("PASS: Init initializes perceptron correctly."); Out.Ln;
  ELSE
    Out.String("FAIL: Init does not initialize perceptron correctly."); Out.Ln;
  END;
END TestInit;

PROCEDURE TestForward*;
  VAR p: Perceptron.Perceptron; inputs: ARRAY 3 OF REAL; output: REAL;
BEGIN
  Out.String("Testing Forward..."); Out.Ln;
  Perceptron.Init(p, 3, 0.01);

  (* Set weights and bias manually for testing *)
  p.weights[0] := 0.5; p.weights[1] := 0.5; p.weights[2] := 0.5;
  p.bias := 0.1;

  (* Define input and expected output *)
  inputs[0] := 1.0; inputs[1] := 1.0; inputs[2] := 1.0;
  output := Perceptron.Forward(p, inputs);

  (* Expected output: Activate(0.5*1.0 + 0.5*1.0 + 0.5*1.0 + 0.1) = Activate(1.6) *)
  Assert.Equal(output, 1.0 / (1.0 + Math.exp(-1.6)), 1.0E-6, "Forward computes weighted sum and activation correctly.");
END TestForward;

PROCEDURE TestTrain*;
  VAR p: Perceptron.Perceptron; inputs: ARRAY 3 OF REAL; target, outputBefore, outputAfter: REAL;
BEGIN
  Out.String("Testing Train..."); Out.Ln;
  Perceptron.Init(p, 3, 0.01);

  (* Set weights and bias manually for testing *)
  p.weights[0] := 0.5; p.weights[1] := 0.5; p.weights[2] := 0.5;
  p.bias := 0.1;

  (* Define input and target *)
  inputs[0] := 1.0; inputs[1] := 1.0; inputs[2] := 1.0;
  target := 0.0;

  (* Compute initial output *)
  outputBefore := Perceptron.Forward(p, inputs);

  (* Train the perceptron *)
  Perceptron.Train(p, inputs, target);

  (* Compute output after training *)
  outputAfter := Perceptron.Forward(p, inputs);

  (* Check that the output moved closer to the target *)
  IF ABS(outputAfter - target) < ABS(outputBefore - target) THEN
    Out.String("PASS: Train reduces error between output and target."); Out.Ln;
  ELSE
    Out.String("FAIL: Train does not reduce error between output and target."); Out.Ln;
  END;
END TestTrain;

PROCEDURE RunTests*;
BEGIN
  TestInit;
  TestForward;
  TestTrain;
END RunTests;


BEGIN
  RunTests;
END PerceptronTest.
