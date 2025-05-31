MODULE Utf8;

IMPORT Bitwise, Out;

(* This module implements UTF-8 encoding and utility procedures. *)

PROCEDURE CharLen*(firstByte: CHAR): INTEGER;
(* Determine the length of a UTF-8 character based on the first byte *)
(* Returns the number of bytes in a UTF-8 character starting with firstByte *)
(* Returns 0 for an invalid byte sequence. *)
VAR
BEGIN

  (* b := VAL(BITSET, firstByte);
  IF (b * Mask1B) = {} THEN
    RETURN 1;
  ELSIF (b * Mask2B) = BITSET{7,6} THEN
    RETURN 2;
  ELSIF (b * Mask3B) = BITSET{7,6,5} THEN
    RETURN 3;
  ELSIF (b * Mask4B) = BITSET{7,6,5,4} THEN
    RETURN 4;
  ELSE
    RETURN 0;
  END; *)
  RETURN 0
END CharLen;

PROCEDURE IsValid*(buf: ARRAY OF CHAR; len: INTEGER): BOOLEAN;
(* Returns TRUE if buf[0..len-1] is valid UTF-8 *)
BEGIN
    RETURN FALSE (*TODO*)
END IsValid;

PROCEDURE HasBOM*(buffer: ARRAY OF CHAR; len: INTEGER): BOOLEAN;
(* Returns TRUE if buffer starts with a UTF-8 BOM (EF BB BF), otherwise returns FALSE. *)
BEGIN
    RETURN FALSE (*TODO*)
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