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

VAR
  ts: Tests.TestSet;

PROCEDURE NewNode(val: INTEGER): TestNodePtr;
VAR node: TestNodePtr;
BEGIN
  NEW(node);
  node.value := val;
  node.next := NIL;
  RETURN node
END NewNode;

PROCEDURE TestInit*(): BOOLEAN;
VAR list: LinkedList.List; pass: BOOLEAN;
BEGIN
  pass := TRUE;
  LinkedList.Init(list);
  IF list.head # NIL THEN pass := FALSE END;
  IF list.tail # NIL THEN pass := FALSE END;
  IF LinkedList.Count(list) # 0 THEN pass := FALSE END;
  RETURN pass
END TestInit;

PROCEDURE TestAppendAndRemove*(): BOOLEAN;
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

PROCEDURE TestIsEmpty*(): BOOLEAN;
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

BEGIN
  Tests.Init(ts, "LinkedList Tests");
  Tests.Add(ts, TestInit);
  Tests.Add(ts, TestAppendAndRemove);
  Tests.Add(ts, TestIsEmpty);
  ASSERT(Tests.Run(ts));
END TestLinkedList.