(** TestRegressor.Mod - Tests for Regressor.Mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE TestRegressor;

IMPORT LinearRegressor, Tests;

VAR
    ts: Tests.TestSet;

PROCEDURE TestTrainAndPredict*(): BOOLEAN;
(* Test the LinearRegressor module by initializing, training, and predicting values. *)
VAR
    reg: LinearRegressor.Regressor;
    xData: ARRAY LinearRegressor.MaxSamples OF REAL;
    yData: ARRAY LinearRegressor.MaxSamples OF REAL;
    numSamples: INTEGER;
    prediction: REAL;
    trained: BOOLEAN;
    test: BOOLEAN;
    testInput: REAL;
BEGIN
    test := TRUE;
    LinearRegressor.Init(reg);

    (* Sample data for training *)
    xData[0] := 1.0; xData[1] := 2.0; xData[2] := 3.0;
    yData[0] := 2.0; yData[1] := 4.0; yData[2] := 6.0;
    numSamples := 3;

    (* Train the regressor *)
    trained := LinearRegressor.Train(reg, xData, yData, numSamples);
    Tests.ExpectedBool(TRUE, trained, "LinearRegressor.Train failed", test);

    IF trained THEN
        (* Predict a value *)
        testInput := 6.0;
        prediction := LinearRegressor.Predict(reg, testInput);
        (* For y = 2x, prediction for 6.0 should be close to 12.0 *)
        Tests.ExpectedReal(12.0, prediction, "LinearRegressor.Predict failed", test);
    END;

    RETURN test
END TestTrainAndPredict;

BEGIN
    Tests.Init(ts, "LinearRegressor Tests");
    Tests.Add(ts, TestTrainAndPredict);
    ASSERT(Tests.Run(ts));
END TestRegressor.