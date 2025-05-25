MODULE TestPerceptron;

IMPORT Out, Perceptron;

PROCEDURE Test*(): BOOLEAN;
(* Test the Perceptron module by initializing, training, and predicting values. *)
VAR
    p: Perceptron.Perceptron;
    data: ARRAY 4 OF ARRAY 2 OF REAL;
    targets: ARRAY 4 OF REAL;
    numInputs: INTEGER;
    epochs: INTEGER;
    prediction: REAL;
    result: BOOLEAN;
    testInput: ARRAY 2 OF REAL;
    i: INTEGER;
    allCorrect: BOOLEAN;
BEGIN
    numInputs := 2;
    epochs := 5;
    result := FALSE;

    (* Example: AND logic gate *)
    data[0][0] := 0.0; data[0][1] := 0.0; targets[0] := 0.0;
    data[1][0] := 0.0; data[1][1] := 1.0; targets[1] := 0.0;
    data[2][0] := 1.0; data[2][1] := 0.0; targets[2] := 0.0;
    data[3][0] := 1.0; data[3][1] := 1.0; targets[3] := 1.0;

    IF Perceptron.Init(p, numInputs, 0.1) THEN
        result := Perceptron.Fit(p, data, targets, epochs);

        allCorrect := TRUE;
        FOR i := 0 TO 3 DO
            testInput[0] := data[i][0];
            testInput[1] := data[i][1];
            prediction := Perceptron.Predict(p, testInput);

            Out.String("Prediction for input [");
            Out.Real(testInput[0], 1);
            Out.String(", ");
            Out.Real(testInput[1], 1);
            Out.String("]: ");
            Out.Real(prediction, 1);
            Out.String(" (expected: ");
            Out.Real(targets[i], 1);
            Out.String(")");
            Out.Ln;

            IF prediction # targets[i] THEN
                allCorrect := FALSE;
            END;
        END;

        result := allCorrect;
    ELSE
        Out.String("Failed to initialize perceptron.");
        Out.Ln;
        result := FALSE;
    END;
    RETURN result
END Test;

BEGIN
    IF Test() THEN
        Out.String("Perceptron module test passed.");
        Out.Ln;
    ELSE
        Out.String("Perceptron module test failed.");
        Out.Ln;
    END
END TestPerceptron.