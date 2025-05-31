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

PROCEDURE TestShiftLeft;
(* Test the Bitwise shift left operations *)
VAR pass: BOOLEAN;
    result: INTEGER;
BEGIN
    result := Bitwise.ShiftLeft(0FFFFH, 1);
    (* Out.Hex(result); *)
    (* Out.Ln; *)
    
    (* Check if the result is as expected *)
    (* 0FFH shifted left by 1 should be 0FEH *)
    pass := (result = 01FFFEH);
    WriteResult("TestShiftLeft", pass)
END TestShiftLeft;

PROCEDURE TestShiftRight;
(* Test the Bitwise shift right operations *)
VAR pass: BOOLEAN;
    result: INTEGER;
BEGIN
    result := Bitwise.ShiftRight(0FFFFH, 1);
    
    (* Check if the result is as expected *)
    (* 0FFH shifted right by 1 should be 07FH *)
    pass := (result = 07FFFH);
    WriteResult("TestShiftRight", pass)
END TestShiftRight;

PROCEDURE TestRotateLeft;
(* Test the Bitwise rotate left operations *)
VAR pass: BOOLEAN;
    result: INTEGER;
BEGIN
    result := Bitwise.RotateLeft(0FFFFH, 1);
    
    (* Check if the result is as expected *)
    pass := (result = 01FFFEH);
    WriteResult("TestRotateLeft", pass)
END TestRotateLeft;

PROCEDURE TestRotateRight;
(* Test the Bitwise rotate right operations *)
VAR pass: BOOLEAN;
    result: INTEGER;
BEGIN
    result := Bitwise.RotateRight(0FFFFH, 1);

    (* Check if the result is as expected *)
    pass := (result = 080007FFFH);
    WriteResult("TestRotateLeft", pass)
END TestRotateRight;

BEGIN
    TestAnd;
    TestOr;
    TestXor;
    TestNot;
    TestShiftLeft;
    TestShiftRight;
    TestRotateLeft;
    TestRotateRight
END TestBitwise.