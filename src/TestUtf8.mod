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
VAR
  pass: BOOLEAN;
BEGIN
  pass := TRUE;
  (* TODO*)
  IF Utf8.CharLen("A") # 1 THEN
    pass := FALSE;
  END;

  IF Utf8.CharLen(CHR(0C2H)) # 2 THEN
    pass := FALSE;
  END;

  IF Utf8.CharLen(CHR(0E0H)) # 3 THEN
    pass := FALSE;
  END;

  IF Utf8.CharLen(CHR(0F0H)) # 4 THEN
    pass := FALSE;
  END;

  (* Invalid first byte *)
  IF Utf8.CharLen(CHR(0FFH)) # 0 THEN
    pass := FALSE;
  END;
  
  WriteResult("TestCharLen", pass)
END TestCharLen;

PROCEDURE TestHasBOM;
VAR
  buf: ARRAY 7 OF CHAR;
  pass: BOOLEAN;
BEGIN
  pass := TRUE;
  (* Valid: EF BB BF *)
  buf[0] := CHR(0EFH); buf[1] := CHR(0BBH); buf[2] := CHR(0BFH);
  IF Utf8.HasBOM(buf, 3) # TRUE THEN
    pass := FALSE;
  END;

  (* Too short *)
  IF Utf8.HasBOM(buf, 2) # FALSE THEN
    pass := FALSE;
  END;

  (* Valid, with extra data *)
  buf[3] := CHR(65); 
  IF Utf8.HasBOM(buf, 4) # TRUE THEN
    pass := FALSE;
  END;

  (* Wrong BOM sequence *)
  buf[3] := CHR(0BCH); 
  IF Utf8.HasBOM(buf, 3) # TRUE THEN
    pass := FALSE;
  END;

  (* ASCII: "ABC" *)
  buf[0] := CHR(65); buf[1] := CHR(66); buf[2] := CHR(67);
  IF Utf8.HasBOM(buf, 3) # FALSE THEN
    pass := FALSE;
  END;

  WriteResult("TestHasBOM", pass)
END TestHasBOM;

BEGIN
    TestCharLen;
    TestHasBOM;
END TestUtf8.
