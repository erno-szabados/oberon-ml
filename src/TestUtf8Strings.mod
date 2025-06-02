MODULE TestUtf8Strings;

IMPORT Out, Utf8Strings;

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

PROCEDURE AssertString(testName, expected, actual: ARRAY OF CHAR);
VAR i, pass: INTEGER;
BEGIN
  i := 0; pass := 1;
  WHILE (i < LEN(expected)) & (expected[i] # 0X) & (actual[i] # 0X) DO
    IF expected[i] # actual[i] THEN pass := 0 END;
    i := i + 1;
  END;
  IF expected[i] # actual[i] THEN pass := 0 END; (* Check for equal length *)
  WriteResult(testName, pass = 1);
END AssertString;

PROCEDURE AssertInt(testName: ARRAY OF CHAR; expected, actual: INTEGER);
BEGIN
  WriteResult(testName, expected = actual);
END AssertInt;

PROCEDURE TestLength;
VAR s: ARRAY 64 OF CHAR; len: INTEGER;
BEGIN
  s := "AΩ😀";
  len := Utf8Strings.Length(s);
  AssertInt("Length('AΩ😀')", 3, len);
END TestLength;

PROCEDURE TestCopy;
VAR s, t: ARRAY 64 OF CHAR;
BEGIN
  s := "AΩ😀";
  Utf8Strings.Copy(s, t);
  AssertString("Copy", s, t);
END TestCopy;

PROCEDURE TestInsert;
VAR s, u: ARRAY 64 OF CHAR;
BEGIN
  s := "AΩ😀";
  Utf8Strings.Insert(s, 1, "X", u);
  AssertString("Insert 'X' at pos 1", "AXΩ😀", u);
END TestInsert;

PROCEDURE TestAppend;
VAR s, u: ARRAY 64 OF CHAR;
BEGIN
  s := "AΩ😀";
  Utf8Strings.Append(s, "!", u);
  AssertString("Append '!'", "AΩ😀!", u);
END TestAppend;

PROCEDURE TestDelete;
VAR s, u: ARRAY 64 OF CHAR;
BEGIN
  s := "AΩ😀";
  Utf8Strings.Delete(s, 1, 1, u);
  AssertString("Delete at pos 1", "A😀", u);
END TestDelete;

PROCEDURE TestExtract;
VAR s, u: ARRAY 64 OF CHAR;
BEGIN
  s := "AΩ😀";
  Utf8Strings.Extract(s, 1, 2, u);
  AssertString("Extract 2 from pos 1", "Ω😀", u);
END TestExtract;

PROCEDURE TestPos;
VAR s: ARRAY 64 OF CHAR; pos: INTEGER;
BEGIN
  s := "AΩ😀ΩA";
  (* Find ASCII character *)
  pos := Utf8Strings.Pos("A", s, 0);
  AssertInt("Pos('A', ... , 0)", 0, pos);

  (* Find multi-byte character *)
  pos := Utf8Strings.Pos("Ω", s, 0);
  AssertInt("Pos('Ω', ... , 0)", 1, pos);

  (* Find emoji *)
  pos := Utf8Strings.Pos("😀", s, 0);
  AssertInt("Pos('😀', ... , 0)", 2, pos);

  (* Find second occurrence, start after first *)
  pos := Utf8Strings.Pos("Ω", s, 2);
  AssertInt("Pos('Ω', ... , 2)", 3, pos);

  (* Not found *)
  pos := Utf8Strings.Pos("Z", s, 0);
  AssertInt("Pos('Z', ... , 0)", -1, pos);

  (* Pattern at end *)
  pos := Utf8Strings.Pos("A", s, 4);
  AssertInt("Pos('A', ... , 4)", 4, pos);

  (* Pattern not found after startPos *)
  pos := Utf8Strings.Pos("A", s, 5);
  AssertInt("Pos('A', ... , 5)", -1, pos);

  (* Whole string as pattern *)
  pos := Utf8Strings.Pos("AΩ😀ΩA", s, 0);
  AssertInt("Pos(full, ... , 0)", 0, pos);

  (* Pattern longer than string *)
  pos := Utf8Strings.Pos("AΩ😀ΩAΩ", s, 0);
  AssertInt("Pos(longer, ... , 0)", -1, pos);
END TestPos;

PROCEDURE TestReplace;
VAR
  s, expected: ARRAY 64 OF CHAR;
BEGIN
  (* Oakwood semantics: Replace deletes as many codepoints as the length of the source string *)

  (* Replace middle codepoint with single codepoint *)
  s := "AΩ😀";
  Utf8Strings.Replace("X", 1, s);
  expected := "AX😀";
  AssertString("Replace 'Ω' with 'X'", expected, s);

  (* Replace at start with single codepoint *)
  s := "AΩ😀";
  Utf8Strings.Replace("Z", 0, s);
  expected := "ZΩ😀";
  AssertString("Replace 'A' with 'Z'", expected, s);

  (* Replace at end with single codepoint *)
  s := "AΩ😀";
  Utf8Strings.Replace("!", 2, s);
  expected := "AΩ!";
  AssertString("Replace '😀' with '!'", expected, s);

  (* Replace middle codepoint with two codepoints (deletes two, inserts two) *)
  s := "AΩ😀";
  Utf8Strings.Replace("XY", 1, s);
  expected := "AXY";
  AssertString("Replace 'Ω😀' with 'XY'", expected, s);

  (* Replace with empty string (deletes zero codepoints, so string unchanged) *)
  s := "AΩ😀";
  Utf8Strings.Replace("", 1, s);
  expected := "AΩ😀";
  AssertString("Replace with '' (Oakwood: no-op)", expected, s);
END TestReplace;

BEGIN
  TestLength;
  TestCopy;
  TestInsert;
  TestAppend;
  TestDelete;
  TestExtract;
  TestPos;
  TestReplace;
END TestUtf8Strings.