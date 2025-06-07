# Collections in Oberon-ML

This document describes the collection modules implemented in Oberon-ML: `LinkedList`, `DoubleLinkedList`, and `Deque`. Each module provides a different type of collection with its own interface and use cases.

## Overview

- **LinkedList**: Singly-linked list for simple, linear data storage with position-based access.
- **DoubleLinkedList**: Doubly-linked list supporting bidirectional traversal and efficient insertions/removals at both ends.
- **Deque**: Double-ended queue built on `DoubleLinkedList`, supporting efficient insertion and removal at both ends.

## API Design Principles

The collections API follows modern software engineering principles:

1. **Information Hiding**: Internal structures (nodes, descriptors) are encapsulated and not exposed to client code.
2. **Position-Based Access**: Operations use 0-based indexing instead of exposing internal node references.
3. **Consistent Type System**: All collections use `Collections.ItemPtr` as the universal item type.
4. **Safe Error Handling**: Operations that can fail (like `GetAt`, `InsertAt`) return boolean success indicators.
5. **Uniform Interfaces**: Similar operations across different collection types have consistent signatures.

## Comparative Table

| LinkedList      | DoubleLinkedList         | Deque           |
|----------------|-------------------------|-----------------|
| New            | New                     | New             |
| Free           | Free                    | Free            |
| Append         | Append                  | Append          |
| -              | Prepend                 | Prepend         |
| InsertAt       | InsertAt                | -               |
| RemoveFirst    | RemoveFirst             | RemoveFirst     |
| -              | RemoveLast              | RemoveLast      |
| GetAt          | GetAt                   | -               |
| -              | Head                    | -               |
| -              | Tail                    | -               |
| Count          | Count                   | Count           |
| IsEmpty        | IsEmpty                 | IsEmpty         |
| Foreach        | Foreach                 | Foreach         |


## Module Summaries

### LinkedList
- **Purpose:** Simple, efficient singly-linked list.
- **Key Procedures:**
  - `New`, `Free`, `Append`, `RemoveFirst`, `InsertAt`, `GetAt`, `Count`, `IsEmpty`, `Foreach`
- **Notes:** Position-based access with 0-based indexing. Only supports removal from the front.

### DoubleLinkedList
- **Purpose:** More flexible list with bidirectional links.
- **Key Procedures:**
  - `New`, `Free`, `Append`, `Prepend`, `InsertAt`, `RemoveFirst`, `RemoveLast`, `GetAt`, `Head`, `Tail`, `Count`, `IsEmpty`, `Foreach`
- **Notes:** Position-based insertion and access with 0-based indexing. Supports removal from both ends and efficient access to head/tail elements.

### Deque
- **Purpose:** Double-ended queue for efficient insertion/removal at both ends.
- **Key Procedures:**
  - `New`, `Free`, `Append`, `Prepend`, `RemoveFirst`, `RemoveLast`, `Count`, `IsEmpty`, `Foreach`
- **Notes:** Built on `DoubleLinkedList` for efficiency and code reuse.

## Usage Example

```oberon
IMPORT LinkedList, Collections;

TYPE
    MyItem = RECORD (Collections.Item)
        value: INTEGER
    END;
    MyItemPtr = POINTER TO MyItem;

VAR 
    list: LinkedList.List;
    item: MyItemPtr;
    result: Collections.ItemPtr;
    success: BOOLEAN;

BEGIN
    list := LinkedList.New();
    
    (* Create and add items *)
    NEW(item); item.value := 42;
    LinkedList.Append(list, item);
    
    (* Insert at specific position *)
    NEW(item); item.value := 10;
    success := LinkedList.InsertAt(list, 0, item);
    
    (* Access items by position *)
    success := LinkedList.GetAt(list, 1, result);
    IF success THEN
        (* Use result(MyItemPtr).value *)
    END;
    
    LinkedList.Free(list);
END.
```

## Extending Collections

All collection modules work with items that extend the base `Collections.Item` type. The collections use `Collections.ItemPtr` (which is `POINTER TO Collections.Item`) as the universal item type, providing type safety while allowing flexibility.

### Information Hiding

The collection modules implement proper information hiding:
- **LinkedList** and **DoubleLinkedList** use opaque `List` types with internal node structures
- **Deque** uses an opaque `Deque` type built on `DoubleLinkedList`
- Internal implementation details (nodes, list descriptors) are not exposed
- Position-based access (`InsertAt`, `GetAt`) replaces direct node manipulation

### Type Safety

All collections use the common `Collections.ItemPtr` type, which ensures:
- Consistent interfaces across all collection types
- Type-safe operations with proper type guards when needed
- No module-specific item types that could cause confusion

Always use the provided procedures for manipulating collections to ensure safety and correctness.

## Operation Details

### Position-Based Operations

- **InsertAt(position, item)**: Inserts item at 0-based position, returns `TRUE` if successful
- **GetAt(position, VAR result)**: Retrieves item at position, returns `TRUE` if successful and sets `result`

### Access Operations (DoubleLinkedList only)

- **Head(VAR result)**: Gets first item, returns `TRUE` if list is not empty
- **Tail(VAR result)**: Gets last item, returns `TRUE` if list is not empty

### Removal Operations

- **RemoveFirst(VAR result)**: Removes first item, sets `result` to item (or `NIL` if empty)
- **RemoveLast(VAR result)**: Removes last item, sets `result` to item (or `NIL` if empty)

### Notes on Error Handling

- Position-based operations validate bounds and return `FALSE` for invalid positions
- Access operations on empty collections return `FALSE` and set result to `NIL`
- Removal from empty collections sets result to `NIL` but does not signal error

---

For detailed API documentation, see the respective `.def.html` files in the `docs/` directory.
