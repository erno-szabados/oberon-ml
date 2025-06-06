(*
    TestDequeue.Mod - Unit tests for Dequeue.Mod
    Copyright (C) 2025
    Released under The 3-Clause BSD License.
*)
MODULE TestDequeue;

IMPORT Dequeue, Collections, Tests;

TYPE
    TestItem = RECORD (Dequeue.Item)
        value: INTEGER
    END;
    TestItemPtr = POINTER TO TestItem;
    TestVisitorState = RECORD (Collections.VisitorState)
        sum, count: INTEGER
    END;

VAR
    ts: Tests.TestSet;

PROCEDURE NewItem(val: INTEGER): TestItemPtr;
VAR item: TestItemPtr;
BEGIN
    NEW(item);
    item.value := val;
    item.next := NIL;
    item.prev := NIL;
    RETURN item
END NewItem;

PROCEDURE Visitor(item: Collections.ItemPtr; VAR state: Collections.VisitorState): BOOLEAN;
BEGIN
    state(TestVisitorState).sum := state(TestVisitorState).sum + item(TestItemPtr).value;
    INC(state(TestVisitorState).count);
    RETURN TRUE
END Visitor;

PROCEDURE TestNewAndIsEmpty(): BOOLEAN;
VAR dq: Dequeue.Dequeue; pass: BOOLEAN;
BEGIN
    pass := TRUE;
    dq := Dequeue.New();
    IF ~Dequeue.IsEmpty(dq) THEN pass := FALSE END;
    IF Dequeue.Count(dq) # 0 THEN pass := FALSE END;
    Dequeue.Free(dq);
    RETURN pass
END TestNewAndIsEmpty;

PROCEDURE TestAppendAndRemove(): BOOLEAN;
VAR dq: Dequeue.Dequeue; a, b, c: TestItemPtr; res: Dequeue.ItemPtr; pass: BOOLEAN;
BEGIN
    pass := TRUE;
    dq := Dequeue.New();
    a := NewItem(1); b := NewItem(2); c := NewItem(3);
    Dequeue.Append(dq, a);
    Dequeue.Append(dq, b);
    Dequeue.Append(dq, c);
    IF Dequeue.IsEmpty(dq) THEN pass := FALSE END;
    IF Dequeue.Count(dq) # 3 THEN pass := FALSE END;
    Dequeue.RemoveFirst(dq, res);
    IF res # a THEN pass := FALSE END;
    Dequeue.RemoveLast(dq, res);
    IF res # c THEN pass := FALSE END;
    Dequeue.RemoveFirst(dq, res);
    IF res # b THEN pass := FALSE END;
    IF ~Dequeue.IsEmpty(dq) THEN pass := FALSE END;
    Dequeue.Free(dq);
    RETURN pass
END TestAppendAndRemove;

PROCEDURE TestPrependAndRemove(): BOOLEAN;
VAR dq: Dequeue.Dequeue; a, b, c: TestItemPtr; res: Dequeue.ItemPtr; pass: BOOLEAN;
BEGIN
    pass := TRUE;
    dq := Dequeue.New();
    a := NewItem(1); b := NewItem(2); c := NewItem(3);
    Dequeue.Prepend(dq, a);
    Dequeue.Prepend(dq, b);
    Dequeue.Prepend(dq, c);
    IF Dequeue.Count(dq) # 3 THEN pass := FALSE END;
    Dequeue.RemoveFirst(dq, res);
    IF res # c THEN pass := FALSE END;
    Dequeue.RemoveLast(dq, res);
    IF res # a THEN pass := FALSE END;
    Dequeue.RemoveFirst(dq, res);
    IF res # b THEN pass := FALSE END;
    IF ~Dequeue.IsEmpty(dq) THEN pass := FALSE END;
    Dequeue.Free(dq);
    RETURN pass
END TestPrependAndRemove;

PROCEDURE TestForeach(): BOOLEAN;
VAR dq: Dequeue.Dequeue; a, b, c: TestItemPtr;
    state: TestVisitorState; pass: BOOLEAN;
BEGIN
    pass := TRUE;
    dq := Dequeue.New();
    a := NewItem(1); b := NewItem(2); c := NewItem(3);
    Dequeue.Append(dq, a); Dequeue.Append(dq, b); Dequeue.Append(dq, c);
    state.sum := 0; state.count := 0;
    Dequeue.Foreach(dq, Visitor, state);
    IF (state.sum # 6) OR (state.count # 3) THEN pass := FALSE END;
    Dequeue.Free(dq);
    RETURN pass
END TestForeach;

BEGIN
    Tests.Init(ts, "Dequeue Tests");
    Tests.Add(ts, TestNewAndIsEmpty);
    Tests.Add(ts, TestAppendAndRemove);
    Tests.Add(ts, TestPrependAndRemove);
    Tests.Add(ts, TestForeach);
    ASSERT(Tests.Run(ts));
END TestDequeue.
