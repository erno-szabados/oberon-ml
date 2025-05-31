MODULE TestBitwise;
IMPORT Bitwise, Out;

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

PROCEDURE TestAnd;
(* Test the Bitwise.And procedure *)
VAR
    pass: BOOLEAN;
    a, b, result: INTEGER;
BEGIN  
    pass := TRUE;
    a := 0FFH;
    b := 0AAH;
    result := Bitwise.And(a, b);
    
    IF result # 0AAH THEN
        pass := FALSE;
    END;

    WriteResult("TestAnd", pass);
END TestAnd;

PROCEDURE TestOr;
(* Test the Bitwise.Or procedure *)
VAR
    pass: BOOLEAN;
    a, b, result: INTEGER;
BEGIN
    pass := TRUE;
    a := 0FFH;
    b := 0AAH;
    result := Bitwise.Or(a, b);
    
    IF result # 0FFH THEN
        pass := FALSE;
    END;

    WriteResult("TestOr", pass);
END TestOr;

PROCEDURE TestXor;
(* Test the Bitwise.Xor procedure *)
VAR
    pass: BOOLEAN;
    a, b, result: INTEGER;
BEGIN
    pass := TRUE;
    a := 0FFH;
    b := 0AAH;
    result := Bitwise.Xor(a, b);
    
    IF result # 055H THEN
        pass := FALSE;
    END;

    WriteResult("TestXor", pass);
END TestXor;

PROCEDURE TestNot;
(* Test the Bitwise.Not procedure *)
VAR
    pass: BOOLEAN;
    a, result: INTEGER;
BEGIN
    pass := TRUE;
    a := 00H;
    result := Bitwise.Not(a);
    
    IF result # 0FFH THEN
        pass := FALSE;
    END;

    WriteResult("TestNot", pass);
END TestNot;

BEGIN
    TestAnd;
    TestOr;
    TestXor;
    TestNot;
END TestBitwise.