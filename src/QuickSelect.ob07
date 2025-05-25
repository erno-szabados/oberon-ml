MODULE QuickSelect;

(* Finds the k-th smallest element in an array along a given axis. 
   Used for median finding in KD-Tree construction. *)

PROCEDURE Swap(VAR data: ARRAY OF ARRAY OF REAL; i, j: INTEGER);
VAR
    tmp: ARRAY 32 OF REAL; (* Adjust size as needed *)
    d: INTEGER;
BEGIN
    d := 0;
    WHILE d < LEN(data[0]) DO
        tmp[d] := data[i][d];
        INC(d);
    END;
    d := 0;
    WHILE d < LEN(data[0]) DO
        data[i][d] := data[j][d];
        INC(d);
    END;
    d := 0;
    WHILE d < LEN(data[0]) DO
        data[j][d] := tmp[d];
        INC(d);
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