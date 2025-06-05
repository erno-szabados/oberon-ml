MODULE TestRandom;
IMPORT Random, Out;

PROCEDURE WriteResult(testName: ARRAY OF CHAR; result: BOOLEAN);
BEGIN
    Out.String(testName);
    IF result THEN
        Out.String(" passed.");
    ELSE
        Out.String(" failed.");
    END;
    Out.Ln;
END WriteResult;

PROCEDURE TestInitAndNext;
VAR pass: BOOLEAN; i, first, second: INTEGER;
BEGIN
    pass := TRUE;
    Random.Init(12345);
    first := Random.Next();
    Random.Init(12345);
    second := Random.Next();
    IF first # second THEN pass := FALSE END;
    WriteResult("TestInitAndNext", pass)
END TestInitAndNext;

PROCEDURE TestRepeatability;
VAR pass: BOOLEAN; i: INTEGER; seq1, seq2: ARRAY 5 OF INTEGER;
BEGIN
    pass := TRUE;
    Random.Init(42);
    FOR i := 0 TO 4 DO seq1[i] := Random.Next() END;
    Random.Init(42);
    FOR i := 0 TO 4 DO seq2[i] := Random.Next() END;
    FOR i := 0 TO 4 DO IF seq1[i] # seq2[i] THEN pass := FALSE END END;
    WriteResult("TestRepeatability", pass)
END TestRepeatability;

PROCEDURE TestRange;
VAR pass: BOOLEAN; i, x: INTEGER;
BEGIN
    pass := TRUE;
    Random.Init(1);
    FOR i := 0 TO 9 DO
        x := Random.Next();
        IF (x <= 0) OR (x >= Random.Modulus) THEN pass := FALSE END
    END;
    WriteResult("TestRange", pass)
END TestRange;

PROCEDURE TestNextReal;
VAR pass: BOOLEAN; i: INTEGER; r: REAL;
BEGIN
    pass := TRUE;
    Random.Init(7);
    FOR i := 0 TO 9 DO
        r := Random.NextReal();
        IF (r <= 0.0) OR (r >= 1.0) THEN pass := FALSE END
    END;
    WriteResult("TestNextReal", pass)
END TestNextReal;

BEGIN
    TestInitAndNext;
    TestRepeatability;
    TestRange;
    TestNextReal
END TestRandom.
