MODULE Math;

(**
  Commonly needed Math for REALs.
*)

CONST
  e* = 2.7182818284590452354E0;
  pi* = 3.14159265358979323846E0;

PROCEDURE sin*(x: REAL): REAL;
  VAR 
    term, sum, xSquared, result: REAL; 
    n, maxIterations: INTEGER;
BEGIN
  (* Ensure x is within range for better convergence *)
  (* Reduce to [-2pi, 2pi] *)
  WHILE x > 2.0 * pi DO x := x - 2.0 * pi END;
  WHILE x < -2.0 * pi DO x := x + 2.0 * pi END;
  
  (* Check special cases *)
  IF x = 0.0 THEN 
    result := 0.0 
  ELSE
    (* Use Taylor series: sin(x) = x - x^3/3! + x^5/5! - x^7/7! + ... *)
    term := x; sum := x; xSquared := x * x; n := 1;
    maxIterations := 100; (* Prevent infinite loops *)
  
    WHILE (ABS(term) > 1.0E-10) & (n < maxIterations) DO
      term := -term * xSquared / FLT(2*n * (2*n + 1));
      sum := sum + term;
      INC(n);
    END;
    result := sum;
  END;
  
  RETURN result
END sin;

PROCEDURE cos*(x: REAL): REAL;
  VAR 
    term, sum, xSquared, result: REAL; 
    n, maxIterations: INTEGER;
BEGIN
  (* Ensure x is within range for better convergence *)
  (* Reduce to [-2pi, 2pi] *)
  WHILE x > 2.0 * pi DO x := x - 2.0 * pi END;
  WHILE x < -2.0 * pi DO x := x + 2.0 * pi END;
  
  (* Check special cases *)
  IF x = 0.0 THEN 
    result := 1.0
  ELSE
  (* Use Taylor series: cos(x) = 1 - x^2/2! + x^4/4! - x^6/6! + ... *)
  term := 1.0; sum := 1.0; xSquared := x * x; n := 1;
  maxIterations := 100; (* Prevent infinite loops *)
  
    WHILE (ABS(term) > 1.0E-10) & (n < maxIterations) DO
      term := -term * xSquared / FLT(2*n * (2*n - 1));
      sum := sum + term;
      INC(n);
    END;
    result := sum;
  END;
  
  RETURN result
END cos;

PROCEDURE arctan*(x: REAL): REAL;
VAR
  term, sum, xSquared, result: REAL;
  n, maxIterations: INTEGER;
  isNegative: BOOLEAN;
  PI4: REAL; (* pi/4 *)
BEGIN
  (* Define constant *)
  PI4 := 0.78539816339744830962; (* pi/4 exactly *)

  result := 0.0; (* Initialize result *)

  (* Special cases *)
  IF x = 0.0 THEN
    result := 0.0;
  ELSIF x = 1.0 THEN
    result := PI4;
  ELSIF x = -1.0 THEN
    result := -PI4;
  ELSE
    (* Handle negative values *)
    isNegative := x < 0.0;
    IF isNegative THEN x := -x END;

    (* Range reduction for faster convergence *)
    IF x > 1.0 THEN
      (* Use pi/2 - arctan(1/x) for x > 1 *)
      x := 1.0 / x;
      sum := PI4 * 2.0 - arctan(x);
      IF isNegative THEN result := -sum ELSE result := sum END;
    ELSE
      (* For small x values, use the optimized Taylor series *)
      term := x;
      sum := x;
      xSquared := x * x;
      n := 1;
      maxIterations := 100; (* Much fewer iterations needed with range reduction *)

      WHILE (ABS(term) > 1.0E-12) & (n < maxIterations) DO
        n := n + 2;
        term := -term * xSquared;
        sum := sum + term / FLT(n);
      END;

      IF isNegative THEN result := -sum ELSE result := sum END;
    END;
  END;

  RETURN result
END arctan;

PROCEDURE sqrt*(x: REAL): REAL;
  VAR 
    guess, prevGuess, result: REAL;
    maxIterations, i: INTEGER;
