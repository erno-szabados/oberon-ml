(** MutualRecursion.mod - Demonstrates mutual recursive function invocation.

This example shows how to implement mutual recursion in Oberon-07 using
procedure types, since forward declarations are not allowed for procedures.

The example implements two mutually recursive functions:
- IsEven: returns TRUE if a number is even
- IsOdd: returns TRUE if a number is odd

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE MutualRecursion;

IMPORT Out;

TYPE
    (* Procedure type for checking if a number is odd *)
    IsOddProc* = PROCEDURE(n: INTEGER): BOOLEAN;

VAR
    (* Global procedure variable to enable mutual recursion *)
    IsOdd: IsOddProc;

(** Check if a number is even using mutual recursion *)
PROCEDURE IsEven*(n: INTEGER): BOOLEAN;
VAR result: BOOLEAN;
BEGIN
    IF n = 0 THEN
        result := TRUE
    ELSIF n = 1 THEN
        result := FALSE
    ELSE
        result := IsOdd(n - 1)
    END;
    RETURN result
END IsEven;

(** Check if a number is odd using mutual recursion *)
PROCEDURE IsOddImpl(n: INTEGER): BOOLEAN;
VAR result: BOOLEAN;
BEGIN
    IF n = 0 THEN
        result := FALSE
    ELSIF n = 1 THEN
        result := TRUE
    ELSE
        result := IsEven(n - 1)
    END;
    RETURN result
END IsOddImpl;

(** Demonstrate the mutual recursion with test cases *)
PROCEDURE Demo*;
VAR i: INTEGER;
BEGIN
    Out.String("Mutual Recursion Example: Even/Odd Checker"); Out.Ln;
    Out.String("========================================"); Out.Ln;
    Out.Ln;
    
    (* Test numbers from 0 to 10 *)
    FOR i := 0 TO 10 DO
        Out.Int(i, 2);
        Out.String(" is ");
        IF IsEven(i) THEN
            Out.String("even")
        ELSE
            Out.String("odd")
        END;
        Out.Ln
    END;
    
    Out.Ln;
    Out.String("Testing larger numbers:"); Out.Ln;
    
    (* Test some larger numbers *)
    Out.String("100 is "); 
    IF IsEven(100) THEN Out.String("even") ELSE Out.String("odd") END;
    Out.Ln;
    
    Out.String("101 is "); 
    IF IsEven(101) THEN Out.String("even") ELSE Out.String("odd") END;
    Out.Ln;
    
    Out.String("999 is "); 
    IF IsEven(999) THEN Out.String("even") ELSE Out.String("odd") END;
    Out.Ln;
    
    Out.String("1000 is "); 
    IF IsEven(1000) THEN Out.String("even") ELSE Out.String("odd") END;
    Out.Ln
END Demo;

BEGIN
    (* Initialize the procedure variable to enable mutual recursion *)
    IsOdd := IsOddImpl;
    
    (* Run the demonstration *)
    Demo
END MutualRecursion.
