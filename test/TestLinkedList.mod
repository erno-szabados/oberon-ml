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

(*
  Visitor procedures for Foreach: 
  - These are top-level procedures because Oberon-07 does not support closures or nested procedure variable capture.
  - The state is passed explicitly as a VAR parameter, allowing reentrancy and multiple traversals.
  - The user must provide a VisitorState or extension as needed.
  - This pattern allows Foreach to be used for both full traversal and early exit by returning FALSE from the visitor.
*)
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

PROCEDURE TestInit(): BOOLEAN;
VAR list: LinkedList.List; pass: BOOLEAN;
BEGIN
  pass := TRUE;
  LinkedList.Init(list);
  IF list.head # NIL THEN pass := FALSE END;
  IF list.tail # NIL THEN pass := FALSE END;
  IF LinkedList.Count(list) # 0 THEN pass := FALSE END;
  RETURN pass
END TestInit;

PROCEDURE TestAppendAndRemove(): BOOLEAN;
VAR 
    list: LinkedList.List; 
    n1, n2, n3: TestNodePtr;
    out: Collections.ListItemPtr;
    pass: BOOLEAN;
BEGIN
  pass := TRUE;
  LinkedList.Init(list);
  n1 := NewNode(1); n2 := NewNode(2); n3 := NewNode(3);

  LinkedList.Append(list, n1);
  IF list.head # n1 THEN pass := FALSE END;
  IF list.tail # n1 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 1 THEN pass := FALSE END;

  LinkedList.Append(list, n2);
  IF list.head # n1 THEN pass := FALSE END;
  IF list.tail # n2 THEN pass := FALSE END;
  IF n1.next # n2 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 2 THEN pass := FALSE END;

  LinkedList.Append(list, n3);
  IF list.tail # n3 THEN pass := FALSE END;
  IF n2.next # n3 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 3 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # n1 THEN pass := FALSE END;
  IF list.head # n2 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 2 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # n2 THEN pass := FALSE END;
  IF list.head # n3 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 1 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # n3 THEN pass := FALSE END;
  IF list.head # NIL THEN pass := FALSE END;
  IF list.tail # NIL THEN pass := FALSE END;
  IF LinkedList.Count(list) # 0 THEN pass := FALSE END;

  LinkedList.RemoveFirst(list, out);
  IF out # NIL THEN pass := FALSE END;
  IF LinkedList.Count(list) # 0 THEN pass := FALSE END;

  RETURN pass
END TestAppendAndRemove;

PROCEDURE TestIsEmpty(): BOOLEAN;
VAR 
    list: LinkedList.List; 
    n: TestNodePtr; 
    out: Collections.ListItemPtr;
    pass: BOOLEAN;
BEGIN
  pass := TRUE;
  LinkedList.Init(list);
  IF ~LinkedList.IsEmpty(list) THEN pass := FALSE END;
  n := NewNode(42);
  LinkedList.Append(list, n);
  IF LinkedList.IsEmpty(list) THEN pass := FALSE END;
  LinkedList.RemoveFirst(list, out);
  IF ~LinkedList.IsEmpty(list) THEN pass := FALSE END;
  RETURN pass
END TestIsEmpty;

PROCEDURE TestInsertAfter(): BOOLEAN;
VAR
  list: LinkedList.List;
  n1, n2, n3, n4: TestNodePtr;
  pass: BOOLEAN;
BEGIN
  pass := TRUE;
  LinkedList.Init(list);
  n1 := NewNode(1); n2 := NewNode(2); n3 := NewNode(3); n4 := NewNode(4);

  LinkedList.Append(list, n1);
  LinkedList.Append(list, n2);
  LinkedList.Append(list, n4); (* List: n1 -> n2 -> n4 *)

  LinkedList.InsertAfter(list, n2, n3); (* Insert n3 after n2: n1 -> n2 -> n3 -> n4 *)

  IF n2.next # n3 THEN pass := FALSE END;
  IF n3.next # n4 THEN pass := FALSE END;
  IF list.tail # n4 THEN pass := FALSE END;
  IF LinkedList.Count(list) # 4 THEN pass := FALSE END;

  (* Insert after tail, should update tail *)
  LinkedList.InsertAfter(list, n4, NewNode(5));
  IF (list.tail IS TestNodePtr) THEN
    IF list.tail(TestNodePtr).value # 5 THEN pass := FALSE END;
  END;
  IF LinkedList.Count(list) # 5 THEN pass := FALSE END;

  (* Insert after NIL should do nothing *)
  LinkedList.InsertAfter(list, NIL, NewNode(99));
  IF LinkedList.Count(list) # 5 THEN pass := FALSE END;

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
  LinkedList.Init(list);
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

  RETURN pass
END TestForeach;

BEGIN
  Tests.Init(ts, "LinkedList Tests");
  Tests.Add(ts, TestInit);
  Tests.Add(ts, TestAppendAndRemove);
  Tests.Add(ts, TestIsEmpty);
  Tests.Add(ts, TestInsertAfter);
  Tests.Add(ts, TestForeach);
  ASSERT(Tests.Run(ts));
END TestLinkedList.