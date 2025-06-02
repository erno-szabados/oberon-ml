MODULE KDTree;

(** This module implements a space-partitioning K-dimensional tree. *)

IMPORT QuickSelect;

CONST
    (** Maximum dimensions of the space. *)
    MaxDims* = 20;
    (** Maximum nodes in the tree.  *)
    MaxNodes* = 1000;

TYPE
    (** Represents a point in the K-dimensional space. *)
    Point* = ARRAY MaxDims OF REAL;

    (** Represents a tree node. *)
    KDNode* = POINTER TO RECORD
        point*: Point;
        left*, right*: KDNode;
        axis*: INTEGER
    END;

    (** Represents the K-dimensional tree. *)
    KDTree* = RECORD
        root*: KDNode;
        k*: INTEGER; (* number of dimensions *)
        size: INTEGER
    END;

(** Copy a k-dimensional point src to dst *)
PROCEDURE CopyPoint*(VAR src, dst: Point; k: INTEGER);
VAR i: INTEGER;
BEGIN
    i := 0;
    WHILE i < k DO
        dst[i] := src[i];
        INC(i);
    END;
END CopyPoint;

(* Build the KD-Tree recursively. 
   data: array of points (size n)
   left, right: bounds of the current segment
   depth: current depth in the tree
   k: number of dimensions
*)
PROCEDURE BuildRecursive(VAR data: ARRAY OF Point; left, right, depth, k: INTEGER; VAR size: INTEGER): KDNode;
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

(** Initialize the KDTree *)
PROCEDURE Init*(VAR tree: KDTree; k: INTEGER);
BEGIN
    tree.root := NIL;
    tree.k := k;
    tree.size := 0
END Init;

(** Build the KD tree of specified depth, using the provided data points. *)
PROCEDURE Build*(VAR tree: KDTree; VAR data: ARRAY OF Point; depth: INTEGER);
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