MODULE TestKnn;

IMPORT Out, QuickSelect, KDTree, KNN;

PROCEDURE TestQuickSelect*(): BOOLEAN;
(* Test the QuickSelect.Select procedure with a small 2D array. *)
VAR
    data: ARRAY 5 OF ARRAY 2 OF REAL;
    medianIdx, axis: INTEGER;
    result: BOOLEAN;
BEGIN
    (* Sample data: 5 points in 2D *)
    data[0][0] := 3.0; data[0][1] := 7.0;
    data[1][0] := 1.0; data[1][1] := 5.0;
    data[2][0] := 4.0; data[2][1] := 2.0;
    data[3][0] := 2.0; data[3][1] := 8.0;
    data[4][0] := 5.0; data[4][1] := 1.0;

    axis := 0; (* Test along the first axis *)
    medianIdx := QuickSelect.Select(data, 0, 4, 2, axis); (* Find median index *)

    Out.String("Median index along axis 0: "); Out.Int(medianIdx, 0); Out.Ln;
    Out.String("Median value: "); Out.Real(data[medianIdx][axis], 4); Out.Ln;

    (* Check if the value at medianIdx is the median (should be 3.0 for axis 0) *)
    IF data[medianIdx][axis] = 3.0 THEN
        Out.String("QuickSelect test passed."); Out.Ln;
        result := TRUE;
    ELSE
        Out.String("QuickSelect test failed."); Out.Ln;
        result := FALSE;
    END;
    RETURN result
END TestQuickSelect;

PROCEDURE TestKDTree*(): BOOLEAN;
(* Test the KDTree.Build procedure with a small set of 2D points. *)
VAR
    data: ARRAY 5 OF KDTree.Point;
    tree: KDTree.KDTree;
    node: KDTree.KDNode;
    i: INTEGER;
    result: BOOLEAN;
BEGIN
    (* Prepare 5 points in 2D *)
    FOR i := 0 TO 1 DO data[0][i] := 3.0; END; data[0][1] := 7.0;
    data[1][0] := 1.0; data[1][1] := 5.0;
    data[2][0] := 4.0; data[2][1] := 2.0;
    data[3][0] := 2.0; data[3][1] := 8.0;
    data[4][0] := 5.0; data[4][1] := 1.0;

    KDTree.Init(tree, 2);

    KDTree.Build(tree, data, 0);
    node := tree.root;

    IF node # NIL THEN
        Out.String("KDTree root axis: "); Out.Int(node.axis, 0); Out.Ln;
        Out.String("KDTree root point: (");
        Out.Real(node.point[0], 4); Out.String(", ");
        Out.Real(node.point[1], 4); Out.String(")"); Out.Ln;
        Out.String("KDTree test passed."); Out.Ln;
        result := TRUE;
    ELSE
        Out.String("KDTree test failed."); Out.Ln;
        result := FALSE;
    END;
    RETURN result
END TestKDTree;

PROCEDURE TestKNN*(): BOOLEAN;
(* Test the KNN.FindKNN procedure with a small set of 2D points. *)
VAR
    data: ARRAY 5 OF KDTree.Point;
    tree: KDTree.KDTree;
    neighbors: KNN.NeighborList;
    query: KDTree.Point;
    count, i, j, k: INTEGER;
    result: BOOLEAN;
    tmp: KNN.Neighbor;
BEGIN
    (* Prepare 5 points in 2D *)
    data[0][0] := 3.0; data[0][1] := 7.0;
    data[1][0] := 1.0; data[1][1] := 5.0;
    data[2][0] := 4.0; data[2][1] := 2.0;
    data[3][0] := 2.0; data[3][1] := 8.0;
    data[4][0] := 5.0; data[4][1] := 1.0;

    KDTree.Init(tree, 2);
    KDTree.Build(tree, data, 0);

    (* Query point close to (1.0, 5.0) *)
    query[0] := 1.1; query[1] := 5.2;
    k := 2;
    KNN.FindKNN(tree, query, k, neighbors, count);

    (* Sort neighbors by distance *)
    FOR i := 0 TO count-2 DO
        FOR j := i+1 TO count-1 DO
            IF neighbors[j].dist < neighbors[i].dist THEN
                tmp := neighbors[i];
                neighbors[i] := neighbors[j];
                neighbors[j] := tmp;
            END;
        END;
    END;

    Out.String("KNN test: Query point (");
    Out.Real(query[0], 4); Out.String(", ");
    Out.Real(query[1], 4); Out.String(")"); Out.Ln;
    Out.String("Found neighbors: "); Out.Int(count, 0); Out.Ln;
    FOR i := 0 TO count-1 DO
        Out.String("Neighbor "); Out.Int(i+1, 0); Out.String(": (");
        Out.Real(neighbors[i].point[0], 4); Out.String(", ");
        Out.Real(neighbors[i].point[1], 4); Out.String("), dist = ");
        Out.Real(neighbors[i].dist, 4); Out.Ln;
    END;

    (* Check if the closest neighbor is (1.0, 5.0) *)
    IF (neighbors[0].point[0] = 1.0) & (neighbors[0].point[1] = 5.0) THEN
        Out.String("KNN test passed."); Out.Ln;
        result := TRUE;
    ELSE
        Out.String("KNN test failed."); Out.Ln;
        result := FALSE;
    END;
    RETURN result
END TestKNN;

BEGIN
    IF TestQuickSelect() THEN
        Out.String("TestKnn module QuickSelect test passed."); Out.Ln;
    ELSE
        Out.String("TestKnn module QuickSelect test failed."); Out.Ln;
    END;
    IF TestKDTree() THEN
        Out.String("TestKnn module KDTree test passed."); Out.Ln;
    ELSE
        Out.String("TestKnn module KDTree test failed."); Out.Ln;
    END;
    IF TestKNN() THEN
        Out.String("TestKnn module KNN test passed."); Out.Ln;
    ELSE
        Out.String("TestKnn module KNN test failed."); Out.Ln;
    END
END TestKnn.