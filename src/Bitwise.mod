MODULE Bitwise;

(* Bitwise operations on INTEGER (32-bit) type. *)

IMPORT SYSTEM;

PROCEDURE And*(a, b: INTEGER): INTEGER;
(* Perform bitwise AND operation on two integers. *)
VAR 
    set: SET;
BEGIN
    (* Perform bitwise AND *)
    set := SYSTEM.VAL(SET, a) * SYSTEM.VAL(SET, b);
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, set)
END And;

PROCEDURE Or*(a, b: INTEGER): INTEGER;
(* Perform bitwise OR operation on two integers. *)
VAR 
    set: SET;
BEGIN
    (* Perform bitwise OR *)
    set := SYSTEM.VAL(SET, a) + SYSTEM.VAL(SET, b);
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, set)
END Or;

PROCEDURE Xor*(a, b: INTEGER): INTEGER;
(* Perform bitwise XOR operation on two integers. *)
VAR 
    set: SET;
BEGIN   
    (* Perform bitwise XOR *)
    set := SYSTEM.VAL(SET, a) / SYSTEM.VAL(SET, b);
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, set)
END Xor;

PROCEDURE Not*(a: INTEGER): INTEGER;
(* Perform bitwise NOT operation on an integer. *)
VAR 
    set: SET;
BEGIN
    (* Use the BIC (AND NOT) operation *)
    set := SYSTEM.VAL(SET, 0FFH) - SYSTEM.VAL(SET, a);
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, set)
END Not;

PROCEDURE ShiftLeft*(a: INTEGER; n: INTEGER): INTEGER;
(* Perform shift left operation on an integer. *)
BEGIN
    RETURN LSL(a, n)
END ShiftLeft;

PROCEDURE ShiftRight*(a: INTEGER; n: INTEGER): INTEGER;
(* Perform signed shift right operation on an integer. *)
BEGIN
    RETURN ASR(a, n)
END ShiftRight;

PROCEDURE RotateLeft*(a: INTEGER; n: INTEGER): INTEGER;
(* Perform rotate left operation on an integer. *)
BEGIN
    RETURN ROR(a, 32 - n)
END RotateLeft;

PROCEDURE RotateRight*(a: INTEGER; n: INTEGER): INTEGER;
(* Perform rotate right operation on an integer. *)
BEGIN
    RETURN ROR(a, n)
END RotateRight;

END Bitwise.
