MODULE KDTree;
IMPORT QuickSelect;

CONST
    MaxDims* = 20;
    MaxNodes* = 1000;

TYPE
    Point* = ARRAY MaxDims OF REAL;

    KDNode* = POINTER TO RECORD
        point*: Point;
        left*, right*: KDNode;
        axis*: INTEGER
    END;

    KDTree* = RECORD
        root*: KDNode;
        k*: INTEGER; (* number of dimensions *)
        size: INTEGER
    END;


PROCEDURE CopyPoint*(VAR src, dst: Point; k: INTEGER);
(* Helper to copy a point *)
VAR i: INTEGER;
BEGIN
    i := 0;
    WHILE i < k DO
        dst[i] := src[i];
        INC(i);
    END;
END CopyPoint;


PROCEDURE BuildRecursive(VAR data: ARRAY OF Point; left, right, depth, k: INTEGER; VAR size: INTEGER): KDNode;
(* Build the KD-Tree recursively. 
   data: array of points (size n)
   left, right: bounds of the current segment
   depth: current depth in the tree
   k: number of dimensions
*)
VAR
    axis, medianIdx, n: INTEGER;
    node, result: KDNode;
BEGIN
    IF left > right THEN
        result := NIL;
    ELSE
        axis := depth MOD k;
        n := right - left + 1;
        medianIdx := left + n DIV 2;

        (* Use QuickSelect to partition data so that medianIdx is at the correct place *)
        medianIdx := QuickSelect.Select(data, left, right, medianIdx, axis);

        NEW(node);
        CopyPoint(data[medianIdx], node.point, k);
        node.axis := axis;
        INC(size);  (* Increment size for each node created *)

        node.left := BuildRecursive(data, left, medianIdx - 1, depth + 1, k, size);
        node.right := BuildRecursive(data, medianIdx + 1, right, depth + 1, k, size);

        result := node;
    END;
    RETURN result
END BuildRecursive;


PROCEDURE Init*(VAR tree: KDTree; k: INTEGER);
(* Initialize the KDTree *)
BEGIN
    tree.root := NIL;
    tree.k := k;
    tree.size := 0
END Init;

PROCEDURE Build*(VAR tree: KDTree; VAR data: ARRAY OF Point; depth: INTEGER);
(* Public procedure to build the tree *)
VAR
    n: INTEGER;
BEGIN
    n := LEN(data);
    tree.size := 0;  (* Reset size before building *)
    IF n = 0 THEN
        tree.root := NIL;
    ELSE
        tree.root := BuildRecursive(data, 0, n - 1, depth, tree.k, tree.size);
    END;
END Build;


END KDTree.