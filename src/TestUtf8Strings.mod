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

BEGIN
  TestLength;
  TestCopy;
  TestInsert;
  TestAppend;
  TestDelete;
  TestExtract;
END TestUtf8Strings.