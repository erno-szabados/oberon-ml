(** TestDoubleLinkedList.Mod - Tests for DoubleLinkedList.Mod.

Copyright (C) 2025
Released under The 3-Clause BSD License.
*)

MODULE TestDoubleLinkedList;

IMPORT DoubleLinkedList, Collections, Tests;

TYPE
  TestNode = RECORD (DoubleLinkedList.ListItem)
    value: INTEGER
  END;
  TestNodePtr = POINTER TO TestNode;

  TestVisitorState = RECORD (Collections.VisitorState)
    sum, count: INTEGER
  END;

VAR
  ts : Tests.TestSet;

PROCEDURE NewNode(val: INTEGER): TestNodePtr;
VAR node: TestNodePtr;
BEGIN
  NEW(node);
  node.value := val;
  node.next := NIL;
  node.prev := NIL;
  RETURN node
END NewNode;

PROCEDURE Visitor(item: Collections.ItemPtr; VAR state: Collections.VisitorState): BOOLEAN;
BEGIN
  state(TestVisitorState).sum := state(TestVisitorState).sum + item(TestNodePtr).value;
  INC(state(TestVisitorState).count);
  RETURN TRUE
END Visitor;

PROCEDURE VisitorEarlyStop(item: Collections.ItemPtr; VAR state: Collections.VisitorState): BOOLEAN;
BEGIN
  state(TestVisitorState).sum := state(TestVisitorState).sum + item(TestNodePtr).value;
  INC(state(TestVisitorState).count);
  RETURN state(TestVisitorState).count < 2
END VisitorEarlyStop;

PROCEDURE TestNewAndIsEmpty(): BOOLEAN;
VAR list: DoubleLinkedList.List; pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := DoubleLinkedList.New();
  IF ~DoubleLinkedList.IsEmpty(list) THEN pass := FALSE END;
  IF DoubleLinkedList.Count(list) # 0 THEN pass := FALSE END;
  DoubleLinkedList.Free(list);
  RETURN pass
END TestNewAndIsEmpty;

PROCEDURE TestAppendAndRemove(): BOOLEAN;
VAR 
    list: DoubleLinkedList.List; 
    n1, n2, n3: TestNodePtr;
    out: DoubleLinkedList.ListItemPtr;
    pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := DoubleLinkedList.New();
  n1 := NewNode(1); n2 := NewNode(2); n3 := NewNode(3);

  DoubleLinkedList.Append(list, n1);
  IF DoubleLinkedList.Count(list) # 1 THEN pass := FALSE END;

  DoubleLinkedList.Append(list, n2);
  IF DoubleLinkedList.Count(list) # 2 THEN pass := FALSE END;

  DoubleLinkedList.Append(list, n3);
  IF DoubleLinkedList.Count(list) # 3 THEN pass := FALSE END;

  DoubleLinkedList.RemoveFirst(list, out);
  IF out # n1 THEN pass := FALSE END;
  IF DoubleLinkedList.Count(list) # 2 THEN pass := FALSE END;

  DoubleLinkedList.RemoveLast(list, out);
  IF out # n3 THEN pass := FALSE END;
  IF DoubleLinkedList.Count(list) # 1 THEN pass := FALSE END;

  DoubleLinkedList.RemoveFirst(list, out);
  IF out # n2 THEN pass := FALSE END;
  IF DoubleLinkedList.Count(list) # 0 THEN pass := FALSE END;

  DoubleLinkedList.RemoveFirst(list, out);
  IF out # NIL THEN pass := FALSE END;
  IF DoubleLinkedList.Count(list) # 0 THEN pass := FALSE END;

  DoubleLinkedList.Free(list);
  RETURN pass
END TestAppendAndRemove;

PROCEDURE TestIsEmpty(): BOOLEAN;
VAR 
    list: DoubleLinkedList.List; 
    n: TestNodePtr; 
    out: DoubleLinkedList.ListItemPtr;
    pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := DoubleLinkedList.New();
  IF ~DoubleLinkedList.IsEmpty(list) THEN pass := FALSE END;
  n := NewNode(42);
  DoubleLinkedList.Append(list, n);
  IF DoubleLinkedList.IsEmpty(list) THEN pass := FALSE END;
  DoubleLinkedList.RemoveFirst(list, out);
  IF ~DoubleLinkedList.IsEmpty(list) THEN pass := FALSE END;
  DoubleLinkedList.Free(list);
  RETURN pass
