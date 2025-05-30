MODULE QuickSelect;

CONST 
    MaxDims = 32;  (* Maximum dimensions for points *)

(* Finds the k-th smallest element in an array along a given axis. 
   Used for median finding in KD-Tree construction. *)

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