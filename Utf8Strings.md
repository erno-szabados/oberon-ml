# Utf8Strings Module

The `Utf8Strings` module offers a custom `String` type and a set of procedures for manipulating UTF-8 encoded strings. The operations focus on codepoint-level manipulations.

### Functionalities

The `Utf8Strings` module includes the following key operations:

- **Length Calculation**: Determine the number of codepoints in a UTF-8 string.
- **Insertion**: Insert a substring at a specified position within a UTF-8 string.
- **Appending**: Add a substring to the end of a UTF-8 string.
- **Deletion**: Remove a substring from a UTF-8 string.
- **Extraction**: Extract a substring from a UTF-8 string based on specified indices.
- **Finding Positions**: Locate the position of a substring within a UTF-8 string.

### Type Conversions

The module provides conversions between the custom `String` type and standard character arrays.

## Testing

The `TestUtf8Strings` module contains a suite of test procedures that verify the correctness of the operations implemented in the `Utf8Strings` module.

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
```