BEGIN
  (* Error value for invalid input *)
  IF x < 0.0 THEN 
    result :=  -1.0  
  ELSIF x = 0.0 THEN 
    result := 0.0 
  ELSIF x = 1.0 THEN 
    result := 1.0 
  ELSE
    (* Better initial guess for faster convergence *)
    IF x > 1.0 THEN
      guess := x / 2.0;  (* Reasonable initial guess for large values *)
    ELSE
      guess := x + x / 2.0;  (* Better guess for values < 1 *)
    END;
    
    prevGuess := 0.0;
    maxIterations := 20;  (* Newton's method converges quickly *)
    i := 0;
    
    WHILE (ABS(guess - prevGuess) > 1.0E-10) & (i < maxIterations) DO
      prevGuess := guess;
      guess := 0.5 * (guess + x / guess);
      INC(i);
    END;
    
    result := guess
  END;
  
  RETURN result
END sqrt;

PROCEDURE ln*(x: REAL): REAL;
VAR 
  term, sum, y, ySquared, result, LN2: REAL; 
  i, k: INTEGER;
BEGIN
  (* Use series expansion for ln(1+y): ln(x) = ln(2^k) + ln(y+1), where y = x/2^k - 1 *)
  (* Return -1 for invalid input *)
  IF x <= 0.0 THEN 
    result := -1.0 
  ELSE
    (* Define the constant for ln(2) *)
    LN2 := 0.693147180559945;
    
    (* Range reduction: Find k such that 0.5 < x/2^k <= 1 *)
    y := x; k := 0;
    IF y >= 2.0 THEN
      (* If x >= 2, divide by 2 repeatedly until 0.5 < y <= 1 *)
      WHILE y >= 2.0 DO
        y := y / 2.0;
        INC(k);
      END;
    ELSIF y < 1.0 THEN
      (* If x < 1, multiply by 2 repeatedly until 0.5 < y <= 1 *)
      WHILE y < 0.5 DO
        y := y * 2.0;
        DEC(k);
      END;
    END;
    
    (* Now use Taylor series for ln(1+z) where z = y-1 *)
    (* For 0.5 < y <= 1, -0.5 < z <= 0 *)
    y := y - 1.0; 
    ySquared := y * y;
    term := y; 
    sum := y;
    i := 1;
    
    WHILE ABS(term) > 1.0E-10 DO
      i := i + 1;
      term := -term * y;  (* Alternate signs for the series *)
      sum := sum + term / FLT(i);
    END;
    
    (* Final result: ln(x) = k*ln(2) + ln(1+z) *)
    result := FLT(k) * LN2 + sum;
  END; 
  
  RETURN result
END ln;

PROCEDURE exp*(x: REAL): REAL;
VAR 
  term, sum, result, fraction: REAL; 
  n, maxIterations, k: INTEGER;
BEGIN
  (* Handle special cases *)
  IF x = 0.0 THEN 
    result := 1.0 
  ELSE   
    (* Range reduction for large values *)
    k := 0;
    fraction := x;
    
    (* For large positive x, compute exp(x/2^k)^(2^k) *)
    IF ABS(x) > 1.0 THEN
      WHILE ABS(fraction) > 1.0 DO
        fraction := fraction / 2.0;
        INC(k);
      END;
    END;
    
    (* Use Taylor series: exp(x) = 1 + x + x^2/2! + x^3/3! + ... *)
    term := 1.0; sum := 1.0; n := 1;
    maxIterations := 100;
    
    WHILE (ABS(term) > 1.0E-12) & (n < maxIterations) DO
      term := term * fraction / FLT(n);
      sum := sum + term;
      INC(n);
    END;
    
    (* Square the result k times: exp(x) = exp(x/2^k)^(2^k) *)
    result := sum;
    WHILE k > 0 DO
      result := result * result;
      DEC(k);
    END;
  END;
  
  RETURN result
END exp;

END Math.
