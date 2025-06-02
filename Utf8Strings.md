# Utf8Strings Module

The `Utf8Strings` module implements set of procedures for manipulating UTF-8 encoded strings. 
It mostly follows the Oakwood Strings module interface, but omits the Cap
function as capitalization rules are locale-dependent for UTF-8 strings. 

## Testing

The `TestUtf8Strings` implements a basic test suite for the `Utf8Strings` module.

## Usage

```oberon
IMPORT Utf8Strings;

VAR
  src, dest: ARRAY 64 OF CHAR;

(* Example: Calculate length (in codepoints) *)
src := "AΩ😀";
Out.Int(Utf8Strings.Length(src), 0);  (* Output: 3 *)

(* Example: Copy a UTF-8 string *)
Utf8Strings.Copy(src, dest);
(* dest now contains "AΩ😀" *)

(* Example: Insert a substring *)
Utf8Strings.Insert(src, 1, "X", dest);
(* dest now contains "AXΩ😀" *)

(* Example: Append a substring *)
Utf8Strings.Append(src, "!", dest);
(* dest now contains "AΩ😀!" *)

(* Example: Delete a codepoint *)
Utf8Strings.Delete(src, 1, 1, dest);
(* dest now contains "A😀" *)

(* Example: Extract a substring *)
Utf8Strings.Extract(src, 1, 2, dest);
(* dest now contains "Ω😀" *)
(* Example: Find position of a substring *)
src := "AΩ😀Ω";
Out.Int(Utf8Strings.Pos("Ω", src, 0), 0);  (* Output: 1 *)
Out.Int(Utf8Strings.Pos("😀", src, 2), 0);  (* Output: -1 *)

(* Example: Replace a substring *)
src := "AΩ😀";
dest := src;
Utf8Strings.Replace("B", 1, dest);
(* dest now contains "AB😀" *)
```

