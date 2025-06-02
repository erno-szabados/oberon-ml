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
  buf[0] := CHR(65);
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

PROCEDURE CheckEncode(testName: ARRAY OF CHAR; codePoint: INTEGER; expected: ARRAY OF CHAR; expectedLen: INTEGER; expectedResult: BOOLEAN);
VAR
  buf: ARRAY 7 OF CHAR;
  bytesWritten: INTEGER;
  pass, result: BOOLEAN;
  i: INTEGER;
BEGIN
  result := Utf8.Encode(codePoint, buf, 0, bytesWritten);
  pass := (result = expectedResult) & (bytesWritten = expectedLen);
  IF pass & expectedResult THEN
    FOR i := 0 TO expectedLen - 1 DO
      IF buf[i] # expected[i] THEN pass := FALSE; END;
    END;
  END;
  WriteResult(testName, pass);
END CheckEncode;

PROCEDURE TestEncode;
VAR
  smallBuf : ARRAY 2 OF CHAR;
  buf: ARRAY 4 OF CHAR;
  bytesWritten: INTEGER;
  result: BOOLEAN;
BEGIN
  (* 1-byte ASCII: U+0041 'A' *)
  buf[0] := CHR(65); buf[1] := CHR(0); buf[2] := CHR(0); buf[3] := CHR(0);
  CheckEncode("Encode: ASCII A", 65, buf, 1, TRUE);

  (* 2-byte: U+00A2 (¢) = C2 A2 *)
  buf[0] := CHR(0C2H); buf[1] := CHR(0A2H);
  CheckEncode("Encode: U+00A2", 162, buf, 2, TRUE);

  (* 3-byte: U+20AC (€) = E2 82 AC *)
  buf[0] := CHR(0E2H); buf[1] := CHR(082H); buf[2] := CHR(0ACH);
  CheckEncode("Encode: U+20AC", 8364, buf, 3, TRUE);

  (* 4-byte: U+1F600 (😀) = F0 9F 98 80 *)
  buf[0] := CHR(0F0H) ; buf[1] :=  CHR(09FH) ; buf[2] :=  CHR(098H) ; buf[3] :=  CHR(080H);
  CheckEncode("Encode: U+1F600", 128512, buf, 4, TRUE);

  (* Invalid: code point > U+10FFFF *)
  CheckEncode("Encode: Invalid > U+10FFFF", 1114112, "", 0, FALSE);

  (* Invalid: buffer too small for 4-byte sequence *)
  result := Utf8.Encode(128512, smallBuf, 0, bytesWritten);
  WriteResult("Encode: Buffer too small", (result = FALSE) & (bytesWritten = 0));
 
END TestEncode;

PROCEDURE CheckNextChar(testName: ARRAY OF CHAR; VAR buf: ARRAY OF CHAR; startIdx: INTEGER; expectedCodePoint: INTEGER; expectedNextIdx: INTEGER; expectedResult: BOOLEAN);
VAR
  idx, codePoint: INTEGER;
  result, pass: BOOLEAN;
BEGIN
  idx := startIdx;
  result := Utf8.NextChar(buf, idx, codePoint);
  pass := (result = expectedResult) & 
          ((~result) OR ((codePoint = expectedCodePoint) & (idx = expectedNextIdx)));
  WriteResult(testName, pass);
END CheckNextChar;

PROCEDURE TestNextChar;
VAR
  buf: ARRAY 8 OF CHAR;
BEGIN
  (* ASCII: "A" *)
  buf[0] := CHR(65);
  CheckNextChar("NextChar: ASCII", buf, 0, 65, 1, TRUE);

  (* 2-byte: U+00A2 (¢) = C2 A2 *)
  buf[0] := CHR(0C2H); buf[1] := CHR(0A2H);
  CheckNextChar("NextChar: 2-byte", buf, 0, 162, 2, TRUE);

  (* 3-byte: U+20AC (€) = E2 82 AC *)
  buf[0] := CHR(0E2H); buf[1] := CHR(082H); buf[2] := CHR(0ACH);
  CheckNextChar("NextChar: 3-byte", buf, 0, 8364, 3, TRUE);

  (* 4-byte: U+1F600 (😀) = F0 9F 98 80 *)
  buf[0] := CHR(0F0H); buf[1] := CHR(09FH); buf[2] := CHR(098H); buf[3] := CHR(080H);
  CheckNextChar("NextChar: 4-byte", buf, 0, 128512, 4, TRUE);

  (* Mixed: "A" + "¢" + "€" + "😀" *)
  buf[0] := CHR(65); (* 'A' *)
  buf[1] := CHR(0C2H); buf[2] := CHR(0A2H); (* ¢ *)
  buf[3] := CHR(0E2H); buf[4] := CHR(082H); buf[5] := CHR(0ACH); (* € *)
  buf[6] := CHR(0F0H); buf[7] := CHR(09FH); (* partial 4-byte *)
  CheckNextChar("NextChar: Mixed ASCII", buf, 0, 65, 1, TRUE);
  CheckNextChar("NextChar: Mixed 2-byte", buf, 1, 162, 3, TRUE);
  CheckNextChar("NextChar: Mixed 3-byte", buf, 3, 8364, 6, TRUE);
  CheckNextChar("NextChar: Mixed incomplete 4-byte", buf, 6, 0, 6, FALSE);

  (* Invalid: start at end of buffer *)
  CheckNextChar("NextChar: End of buffer", buf, 8, 0, 8, FALSE);

  (* Invalid: bad first byte *)
  buf[0] := CHR(0FFH);
  CheckNextChar("NextChar: Invalid first byte", buf, 0, 0, 0, FALSE);
END TestNextChar;

BEGIN
    TestCharLen;
    TestHasBOM;
    TestIsValid;
    TestEncode;
    TestNextChar;
END TestUtf8.
