MODULE QuickSelect;

(** This module implements an algorithm to find the k-th smallest element in a 
    fixed-size 2D array of REALs along a specified axis, which is commonly used for 
    median selection in multidimensional data structures like KD-Trees.*)

CONST 
    (* Maximum dimensions for points *)
    MaxDims = 20;  

(* Swaps two rows (points) in the data array. *) 
PROCEDURE Swap(VAR data: ARRAY OF ARRAY OF REAL; i, j: INTEGER);
VAR
    tmp: ARRAY MaxDims OF REAL;
    d, n: INTEGER;
BEGIN
    n := LEN(data[0]);
    ASSERT(n <= MaxDims);
    FOR d := 0 TO n-1 DO
        tmp[d] := data[i][d];
    END;
    FOR d := 0 TO n-1 DO
        data[i][d] := data[j][d];
    END;
    FOR d := 0 TO n-1 DO
        data[j][d] := tmp[d];
    END;
END Swap;

(* Partitions the data array around a pivot so that elements less than the pivot 
   (on the given axis) are on the left, and returns the new pivot index. *) 
PROCEDURE Partition(VAR data: ARRAY OF ARRAY OF REAL; left, right, pivotIndex, axis: INTEGER): INTEGER;
VAR
    pivotValue: REAL;
    storeIndex, i: INTEGER;
BEGIN
    pivotValue := data[pivotIndex][axis];
    Swap(data, pivotIndex, right);
    storeIndex := left;
    i := left;
    WHILE i < right DO
        IF data[i][axis] < pivotValue THEN
            Swap(data, storeIndex, i);
            INC(storeIndex);
        END;
        INC(i);
    END;
    Swap(data, right, storeIndex);
    RETURN storeIndex
END Partition;

(** Recursively finds the index of the k-th smallest element in the data array along the specified axis. *)
PROCEDURE Select*(VAR data: ARRAY OF ARRAY OF REAL; left, right, k, axis: INTEGER): INTEGER;
VAR
    pivotIndex, pivotNewIndex, result: INTEGER;
BEGIN
    IF left = right THEN
        result := left;
    ELSE
        pivotIndex := (left + right) DIV 2; (* Choose middle as pivot *)
        pivotNewIndex := Partition(data, left, right, pivotIndex, axis);
        IF k = pivotNewIndex THEN
            result := k;
        ELSIF k < pivotNewIndex THEN
            result := Select(data, left, pivotNewIndex - 1, k, axis);
        ELSE
            result := Select(data, pivotNewIndex + 1, right, k, axis);
        END;
    END;
    RETURN result
END Select;

END QuickSelect.