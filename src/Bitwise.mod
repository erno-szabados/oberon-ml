MODULE Bitwise;

(* Bitwise operations on INTEGER type. *)

IMPORT SYSTEM;

PROCEDURE And*(a, b: INTEGER): INTEGER;
(* Perform bitwise AND operation on two integers. *)
VAR 
    setA, setB: SET;
BEGIN
    setA := SYSTEM.VAL(SET, a);
    setB := SYSTEM.VAL(SET, b);
    
    (* Perform bitwise AND *)
    setA := setA * setB;
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, setA)
END And;

PROCEDURE Or*(a, b: INTEGER): INTEGER;
(* Perform bitwise OR operation on two integers. *)
VAR 
    setA, setB: SET;
BEGIN
    setA := SYSTEM.VAL(SET, a);
    setB := SYSTEM.VAL(SET, b);
    
    (* Perform bitwise OR *)
    setA := setA + setB;
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, setA)
END Or;

PROCEDURE Xor*(a, b: INTEGER): INTEGER;
(* Perform bitwise XOR operation on two integers. *)
VAR 
    setA, setB: SET;
BEGIN
    setA := SYSTEM.VAL(SET, a);
    setB := SYSTEM.VAL(SET, b);
    
    (* Perform bitwise XOR *)
    setA := setA / setB;
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, setA)
END Xor;

PROCEDURE Not*(a: INTEGER): INTEGER;
(* Perform bitwise NOT operation on an integer. *)
VAR 
    setA, setB: SET;
BEGIN
    setA := SYSTEM.VAL(SET, 0FFH);
    setB := SYSTEM.VAL(SET, a);
    (* Use the BIC (AND NOT) operation *)
    setA := setA - setB;
    
    (* Convert back to INTEGER *)
    RETURN SYSTEM.VAL(INTEGER, setA)
END Not;

END Bitwise.
