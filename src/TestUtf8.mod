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

PROCEDURE CheckIsValid(testName : ARRAY OF CHAR; buf : ARRAY OF CHAR; len : INTEGER; expected : BOOLEAN);
VAR 
  pass : BOOLEAN;
BEGIN
  pass := Utf8.IsValid(buf, len) = expected;
  WriteResult(testName, pass);
END CheckIsValid;

PROCEDURE TestIsValid;
VAR
  buf : ARRAY 7 OF CHAR;
BEGIN
   (* Valid 1-byte ASCII *)
  buf[0] := CHR(65); buf[1] := CHR(0);
  CheckIsValid("IsValid: ASCII", buf, 1, TRUE);

  (* Valid 2-byte UTF-8: U+00A2 (¢) = C2 A2 *)
  buf[0] := CHR(0C2H); buf[1] := CHR(0A2H);
  CheckIsValid("IsValid: 2-byte", buf, 2, TRUE);

  (* Valid 3-byte UTF-8: U+20AC (€) = E2 82 AC *)
  buf[0] := CHR(0E2H); buf[1] := CHR(082H); buf[2] := CHR(0ACH);
  CheckIsValid("IsValid: 3-byte", buf, 3, TRUE);

  (* Valid 4-byte UTF-8: U+1F600 (😀) = F0 9F 98 80 *)
  buf[0] := CHR(0F0H); buf[1] := CHR(09FH); buf[2] := CHR(098H); buf[3] := CHR(080H);
  CheckIsValid("IsValid: 4-byte", buf, 4, TRUE);

   (* Invalid: incomplete 2-byte sequence *)
  buf[0] := CHR(0C2H); buf[1] := CHR(0);
  CheckIsValid("IsValid: Incomplete 2-byte", buf, 1, FALSE);

  (* Invalid: overlong encoding for ASCII 'A' (should be 1 byte, not 2) *)
  buf[0] := CHR(0C1H); buf[1] := CHR(0A1H); buf[2] := CHR(0);
  CheckIsValid("IsValid: Overlong ASCII", buf, 2, FALSE);

  (* Invalid: incomplete 3-byte sequence *)
  buf[0] := CHR(0E2H); buf[1] := CHR(082H); buf[2] := CHR(0);
  CheckIsValid("IsValid: Incomplete 3-byte", buf, 2, FALSE);

  (* Invalid: incomplete 4-byte sequence *)
  buf[0] := CHR(0F0H); buf[1] := CHR(09FH); buf[2] := CHR(098H); buf[3] := CHR(0);
  CheckIsValid("IsValid: Incomplete 4-byte", buf, 3, FALSE);

  (* Valid: mixed valid sequence *)
  buf[0] := CHR(65); (* 'A' *)
  buf[1] := CHR(0C2H); buf[2] := CHR(0A2H); (* ¢ *)
  buf[3] := CHR(0E2H); buf[4] := CHR(082H); buf[5] := CHR(0ACH); (* € *) 
  buf[6] := CHR(0);
  CheckIsValid("IsValid: Mixed valid", buf, 6, TRUE);

END TestIsValid;

BEGIN
    TestCharLen;
    TestHasBOM;
    TestIsValid;
END TestUtf8.