END TestIsEmpty;

PROCEDURE TestInsertAfterBefore(): BOOLEAN;
VAR
  list: DoubleLinkedList.List;
  n1, n2, n3, n4, n5, n6, n0, n99, nm1: TestNodePtr;
  pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := DoubleLinkedList.New();
  n1 := NewNode(1); n2 := NewNode(2); n3 := NewNode(3); n4 := NewNode(4); n5 := NewNode(5);

  DoubleLinkedList.Append(list, n1);
  DoubleLinkedList.Append(list, n3);
  DoubleLinkedList.Append(list, n5); (* List: n1 <-> n3 <-> n5 *)

  DoubleLinkedList.InsertAfter(list, n1, n2); (* n1 <-> n2 <-> n3 <-> n5 *)
  IF n1.next # n2 THEN pass := FALSE END;
  IF n2.prev # n1 THEN pass := FALSE END;
  IF n2.next # n3 THEN pass := FALSE END;
  IF n3.prev # n2 THEN pass := FALSE END;
  IF DoubleLinkedList.Count(list) # 4 THEN pass := FALSE END;

  DoubleLinkedList.InsertBefore(list, n5, n4); (* n1 <-> n2 <-> n3 <-> n4 <-> n5 *)
  IF n4.next # n5 THEN pass := FALSE END;
  IF n5.prev # n4 THEN pass := FALSE END;
  IF n3.next # n4 THEN pass := FALSE END;
  IF n4.prev # n3 THEN pass := FALSE END;
  IF DoubleLinkedList.Count(list) # 5 THEN pass := FALSE END;

  (* Insert after tail, should update tail *)
  n6 := NewNode(6);
  DoubleLinkedList.InsertAfter(list, n5, n6);
  IF DoubleLinkedList.Count(list) # 6 THEN pass := FALSE END;

  (* Insert before head, should update head *)
  n0 := NewNode(0);
  DoubleLinkedList.InsertBefore(list, n1, n0);
  IF DoubleLinkedList.Count(list) # 7 THEN pass := FALSE END;

  (* Insert after NIL should do nothing *)
  n99 := NewNode(99);
  DoubleLinkedList.InsertAfter(list, NIL, n99);
  IF DoubleLinkedList.Count(list) # 7 THEN pass := FALSE END;

  (* Insert before NIL should do nothing *)
  nm1 := NewNode(-1);
  DoubleLinkedList.InsertBefore(list, NIL, nm1);
  IF DoubleLinkedList.Count(list) # 7 THEN pass := FALSE END;

  DoubleLinkedList.Free(list);
  RETURN pass
END TestInsertAfterBefore;

PROCEDURE TestForeach(): BOOLEAN;
VAR
  list: DoubleLinkedList.List;
  n1, n2, n3: TestNodePtr;
  state: TestVisitorState;
  pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := DoubleLinkedList.New();
  n1 := NewNode(10); n2 := NewNode(20); n3 := NewNode(30);
  DoubleLinkedList.Append(list, n1);
  DoubleLinkedList.Append(list, n2);
  DoubleLinkedList.Append(list, n3);

  state.sum := 0; state.count := 0;
  DoubleLinkedList.Foreach(list, Visitor, state);
  IF (state.sum # 60) OR (state.count # 3) THEN pass := FALSE END;

  state.sum := 0; state.count := 0;
  DoubleLinkedList.Foreach(list, VisitorEarlyStop, state);
  IF (state.sum # 30) OR (state.count # 2) THEN pass := FALSE END;

  DoubleLinkedList.Free(list);
  RETURN pass
END TestForeach;

BEGIN
  Tests.Init(ts, "DoubleLinkedList Tests");
  Tests.Add(ts, TestNewAndIsEmpty);
  Tests.Add(ts, TestAppendAndRemove);
  Tests.Add(ts, TestIsEmpty);
  Tests.Add(ts, TestInsertAfterBefore);
  Tests.Add(ts, TestForeach);
  ASSERT(Tests.Run(ts));
END TestDoubleLinkedList.
