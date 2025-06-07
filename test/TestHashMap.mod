(** TestHashMap.mod - Tests for HashMap.mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE TestHashMap;

IMPORT HashMap, Collections, Tests;

TYPE
    (* Test item extending Collections.Item *)
    TestItem = RECORD(Collections.Item)
        value: INTEGER
    END;
    TestItemPtr = POINTER TO TestItem;
    
    (* Visitor state for testing iteration *)
    TestVisitorState = RECORD(Collections.VisitorState)
        sum: INTEGER;
        count: INTEGER
    END;

VAR
    ts: Tests.TestSet;

(** Create a new test item *)
PROCEDURE NewTestItem(value: INTEGER): TestItemPtr;
VAR item: TestItemPtr;
BEGIN
    NEW(item);
    item.value := value;
    RETURN item
END NewTestItem;

(** Visitor procedure for testing iteration *)
PROCEDURE Visitor(item: Collections.ItemPtr; VAR state: Collections.VisitorState): BOOLEAN;
VAR 
    pair: HashMap.KeyValuePairPtr;
    testItem: TestItemPtr;
BEGIN
    pair := item(HashMap.KeyValuePairPtr);
    testItem := pair.value(TestItemPtr);
    
    state(TestVisitorState).sum := state(TestVisitorState).sum + testItem.value;
    INC(state(TestVisitorState).count);
    
    (* Continue iteration *)
    RETURN TRUE
END Visitor;

PROCEDURE TestNewAndFree*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    
    map := HashMap.New();
    Tests.ExpectedBool(TRUE, map # NIL, "HashMap.New should return non-nil", pass);
    Tests.ExpectedBool(TRUE, HashMap.IsEmpty(map), "New hashmap should be empty", pass);
    Tests.ExpectedInt(0, HashMap.Count(map), "New hashmap should have count 0", pass);
    
    HashMap.Free(map);
    Tests.ExpectedBool(TRUE, map = NIL, "HashMap.Free should set map to NIL", pass);
    
    RETURN pass
END TestNewAndFree;

PROCEDURE TestNewWithSize*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    
    map := HashMap.NewWithSize(32);
    Tests.ExpectedBool(TRUE, map # NIL, "HashMap.NewWithSize should return non-nil", pass);
    Tests.ExpectedBool(TRUE, HashMap.IsEmpty(map), "New hashmap should be empty", pass);
    Tests.ExpectedInt(0, HashMap.Count(map), "New hashmap should have count 0", pass);
    
    HashMap.Free(map);
    
    (* Test with invalid size *)
    map := HashMap.NewWithSize(-1);
    Tests.ExpectedBool(TRUE, map # NIL, "HashMap.NewWithSize with negative size should return non-nil", pass);
    HashMap.Free(map);
    
    RETURN pass
END TestNewWithSize;

PROCEDURE TestPutAndGet*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    item1, item2, item3, retrieved: TestItemPtr;
    value: Collections.ItemPtr;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    map := HashMap.New();
    
    item1 := NewTestItem(100);
    item2 := NewTestItem(200);
    item3 := NewTestItem(300);
    
    (* Put some values *)
    HashMap.Put(map, 1, item1);
    HashMap.Put(map, 2, item2);
    HashMap.Put(map, 3, item3);
    
    Tests.ExpectedInt(3, HashMap.Count(map), "Count should be 3 after 3 puts", pass);
    Tests.ExpectedBool(FALSE, HashMap.IsEmpty(map), "Map should not be empty", pass);
    
    (* Get the values *)
    IF HashMap.Get(map, 1, value) THEN
        retrieved := value(TestItemPtr);
        Tests.ExpectedInt(100, retrieved.value, "Get key 1 should return item with value 100", pass);
    ELSE
        Tests.ExpectedBool(TRUE, FALSE, "Get key 1 should succeed", pass);
    END;
    
    IF HashMap.Get(map, 2, value) THEN
        retrieved := value(TestItemPtr);
        Tests.ExpectedInt(200, retrieved.value, "Get key 2 should return item with value 200", pass);
    ELSE
        Tests.ExpectedBool(TRUE, FALSE, "Get key 2 should succeed", pass);
    END;
    
    IF HashMap.Get(map, 3, value) THEN
        retrieved := value(TestItemPtr);
        Tests.ExpectedInt(300, retrieved.value, "Get key 3 should return item with value 300", pass);
    ELSE
        Tests.ExpectedBool(TRUE, FALSE, "Get key 3 should succeed", pass);
    END;
    
    (* Try to get non-existent key *)
    Tests.ExpectedBool(FALSE, HashMap.Get(map, 999, value), "Get non-existent key should return FALSE", pass);
    
    HashMap.Free(map);
    RETURN pass
END TestPutAndGet;

PROCEDURE TestUpdateExistingKey*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    item1, item2, retrieved: TestItemPtr;
    value: Collections.ItemPtr;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    map := HashMap.New();
    
    item1 := NewTestItem(100);
    item2 := NewTestItem(999);
    
    (* Put initial value *)
    HashMap.Put(map, 42, item1);
    Tests.ExpectedInt(1, HashMap.Count(map), "Count should be 1 after first put", pass);
    
    (* Update with new value *)
    HashMap.Put(map, 42, item2);
    Tests.ExpectedInt(1, HashMap.Count(map), "Count should still be 1 after update", pass);
    
    (* Verify the updated value *)
    IF HashMap.Get(map, 42, value) THEN
        retrieved := value(TestItemPtr);
        Tests.ExpectedInt(999, retrieved.value, "Updated value should be 999", pass);
    ELSE
        Tests.ExpectedBool(TRUE, FALSE, "Get after update should succeed", pass);
    END;
    
    HashMap.Free(map);
    RETURN pass
END TestUpdateExistingKey;

PROCEDURE TestContains*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    item1: TestItemPtr;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    map := HashMap.New();
    
    item1 := NewTestItem(100);
    
    (* Test non-existent key *)
    Tests.ExpectedBool(FALSE, HashMap.Contains(map, 1), "Contains should return FALSE for non-existent key", pass);
    
    (* Add a key and test *)
    HashMap.Put(map, 1, item1);
    Tests.ExpectedBool(TRUE, HashMap.Contains(map, 1), "Contains should return TRUE for existing key", pass);
    Tests.ExpectedBool(FALSE, HashMap.Contains(map, 2), "Contains should return FALSE for different key", pass);
    
    HashMap.Free(map);
    RETURN pass
END TestContains;

PROCEDURE TestRemove*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    item1, item2: TestItemPtr;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    map := HashMap.New();
    
    item1 := NewTestItem(100);
    item2 := NewTestItem(200);
    
    (* Put some values *)
    HashMap.Put(map, 1, item1);
    HashMap.Put(map, 2, item2);
    Tests.ExpectedInt(2, HashMap.Count(map), "Count should be 2 after puts", pass);
    
    (* Remove existing key *)
    Tests.ExpectedBool(TRUE, HashMap.Remove(map, 1), "Remove existing key should return TRUE", pass);
    Tests.ExpectedInt(1, HashMap.Count(map), "Count should be 1 after remove", pass);
    Tests.ExpectedBool(FALSE, HashMap.Contains(map, 1), "Removed key should not exist", pass);
    Tests.ExpectedBool(TRUE, HashMap.Contains(map, 2), "Other key should still exist", pass);
    
    (* Try to remove non-existent key *)
    Tests.ExpectedBool(FALSE, HashMap.Remove(map, 999), "Remove non-existent key should return FALSE", pass);
    Tests.ExpectedInt(1, HashMap.Count(map), "Count should be unchanged", pass);
    
    (* Remove last key *)
    Tests.ExpectedBool(TRUE, HashMap.Remove(map, 2), "Remove last key should return TRUE", pass);
    Tests.ExpectedInt(0, HashMap.Count(map), "Count should be 0 after removing all", pass);
    Tests.ExpectedBool(TRUE, HashMap.IsEmpty(map), "Map should be empty after removing all", pass);
    
    HashMap.Free(map);
    RETURN pass
END TestRemove;

PROCEDURE TestLoadFactor*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    item1, item2: TestItemPtr;
    loadFactor: INTEGER;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    map := HashMap.NewWithSize(4); (* Small size for testing *)
    
    Tests.ExpectedInt(0, HashMap.LoadFactor(map), "Empty map should have 0 load factor", pass);
    
    item1 := NewTestItem(100);
    
    (* Add one item: 1/4 = 25% *)
    HashMap.Put(map, 1, item1);
    loadFactor := HashMap.LoadFactor(map);
    Tests.ExpectedInt(25, loadFactor, "Load factor should be 25% with 1/4 buckets used", pass);
    
    item2 := NewTestItem(200);
    
    (* Add more items *)
    HashMap.Put(map, 2, item2);
    loadFactor := HashMap.LoadFactor(map);
    Tests.ExpectedInt(50, loadFactor, "Load factor should be 50% with 2/4 buckets used", pass);
    
    HashMap.Free(map);
    RETURN pass
END TestLoadFactor;

PROCEDURE TestForeach*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    item1, item2, item3: TestItemPtr;
    state: TestVisitorState;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    map := HashMap.New();
    
    item1 := NewTestItem(10);
    item2 := NewTestItem(20);
    item3 := NewTestItem(30);
    
    HashMap.Put(map, 1, item1);
    HashMap.Put(map, 2, item2);
    HashMap.Put(map, 3, item3);
    
    state.sum := 0;
    state.count := 0;
    
    HashMap.Foreach(map, Visitor, state);
    
    Tests.ExpectedInt(60, state.sum, "Sum of all values should be 60", pass);
    Tests.ExpectedInt(3, state.count, "Should visit 3 items", pass);
    
    HashMap.Free(map);
    RETURN pass
END TestForeach;

PROCEDURE TestCollisionHandling*(): BOOLEAN;
VAR 
    map: HashMap.HashMap;
    item1, item2, item3: TestItemPtr;
    value: Collections.ItemPtr;
    retrieved: TestItemPtr;
    pass: BOOLEAN;
BEGIN
    pass := TRUE;
    map := HashMap.NewWithSize(2); (* Very small size to force collisions *)
    
    item1 := NewTestItem(100);
    item2 := NewTestItem(200);
    item3 := NewTestItem(300);
    
    (* Put multiple items that will likely collide *)
    HashMap.Put(map, 1, item1);
    HashMap.Put(map, 3, item2); (* Should hash to same bucket in size-2 map *)
    HashMap.Put(map, 5, item3); (* Should also collide *)
    
    Tests.ExpectedInt(3, HashMap.Count(map), "Count should be 3 despite collisions", pass);
    
    (* Verify we can retrieve all items *)
    IF HashMap.Get(map, 1, value) THEN
        retrieved := value(TestItemPtr);
        Tests.ExpectedInt(100, retrieved.value, "Should retrieve first item correctly", pass);
    ELSE
        Tests.ExpectedBool(TRUE, FALSE, "Should be able to get first item", pass);
    END;
    
    IF HashMap.Get(map, 3, value) THEN
        retrieved := value(TestItemPtr);
        Tests.ExpectedInt(200, retrieved.value, "Should retrieve second item correctly", pass);
    ELSE
        Tests.ExpectedBool(TRUE, FALSE, "Should be able to get second item", pass);
    END;
    
    IF HashMap.Get(map, 5, value) THEN
        retrieved := value(TestItemPtr);
        Tests.ExpectedInt(300, retrieved.value, "Should retrieve third item correctly", pass);
    ELSE
        Tests.ExpectedBool(TRUE, FALSE, "Should be able to get third item", pass);
    END;
    
    (* Test removal with collisions *)
    Tests.ExpectedBool(TRUE, HashMap.Remove(map, 3), "Should be able to remove middle colliding item", pass);
    Tests.ExpectedInt(2, HashMap.Count(map), "Count should be 2 after removal", pass);
    Tests.ExpectedBool(FALSE, HashMap.Contains(map, 3), "Removed item should not be found", pass);
    Tests.ExpectedBool(TRUE, HashMap.Contains(map, 1), "Other items should still exist", pass);
    Tests.ExpectedBool(TRUE, HashMap.Contains(map, 5), "Other items should still exist", pass);
    
    HashMap.Free(map);
    RETURN pass
END TestCollisionHandling;

BEGIN
    Tests.Init(ts, "HashMap Tests");
    Tests.Add(ts, TestNewAndFree);
    Tests.Add(ts, TestNewWithSize);
    Tests.Add(ts, TestPutAndGet);
    Tests.Add(ts, TestUpdateExistingKey);
    Tests.Add(ts, TestContains);
    Tests.Add(ts, TestRemove);
    Tests.Add(ts, TestLoadFactor);
    Tests.Add(ts, TestForeach);
    Tests.Add(ts, TestCollisionHandling);
    ASSERT(Tests.Run(ts));
END TestHashMap.
