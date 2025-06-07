(** CollectionKeys.mod - Key types and operations for key-value collections.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE CollectionKeys;

IMPORT Collections, Bitwise;

TYPE
    (** Base type for all keys *)
    Key* = RECORD(Collections.Item)
        (* Base key type - extend this for specific key types *)
    END;
    KeyPtr* = POINTER TO Key;
    
    (** Integer key implementation *)
    IntegerKey* = RECORD(Key)
        value*: INTEGER
    END;
    IntegerKeyPtr* = POINTER TO IntegerKey;
    
    (** Key operations interface *)
    KeyOps* = RECORD
        hash*: PROCEDURE(key: KeyPtr; size: INTEGER): INTEGER;
        equals*: PROCEDURE(key1, key2: KeyPtr): BOOLEAN
    END;

(** Create integer key *)
PROCEDURE NewIntegerKey*(value: INTEGER): IntegerKeyPtr;
VAR key: IntegerKeyPtr;
BEGIN
    NEW(key);
    key.value := value;
    RETURN key
END NewIntegerKey;

(* Hash function for integer keys *)
PROCEDURE HashInteger(key: KeyPtr; size: INTEGER): INTEGER;
VAR 
    intKey: IntegerKeyPtr;
    hash: INTEGER;
BEGIN
    intKey := key(IntegerKeyPtr);
    hash := Bitwise.Xor(intKey.value, Bitwise.ShiftRight(intKey.value, 16));
    hash := hash * 73;
    hash := Bitwise.Xor(hash, Bitwise.ShiftRight(hash, 13));
    hash := hash * 37;
    hash := Bitwise.Xor(hash, Bitwise.ShiftRight(hash, 9));
    IF hash < 0 THEN hash := -hash END;
    RETURN hash MOD size
END HashInteger;

(* Equality function for integer keys *)
PROCEDURE EqualsInteger(key1, key2: KeyPtr): BOOLEAN;
VAR 
    intKey1, intKey2: IntegerKeyPtr;
    result: BOOLEAN;
BEGIN
    intKey1 := key1(IntegerKeyPtr);
    intKey2 := key2(IntegerKeyPtr);
    result := intKey1.value = intKey2.value;
    RETURN result
END EqualsInteger;

(** Get integer key operations *)
PROCEDURE IntegerKeyOps*(VAR ops: KeyOps);
BEGIN
    ops.hash := HashInteger;
    ops.equals := EqualsInteger
END IntegerKeyOps;

END CollectionKeys.
