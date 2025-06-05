(** TestKnn.Mod - Tests for KNN.Mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)
MODULE TestKnn;

IMPORT QuickSelect, KDTree, KNN, Tests;

VAR
  ts: Tests.TestSet;

PROCEDURE TestQuickSelect*(): BOOLEAN;
VAR
    data: ARRAY 5 OF ARRAY 2 OF REAL;
    medianIdx, axis: INTEGER;
    test: BOOLEAN;
BEGIN
    test := TRUE;
    data[0][0] := 3.0; data[0][1] := 7.0;
    data[1][0] := 1.0; data[1][1] := 5.0;
    data[2][0] := 4.0; data[2][1] := 2.0;
    data[3][0] := 2.0; data[3][1] := 8.0;
    data[4][0] := 5.0; data[4][1] := 1.0;

    axis := 0;
    medianIdx := QuickSelect.Select(data, 0, 4, 2, axis);

    (* The median value along axis 0 should be 3.0 *)
    Tests.ExpectedInt(2, medianIdx, "QuickSelect median index should be 2", test);
    Tests.ExpectedReal(3.0, data[medianIdx][axis], "QuickSelect median value should be 3.0", test);

    RETURN test
END TestQuickSelect;

PROCEDURE TestKDTree*(): BOOLEAN;
VAR
    data: ARRAY 5 OF KDTree.Point;
    tree: KDTree.KDTree;
    node: KDTree.KDNode;
    i: INTEGER;
    test: BOOLEAN;
BEGIN
    test := TRUE;
    data[0][0] := 3.0; data[0][1] := 7.0;
    data[1][0] := 1.0; data[1][1] := 5.0;
    data[2][0] := 4.0; data[2][1] := 2.0;
    data[3][0] := 2.0; data[3][1] := 8.0;
    data[4][0] := 5.0; data[4][1] := 1.0;

    KDTree.Init(tree, 2);
    KDTree.Build(tree, data, 0);
    node := tree.root;

    Tests.ExpectedBool(TRUE, node # NIL, "KDTree root should not be NIL", test);
    IF node # NIL THEN
        Tests.ExpectedInt(0, node.axis, "KDTree root axis should be 0", test);
        Tests.ExpectedReal(3.0, node.point[0], "KDTree root point[0] should be 3.0", test);
        Tests.ExpectedReal(7.0, node.point[1], "KDTree root point[1] should be 7.0", test);
    END;

    RETURN test
END TestKDTree;

PROCEDURE TestKNN*(): BOOLEAN;
VAR
    data: ARRAY 5 OF KDTree.Point;
    tree: KDTree.KDTree;
    neighbors: KNN.NeighborList;
    query: KDTree.Point;
    count, i, j, k: INTEGER;
    test: BOOLEAN;
    tmp: KNN.Neighbor;
BEGIN
    test := TRUE;
    data[0][0] := 3.0; data[0][1] := 7.0;
    data[1][0] := 1.0; data[1][1] := 5.0;
    data[2][0] := 4.0; data[2][1] := 2.0;
    data[3][0] := 2.0; data[3][1] := 8.0;
    data[4][0] := 5.0; data[4][1] := 1.0;

    KDTree.Init(tree, 2);
    KDTree.Build(tree, data, 0);

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

    Tests.ExpectedInt(2, count, "KNN should return 2 neighbors", test);
    Tests.ExpectedReal(1.0, neighbors[0].point[0], "KNN nearest neighbor x should be 1.0", test);
    Tests.ExpectedReal(5.0, neighbors[0].point[1], "KNN nearest neighbor y should be 5.0", test);

    RETURN test
END TestKNN;

BEGIN
    Tests.Init(ts, "KNN Tests");
    Tests.Add(ts, TestQuickSelect);
    Tests.Add(ts, TestKDTree);
    Tests.Add(ts, TestKNN);
    ASSERT(Tests.Run(ts));
END TestKnn.