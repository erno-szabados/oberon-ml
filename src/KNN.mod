MODULE KNN;
IMPORT Math, KDTree;

CONST
    MaxK* = 20;  (* Maximum number of neighbors to search for *)

TYPE
    Neighbor* = RECORD
        point*: KDTree.Point;
        dist*: REAL
    END;

    NeighborList* = ARRAY MaxK OF Neighbor;

(* Euclidean distance between two points *)
PROCEDURE Distance(VAR a, b: KDTree.Point; k: INTEGER): REAL;
VAR
    i: INTEGER; sum, diff: REAL;
BEGIN
    sum := 0.0;
    i := 0;
    WHILE i < k DO
        diff := a[i] - b[i];
        sum := sum + diff * diff;
        INC(i);
    END;
    RETURN Math.sqrt(sum)
END Distance;

(* Insert a neighbor into the list if closer than the farthest *)
PROCEDURE InsertNeighbor(VAR neighbors: NeighborList; VAR count: INTEGER; VAR point: KDTree.Point; dist: REAL; k: INTEGER);
VAR
    i, maxIdx: INTEGER; maxDist: REAL;
BEGIN
    IF count < k THEN
        neighbors[count].dist := dist;
        KDTree.CopyPoint(point, neighbors[count].point, k);
        INC(count);
    ELSE
        (* Find the farthest neighbor *)
        maxIdx := 0; maxDist := neighbors[0].dist;
        FOR i := 1 TO k-1 DO
            IF neighbors[i].dist > maxDist THEN
                maxDist := neighbors[i].dist;
                maxIdx := i;
            END;
        END;
        IF dist < maxDist THEN
            neighbors[maxIdx].dist := dist;
            KDTree.CopyPoint(point, neighbors[maxIdx].point, k);
        END;
    END;
END InsertNeighbor;

(* Recursive search for k nearest neighbors *)
PROCEDURE SearchKNN(node: KDTree.KDNode; VAR query: KDTree.Point; k, dims: INTEGER; VAR neighbors: NeighborList; VAR count: INTEGER);
VAR
    axis: INTEGER; diff, dist: REAL; next, other: KDTree.KDNode;
BEGIN
    IF node # NIL THEN
        dist := Distance(node.point, query, dims);
        InsertNeighbor(neighbors, count, node.point, dist, k);

        axis := node.axis;
        diff := query[axis] - node.point[axis];

        IF diff < 0.0 THEN
            next := node.left; other := node.right;
        ELSE
            next := node.right; other := node.left;
        END;

        SearchKNN(next, query, k, dims, neighbors, count);

        (* Check if we need to search the other side *)
        IF (count < k) OR (ABS(diff) < neighbors[0].dist) THEN
            SearchKNN(other, query, k, dims, neighbors, count);
        END;
    END;
END SearchKNN;

(* Public API: Find k nearest neighbors *)
PROCEDURE FindKNN*(tree: KDTree.KDTree; VAR query: KDTree.Point; k: INTEGER; VAR neighbors: NeighborList; VAR count: INTEGER);
BEGIN
    count := 0;
    SearchKNN(tree.root, query, k, tree.k, neighbors, count);
END FindKNN;

END KNN.