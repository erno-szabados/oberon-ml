MODULE LinearRegressor;

IMPORT Out;

(* This module implements a simple linear regression model. *)
(* It allows for training with a set of data points and making predictions. *)

CONST 
    MaxSamples* = 100; (* Maximum number of samples for training *)

TYPE
    Regressor* = RECORD
        slope: REAL;
        intercept: REAL;
        isTrained: BOOLEAN
    END;

PROCEDURE Init*(VAR reg: Regressor);
(* Initialize a new linear regressor with default values. *)
(* slope = 0.0, intercept = 0.0, isTrained = FALSE *)
BEGIN
    reg.slope := 0.0;
    reg.intercept := 0.0;
    reg.isTrained := FALSE;
END Init;

PROCEDURE Train*(VAR reg: Regressor; xData: ARRAY OF REAL; yData: ARRAY OF REAL; numSamples: INTEGER) : BOOLEAN;
(* Train the linear regressor using the provided data points. *)
(* This procedure calculates the slope and intercept based on the input data. *)
VAR
    sumX, sumY, sumXY, sumX2: REAL;
    i: INTEGER;
    result: BOOLEAN;
BEGIN
    IF  (numSamples <= 0) OR 
        (numSamples > MaxSamples) OR 
        (LEN(xData) < numSamples) OR 
        (LEN(yData) < numSamples) THEN
        Out.String("Error: Invalid input data for training.");
        Out.Ln;
        result := FALSE;
    ELSE
        sumX := 0.0;
        sumY := 0.0;
        sumXY := 0.0;
        sumX2 := 0.0;

        FOR i := 0 TO numSamples - 1 DO
            sumX := sumX + xData[i];
            sumY := sumY + yData[i];
            sumXY := sumXY + (xData[i] * yData[i]);
            sumX2 := sumX2 + (xData[i] * xData[i]);
        END;

        IF (FLT(numSamples) * sumX2 - sumX * sumX) = 0.0 THEN
            Out.String("Error: Cannot compute slope (division by zero).");
            Out.Ln;
            result := FALSE;
        ELSE
            reg.slope := (FLT(numSamples) * sumXY - sumX * sumY) / (FLT(numSamples) * sumX2 - sumX * sumX);
            reg.intercept := (sumY - reg.slope * sumX) / FLT(numSamples);
            result := TRUE;
        END;
    END;
    reg.isTrained := result;
   
    RETURN result
END Train;

PROCEDURE Predict*(reg: Regressor; xInput: REAL): REAL;
(* Predict the output for a given input using the trained regressor. *)
(* If the regressor is not trained, it returns 0.0. *)
VAR 
    result: REAL;
BEGIN
    IF (reg.isTrained = FALSE) THEN
        Out.String("Error: Regressor not trained. Returning 0.0."); Out.Ln;
        result := 0.0;
    ELSE 
        result := (reg.slope * xInput) + reg.intercept; 
    END;
    RETURN result
END Predict;

PROCEDURE GetSlope*(reg: Regressor): REAL;
(* Get the slope of the trained regressor. *)
(* If the regressor is not trained, it returns 0.0. *)
VAR 
    result: REAL;
BEGIN
    IF (reg.isTrained = FALSE) THEN
        result := 0.0;
    ELSE 
        result := reg.slope; 
    END;
    RETURN result
END GetSlope;

PROCEDURE GetIntercept*(reg: Regressor): REAL;
(* Get the intercept of the trained regressor. *)
(* If the regressor is not trained, it returns 0.0. *)
VAR 
    result: REAL;
BEGIN
    IF (reg.isTrained = FALSE) THEN
        result := 0.0;
    ELSE 
        result := reg.intercept; 
    END;
    RETURN result
END GetIntercept;

END LinearRegressor.