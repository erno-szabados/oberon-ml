# Collections in Oberon-ML

This document describes the collection modules implemented in Oberon-ML: `LinkedList`, `DoubleLinkedList`, and `Deque`. Each module provides a different type of collection with its own interface and use cases.

## Overview

- **LinkedList**: Singly-linked list for simple, linear data storage.
- **DoubleLinkedList**: Doubly-linked list supporting bidirectional traversal and efficient insertions/removals at both ends.
- **Deque**: Double-ended queue built on `DoubleLinkedList`, supporting efficient insertion and removal at both ends.

## Comparative Table

| LinkedList      | DoubleLinkedList         | Deque           |
|----------------|-------------------------|-----------------|
| New            | New                     | New             |
| Free           | Free                    | Free            |
| Append         | Append                  | Append          |
| Prepend        | Prepend                 | Prepend         |
| -              | InsertBefore            | -               |
| -              | InsertAfter             | -               |
| RemoveFirst    | RemoveFirst             | RemoveFirst     |
| -              | RemoveLast              | RemoveLast      |
| -              | Head                    | -               |
| -              | Tail                    | -               |
| Count          | Count                   | Count           |
| IsEmpty        | IsEmpty                 | IsEmpty         |
| Foreach        | Foreach                 | Foreach         |


## Module Summaries

### LinkedList
- **Purpose:** Simple, efficient singly-linked list.
- **Key Procedures:**
  - `New`, `Free`, `Append`, `Prepend`, `RemoveFirst`, `Count`, `IsEmpty`, `Foreach`
- **Notes:** Only supports removal from the front.

### DoubleLinkedList
- **Purpose:** More flexible list with bidirectional links.
- **Key Procedures:**
  - `New`, `Free`, `Append`, `Prepend`, `InsertBefore`, `InsertAfter`, `RemoveFirst`, `RemoveLast`, `Count`, `IsEmpty`, `Foreach`, `Head`, `Tail`
- **Notes:** Supports removal from both ends and insertion before/after any item.

### Deque
- **Purpose:** Double-ended queue for efficient insertion/removal at both ends.
- **Key Procedures:**
  - `New`, `Free`, `Append`, `Prepend`, `RemoveFirst`, `RemoveLast`, `Count`, `IsEmpty`, `Foreach`
- **Notes:** Built on `DoubleLinkedList` for efficiency and code reuse.

## Usage Example

```oberon
IMPORT Deque;

VAR dq: Deque.Deque;
    item: Deque.ItemPtr;

BEGIN
    dq := Deque.New();
    (* Add and remove items as needed *)
    Deque.Free(dq);
END.
```

## Extending Collections

All collection modules define a base `Item` type that can be extended to store custom data. Always use the provided procedures for manipulating collections to ensure safety and correctness.

---

For detailed API documentation, see the respective `.def.html` files in the `docs/` directory.
