MODULE RegressorTest;

IMPORT Out, LinearRegressor;

PROCEDURE Test*(): BOOLEAN;
(* Test the Regressor module by initializing, training, and predicting values. *)
VAR
    reg: LinearRegressor.Regressor;
    xData: ARRAY LinearRegressor.MaxSamples OF REAL;
    yData: ARRAY LinearRegressor.MaxSamples OF REAL;
    numSamples: INTEGER;
    prediction: REAL;
    trained: BOOLEAN;
    result: BOOLEAN;
    testInput: REAL;
BEGIN
    LinearRegressor.Init(reg);
    
    (* Sample data for training *)
    xData[0] := 1.0; xData[1] := 2.0; xData[2] := 3.0;
    yData[0] := 2.0; yData[1] := 4.0; yData[2] := 6.0;

    (* Number of samples to train on *)
    numSamples := 3;
    result := FALSE;

    (* Train the regressor *)
    trained := LinearRegressor.Train(reg, xData, yData, numSamples);
    
    IF trained THEN
        (* Predict a value *)
        testInput := 6.0;
        prediction := LinearRegressor.Predict(reg, testInput);
        Out.String("Prediction for input: ");
        Out.Real(testInput, 4);
        Out.String(" is: ");
        Out.Real(prediction, 4);
        Out.Ln;
        result := TRUE;
    ELSE
        result := FALSE; (* Training failed *)
    END;
    RETURN result
END Test;

BEGIN
    (* Run the test procedure *)
    IF Test() THEN
        (* Output success message *)
        Out.String("Regressor module test passed.");
        Out.Ln;
    ELSE
        (* Output failure message *)
        Out.String("Regressor module test failed.");
        Out.Ln;
    END
END RegressorTest.
