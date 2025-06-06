(** TestLinkedList.Mod - Tests for LinkedList.Mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE TestLinkedList;

IMPORT LinkedList, Collections, Tests;

TYPE
  TestNode = RECORD (Collections.ListItem)
    value: INTEGER
  END;
  TestNodePtr = POINTER TO TestNode;

  TestVisitorState = RECORD (Collections.VisitorState)
    sum, count: INTEGER
  END;

VAR
  ts : Tests.TestSet;

PROCEDURE Visitor(item: Collections.ListItemPtr; VAR state: Collections.VisitorState): BOOLEAN;
BEGIN
  state(TestVisitorState).sum := state(TestVisitorState).sum + item(TestNodePtr).value;
  INC(state(TestVisitorState).count);
  RETURN TRUE
END Visitor;

PROCEDURE VisitorEarlyStop(item: Collections.ListItemPtr; VAR state: Collections.VisitorState): BOOLEAN;
BEGIN
  state(TestVisitorState).sum := state(TestVisitorState).sum + item(TestNodePtr).value;
  INC(state(TestVisitorState).count);
  RETURN state(TestVisitorState).count < 2
END VisitorEarlyStop;

PROCEDURE NewNode(val: INTEGER): TestNodePtr;
VAR node: TestNodePtr;
BEGIN
  NEW(node);
  node.value := val;
  node.next := NIL;
  RETURN node
END NewNode;

PROCEDURE TestNewAndIsEmpty(): BOOLEAN;
VAR list: LinkedList.List; pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := LinkedList.New();
  IF ~LinkedList.IsEmpty(list) THEN pass := FALSE END;
  IF LinkedList.Count(list) # 0 THEN pass := FALSE END;
  LinkedList.Free(list);
  RETURN pass
END TestNewAndIsEmpty;

PROCEDURE TestAppendAndRemove(): BOOLEAN;
VAR 
    list: LinkedList.List; 
    n1, n2, n3: TestNodePtr;
    out: Collections.ListItemPtr;
    pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := LinkedList.New();
  n1 := NewNode(1); n2 := NewNode(2); n3 := NewNode(3);

  LinkedList.Append(list, n1);
  IF LinkedList.Count(list) # 1 THEN pass := FALSE END;

  LinkedList.Append(list, n2);
  IF LinkedList.Count(list) # 2 THEN pass := FALSE END;

  LinkedList.Append(list, n3);
  IF LinkedList.Count(list) # 3 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # n1 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 2 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # n2 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 1 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # n3 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 0 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # NIL THEN pass := FALSE END;
  IF LinkedList.Count(list) # 0 THEN pass := FALSE END;

  LinkedList.Free(list);
  RETURN pass
END TestAppendAndRemove;

PROCEDURE TestInsertAfter(): BOOLEAN;
VAR
  list: LinkedList.List;
  n1, n2, n3, n4, n5, n99: TestNodePtr;
  pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := LinkedList.New();
  n1 := NewNode(1); n2 := NewNode(2); n3 := NewNode(3); n4 := NewNode(4);

  LinkedList.Append(list, n1);
  LinkedList.Append(list, n2);
  LinkedList.Append(list, n4); (* List: n1 -> n2 -> n4 *)

  LinkedList.InsertAfter(list, n2, n3); (* Insert n3 after n2: n1 -> n2 -> n3 -> n4 *)

  IF n2.next # n3 THEN pass := FALSE END;
  IF n3.next # n4 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 4 THEN pass := FALSE END;

  (* Insert after tail, should update tail *)
  n5 := NewNode(5);
  LinkedList.InsertAfter(list, n4, n5);
  IF LinkedList.Count(list) # 5 THEN pass := FALSE END;

  (* Insert after NIL should do nothing *)
  n99 := NewNode(99);
  LinkedList.InsertAfter(list, NIL, n99);
  IF LinkedList.Count(list) # 5 THEN pass := FALSE END;

  LinkedList.Free(list);
  RETURN pass
END TestInsertAfter;

PROCEDURE TestForeach(): BOOLEAN;
VAR
  list: LinkedList.List;
  n1, n2, n3: TestNodePtr;
  state: TestVisitorState;
  pass: BOOLEAN;
BEGIN
  pass := TRUE;
  list := LinkedList.New();
  n1 := NewNode(10); n2 := NewNode(20); n3 := NewNode(30);
  LinkedList.Append(list, n1);
  LinkedList.Append(list, n2);
  LinkedList.Append(list, n3);

  state.sum := 0; state.count := 0;
  LinkedList.Foreach(list, Visitor, state);
  IF (state.sum # 60) OR (state.count # 3) THEN pass := FALSE END;

  state.sum := 0; state.count := 0;
  LinkedList.Foreach(list, VisitorEarlyStop, state);
  IF (state.sum # 30) OR (state.count # 2) THEN pass := FALSE END;

  LinkedList.Free(list);
  RETURN pass
END TestForeach;

BEGIN
  Tests.Init(ts, "LinkedList Tests");
  Tests.Add(ts, TestNewAndIsEmpty);
  Tests.Add(ts, TestAppendAndRemove);
  Tests.Add(ts, TestInsertAfter);
  Tests.Add(ts, TestForeach);
  ASSERT(Tests.Run(ts));
END TestLinkedList.