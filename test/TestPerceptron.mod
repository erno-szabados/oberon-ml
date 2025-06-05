(** TestPerceptron.Mod - Tests for Perceptron.Mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE TestPerceptron;

IMPORT Random, Perceptron, Tests;

VAR
    ts: Tests.TestSet;

PROCEDURE TestAndGate*(): BOOLEAN;
(* Test the Perceptron module by initializing, training, and predicting values for AND logic gate. *)
VAR
    p: Perceptron.Perceptron;
    data: ARRAY 4 OF ARRAY 2 OF REAL;
    targets: ARRAY 4 OF REAL;
    numInputs, epochs, i: INTEGER;
    prediction: REAL;
    ok, test: BOOLEAN;
    testInput: ARRAY 2 OF REAL;
BEGIN
    test := TRUE;
    numInputs := 2;
    epochs := 50;

    (* Example: AND logic gate *)
    data[0][0] := 0.0; data[0][1] := 0.0; targets[0] := 0.0;
    data[1][0] := 0.0; data[1][1] := 1.0; targets[1] := 0.0;
    data[2][0] := 1.0; data[2][1] := 0.0; targets[2] := 0.0;
    data[3][0] := 1.0; data[3][1] := 1.0; targets[3] := 1.0;

    ok := Perceptron.Init(p, numInputs, 0.02);
    Tests.ExpectedBool(TRUE, ok, "Perceptron.Init failed", test);

    IF ok THEN
        ok := Perceptron.Fit(p, data, targets, epochs);
        Tests.ExpectedBool(TRUE, ok, "Perceptron.Fit failed", test);

        FOR i := 0 TO 3 DO
            testInput[0] := data[i][0];
            testInput[1] := data[i][1];
            ok := Perceptron.Predict(p, testInput, prediction);
            Tests.ExpectedBool(TRUE, ok, "Perceptron.Predict failed", test);
            Tests.ExpectedReal(targets[i], prediction, "Perceptron prediction incorrect", test);
        END;
    END;
    RETURN test
END TestAndGate;

BEGIN
    Random.Init(42);
    Tests.Init(ts, "Perceptron Tests");
    Tests.Add(ts, TestAndGate);
    ASSERT(Tests.Run(ts));
END TestPerceptron.