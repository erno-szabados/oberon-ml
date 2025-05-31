MODULE TestUtf8;

IMPORT Out, Utf8;

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

PROCEDURE TestCharLen;
(* Test with valid characters *)
VAR
  pass: BOOLEAN;
  result: INTEGER;
BEGIN
  pass := FALSE;
  (* TODO*)
  result := Utf8.CharLen("A"); (* 1 byte *)
  WriteResult("TestCharLen", pass);
END TestCharLen;

BEGIN
    TestCharLen;
END TestUtf8.
