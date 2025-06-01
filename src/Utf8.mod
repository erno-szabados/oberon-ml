MODULE Utf8;

IMPORT SYSTEM, Bitwise, Out;

(* This module implements UTF-8 encoding and utility procedures. *)

CONST 
  Bom0 = CHR(0EFH);
  Bom1 = CHR(0BBH);
  Bom2 = CHR(0BFH);

  Mask1B = 080H; (* 0b10000000*)
  Mask2B = 0E0H; (* 0b11100000*)
  Mask3B = 0F0H; (* 0b11110000*)
  Mask4B = 0F8H; (* 0b11111000*)

PROCEDURE CharLen*(firstByte: CHAR): INTEGER;
(* Determine the length of a UTF-8 character based on the first byte *)
(* Returns the number of bytes in a UTF-8 character starting with firstByte *)
(* Returns 0 for an invalid byte sequence. *)
VAR
  result, aInt : INTEGER;
BEGIN
  aInt := SYSTEM.VAL(INTEGER, firstByte);
  IF Bitwise.And(aInt, Mask1B) = 0 THEN
    result := 1;
  ELSIF Bitwise.And(aInt, Mask2B) = 0C0H THEN
    result := 2;
  ELSIF Bitwise.And(aInt, Mask3B) = 0E0H THEN
    result := 3;
  ELSIF Bitwise.And(aInt, Mask4B) = 0F0H THEN
    result := 4;
  ELSE
    result := 0;
  END;
  RETURN result
END CharLen;

PROCEDURE IsValid*(buffer: ARRAY OF CHAR; len: INTEGER): BOOLEAN;
(* Returns TRUE if buf[0..len-1] is valid UTF-8 *)
BEGIN
  RETURN FALSE (*TODO*)
END IsValid;

PROCEDURE HasBOM*(buffer: ARRAY OF CHAR; len: INTEGER): BOOLEAN;
(* Returns TRUE if buffer starts with a UTF-8 BOM (EF BB BF), otherwise returns FALSE. *)
VAR 
  result: BOOLEAN;
BEGIN
  result := FALSE;
  IF len >= 3 THEN
      IF (buffer[0] = Bom0) & 
         (buffer[1] = Bom1) & 
         (buffer[2] = Bom2) THEN
      result := TRUE;
    END
  END
  RETURN result
END HasBOM;

PROCEDURE Encode*(codePoint: INTEGER; VAR buffer: ARRAY OF CHAR; index: INTEGER; VAR bytesWritten: INTEGER): BOOLEAN;
(* Converts a Unicode code point to UTF-8 and writes it to buffer at buffer[index].
   Returns TRUE if successful, FALSE if the code point is invalid or buffer is too small. *)
BEGIN
    RETURN FALSE (*TODO*)
END Encode;

PROCEDURE NextChar*(VAR byteArray: ARRAY OF CHAR; VAR index: INTEGER; VAR codePoint: INTEGER): BOOLEAN;
(* Reads the next UTF-8 character (code point) from a byte array, advances the index, and returns the code point.  *)
(* Returns FALSE if the end of the array is reached or an invalid sequence is encountered. *)
BEGIN
    RETURN FALSE (*TODO*)
END NextChar;

PROCEDURE PrevChar*(VAR byteArray: ARRAY OF CHAR; VAR index: INTEGER; VAR codePoint: INTEGER): BOOLEAN;
(* Similar to NextChar but reads the previous code point by moving backward from the current index. *)
(* Returns FALSE if the start of the array is reached or an invalid sequence is encountered. *)
BEGIN
    RETURN FALSE (*TODO*)
END PrevChar;

END Utf8.