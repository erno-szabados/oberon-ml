MODULE MathTest;

IMPORT Math, Out, Assert;

PROCEDURE TestSin*;
BEGIN
  Out.String("Testing sin..."); Out.Ln;
  Assert.Equal(Math.sin(0.0), 0.0, 1.0E-6, "sin(0)");
  Assert.Equal(Math.sin(Math.pi / 2.0), 1.0, 1.0E-6, "sin(pi/2)");
  Assert.Equal(Math.sin(Math.pi), 0.0, 1.0E-6, "sin(pi)");
  Assert.Equal(Math.sin(-Math.pi / 2.0), -1.0, 1.0E-6, "sin(-pi/2)");
END TestSin;

PROCEDURE TestCos*;
BEGIN
  Out.String("Testing cos..."); Out.Ln;
  Assert.Equal(Math.cos(0.0), 1.0, 1.0E-6, "cos(0)");
  Assert.Equal(Math.cos(Math.pi / 2.0), 0.0, 1.0E-6, "cos(pi/2)");
  Assert.Equal(Math.cos(Math.pi), -1.0, 1.0E-6, "cos(pi)");
  Assert.Equal(Math.cos(-Math.pi / 2.0), 0.0, 1.0E-6, "cos(-pi/2)");
END TestCos;

PROCEDURE TestArctan*;
BEGIN
  Out.String("Testing arctan..."); Out.Ln;
  Assert.Equal(Math.arctan(0.0), 0.0, 1.0E-6, "arctan(0)");
  Assert.Equal(Math.arctan(0.5), 4.63647609E-1, 1.0E-6, "arctan(0.5)"); 
  Assert.Equal(Math.arctan(-0.5), -4.63647609E-1, 1.0E-6, "arctan(-0.5)"); 
  Assert.Equal(Math.arctan(1.0), Math.pi / 4.0, 1.0E-6, "arctan(1)");
  Assert.Equal(Math.arctan(-1.0), -Math.pi / 4.0, 1.0E-6, "arctan(-1)");
END TestArctan;

PROCEDURE TestSqrt*;
BEGIN
  Out.String("Testing sqrt..."); Out.Ln;
  Assert.Equal(Math.sqrt(0.0), 0.0, 1.0E-6, "sqrt(0)");
  Assert.Equal(Math.sqrt(1.0), 1.0, 1.0E-6, "sqrt(1)");
  Assert.Equal(Math.sqrt(4.0), 2.0, 1.0E-6, "sqrt(4)");
  Assert.Equal(Math.sqrt(9.0), 3.0, 1.0E-6, "sqrt(9)");
END TestSqrt;

PROCEDURE TestLn*;
BEGIN
  Out.String("Testing ln..."); Out.Ln;
  Assert.Equal(Math.ln(1.0), 0.0, 1.0E-6, "ln(1)");
  Assert.Equal(Math.ln(Math.e), 1.0, 1.0E-6, "ln(e)");
  Assert.Equal(Math.ln(Math.e * Math.e), 2.0, 1.0E-6, "ln(e^2)");
END TestLn;

PROCEDURE TestExp*;
BEGIN
  Out.String("Testing exp..."); Out.Ln;
  Assert.Equal(Math.exp(0.0), 1.0, 1.0E-6, "exp(0)");
  Assert.Equal(Math.exp(1.0), Math.e, 1.0E-6, "exp(1)");
  Assert.Equal(Math.exp(2.0), Math.exp(1.0) * Math.exp(1.0), 1.0E-6, "exp(2)");
END TestExp;

PROCEDURE RunTests*;
BEGIN
  TestSin;
  TestCos;
  TestArctan;
  TestSqrt;
  TestLn;
  TestExp;
END RunTests;

BEGIN

RunTests;

END MathTest.
