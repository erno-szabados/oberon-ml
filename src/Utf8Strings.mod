MODULE Utf8Strings;

IMPORT Utf8;

(* Returns the number of Unicode codepoints in s *)
PROCEDURE Length*(s: ARRAY OF CHAR): INTEGER;
VAR 
  len, idx, dummy: INTEGER; 
  result: BOOLEAN;
BEGIN
  len := 0; idx := 0;
  result := TRUE;
  WHILE (idx < LEN(s)) & result & (s[idx] # 0X) DO
    result := Utf8.NextChar(s, idx, dummy);
    IF result THEN
      len := len + 1;
    END;
  END;
  RETURN len
END Length;

(* Copies src into dest. Truncates if dest is too small. *)
PROCEDURE Copy*(src: ARRAY OF CHAR; VAR dest: ARRAY OF CHAR);
VAR i: INTEGER;
BEGIN
  i := 0;
  WHILE (i < LEN(src)) & (i < LEN(dest)) DO
    dest[i] := src[i];
    i := i + 1;
  END;
  IF i < LEN(dest) THEN dest[i] := 0X END;
END Copy;

(* Inserts substr into src at codepoint position pos, writes result to dest. *)
PROCEDURE Insert*(src: ARRAY OF CHAR; pos: INTEGER; substr: ARRAY OF CHAR; VAR dest: ARRAY OF CHAR);
VAR
  srcIdx, destIdx, cp, substrIdx: INTEGER;
BEGIN
  srcIdx := 0; destIdx := 0; cp := 0;
  (* Copy up to pos-th codepoint from src *)
  WHILE (srcIdx < LEN(src)) & (cp < pos) & (destIdx < LEN(dest)) & (src[srcIdx] # 0X) DO
    Utf8.CopyChar(src, srcIdx, dest, destIdx);
    cp := cp + 1;
  END;
  (* Copy substr as codepoints *)
  substrIdx := 0;
  WHILE (substrIdx < LEN(substr)) & (destIdx < LEN(dest)) & (substr[substrIdx] # 0X) DO
    Utf8.CopyChar(substr, substrIdx, dest, destIdx);
  END;
  (* Copy rest of src as codepoints *)
  WHILE (srcIdx < LEN(src)) & (destIdx < LEN(dest)) & (src[srcIdx] # 0X) DO
    Utf8.CopyChar(src, srcIdx, dest, destIdx);
  END;
  IF destIdx < LEN(dest) THEN dest[destIdx] := 0X END;
END Insert;

(* Appends substr to src, writes result to dest *)
PROCEDURE Append*(src, substr: ARRAY OF CHAR; VAR dest: ARRAY OF CHAR);
VAR len: INTEGER;
BEGIN
  len := Length(src);
  Insert(src, len, substr, dest);
END Append;

(* Deletes count codepoints from src at codepoint position pos, writes result to dest *)
PROCEDURE Delete*(src: ARRAY OF CHAR; pos, count: INTEGER; VAR dest: ARRAY OF CHAR);
VAR
  srcIdx, destIdx, cp, skip: INTEGER;
BEGIN
  srcIdx := 0; destIdx := 0; cp := 0; skip := 0;
  (* Copy up to pos-th codepoint *)
  WHILE (srcIdx < LEN(src)) & (cp < pos) & (destIdx < LEN(dest)) DO
    Utf8.CopyChar(src, srcIdx, dest, destIdx);
    cp := cp + 1;
  END;
  (* Skip count codepoints *)
  WHILE (srcIdx < LEN(src)) & (skip < count) DO
    Utf8.SkipChar(src, srcIdx);
    skip := skip + 1;
  END;
  (* Copy rest *)
  WHILE (srcIdx < LEN(src)) & (destIdx < LEN(dest)) DO
    dest[destIdx] := src[srcIdx];
    destIdx := destIdx + 1; srcIdx := srcIdx + 1;
  END;
  IF destIdx < LEN(dest) THEN dest[destIdx] := 0X END;
END Delete;

(* Extracts count codepoints from src at codepoint position pos, writes result to dest *)
PROCEDURE Extract*(src: ARRAY OF CHAR; pos, count: INTEGER; VAR dest: ARRAY OF CHAR);
VAR
  srcIdx, destIdx, cp, copied: INTEGER;
BEGIN
  srcIdx := 0; destIdx := 0; cp := 0; copied := 0;
  (* Skip up to pos-th codepoint *)
  WHILE (srcIdx < LEN(src)) & (cp < pos) DO
    Utf8.SkipChar(src, srcIdx);
    cp := cp + 1;
  END;
  (* Copy count codepoints *)
  WHILE (srcIdx < LEN(src)) & (copied < count) & (destIdx < LEN(dest)) DO
    Utf8.CopyChar(src, srcIdx, dest, destIdx);
    copied := copied + 1;
  END;
  IF destIdx < LEN(dest) THEN dest[destIdx] := 0X END;
END Extract;

END Utf8Strings.