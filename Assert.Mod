MODULE Assert;

IMPORT Out;

PROCEDURE Equal*(actual, expected, tolerance: REAL; message: ARRAY OF CHAR);
BEGIN
  IF ABS(actual - expected) > tolerance THEN
    Out.String("FAIL: "); Out.String(message); 
    Out.String(" | Expected: "); Out.Real(expected, 10); 
    Out.String(", Actual: "); Out.Real(actual, 10); 
    Out.Ln;
    HALT(0);
  ELSE
    Out.String("PASS: "); Out.String(message); Out.Ln;
  END;
END Equal;

END Assert.
