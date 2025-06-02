MODULE Perceptron;
IMPORT Math, Out;

(** This module implements a simple perceptron model. *)
(** The perceptron uses a step activation function. *)

CONST
    MaxWeights* = 100; 
    ActivationThreshold* = 0.0;

TYPE
    Perceptron* = RECORD
        weights: ARRAY MaxWeights OF REAL;
        bias: REAL;
        learningRate: REAL;
        numWeights: INTEGER;
        isTrained: BOOLEAN
    END;

(** Initializes a perceptron with numInputs inputs and learning rate lr.  *)    
PROCEDURE Init*(VAR p: Perceptron; numInputs: INTEGER; lr: REAL) : BOOLEAN;
VAR 
    i: INTEGER;
    result: BOOLEAN;
BEGIN
    IF numInputs > MaxWeights THEN
        result := FALSE;
    ELSE
        p.numWeights := numInputs;
        i := 0;
        WHILE i < numInputs DO
            p.weights[i] := 0.0;
            INC(i);
        END;
        p.bias := 0.0;
        p.learningRate := lr;
        p.isTrained := FALSE;
        result := TRUE;
    END;
    RETURN result
END Init;

(** Activation function for the perceptron, using the Heaviside step function. *)
PROCEDURE Activate*(x: REAL): REAL;
VAR 
    result: REAL;
BEGIN
    IF x >= ActivationThreshold THEN
        result := 1.0;  (* Activation *)
    ELSE
        result := 0.0;  (* No activation *)
    END;
    RETURN result
END Activate;

(** Predict the output for given inputs using the perceptron. *)
PROCEDURE Predict*(p: Perceptron; inputs: ARRAY OF REAL): REAL;
VAR
    sum: REAL;
    i: INTEGER;
    result: REAL;
BEGIN
    IF ~p.isTrained THEN
        Out.String("Perceptron is not trained."); Out.Ln;
        result := 0.0; (* Return a default value if not trained *)
    ELSIF LEN(inputs) # p.numWeights THEN
        Out.String("Input size does not match perceptron weights."); Out.Ln;
        result := 0.0; (* Return a default value if input size is incorrect *)
    ELSE
        sum := 0.0;
        i := 0;
        WHILE i < LEN(inputs) DO 
            sum := sum + p.weights[i] * inputs[i];
            INC(i);
        END;
        sum := sum + p.bias;
        result := Activate(sum);
    END;
    RETURN result
END Predict;

(* NOTE: This training rule assumes a step activation function. *)
(* For other activations (e.g., sigmoid, tanh), the update rule must be adapted.*)
PROCEDURE Train(VAR p: Perceptron; inputs: ARRAY OF REAL; target: REAL);
VAR 
    output, error: REAL;
    i: INTEGER;
BEGIN
    output := Predict(p, inputs);
    error := target - output;
    
    (* Update weights and bias *)
    i := 0;
    WHILE i < LEN(inputs) DO
        p.weights[i] := p.weights[i] + p.learningRate * error * inputs[i];
        INC(i);
    END;
    p.bias := p.bias + p.learningRate * error;
    p.isTrained := TRUE;
END Train;

(** Train the perceptron with the provided data and targets for a specified number of epochs.*)
(** data: 2D array where each sub-array is an input vector.*)
(** targets: 1D array of target outputs corresponding to each input vector.*)
(** epochs: Number of times to iterate over the entire dataset.*)
PROCEDURE Fit*(VAR p: Perceptron; 
               data: ARRAY OF ARRAY OF REAL; 
               targets: ARRAY OF REAL; 
               epochs: INTEGER) : BOOLEAN;
VAR
    epoch, i: INTEGER;
    result: BOOLEAN;
BEGIN
    IF (LEN(data) = 0) OR (LEN(data[0]) # p.numWeights) THEN
        Out.String("Input size does not match perceptron weights."); Out.Ln;
        result := FALSE;
    ELSE
        result := TRUE;
        epoch := 0;
        WHILE epoch < epochs DO
            i := 0;
            WHILE i < LEN(data) DO
                Train(p, data[i], targets[i]);
                INC(i);
            END;
            INC(epoch);
        END;
    END;

    RETURN result
END Fit;

END Perceptron.
