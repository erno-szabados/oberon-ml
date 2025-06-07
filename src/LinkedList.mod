(** TestLinkedList.Mod - Tests for LinkedList.Mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE LinkedList;

IMPORT Collections;

TYPE
    ListItem* = RECORD (Collections.Item)
      (** Represents a LL item. *)
      next*: POINTER TO ListItem
    END;
    ListItemPtr* = POINTER TO ListItem;

    List* = POINTER TO ListDesc;  (* Opaque pointer type *)
    ListDesc = RECORD
        head: ListItemPtr;
        tail: ListItemPtr;
        size: INTEGER
    END;
   
(* Constructor: Allocate and initialize a new list *)
PROCEDURE New*(): List;
VAR list: List;
BEGIN
    NEW(list);
    list.head := NIL;
    list.tail := NIL;
    list.size := 0;
    RETURN list
END New;

(* Destructor: (optional, only if you want to clear memory) *)
PROCEDURE Free*(VAR list: List);
BEGIN
    list := NIL
END Free;

(** Append a new element. *)
PROCEDURE Append*(list: List; item: ListItemPtr);
BEGIN
    item.next := NIL;
    IF list.head = NIL THEN
        list.head := item;
        list.tail := item
    ELSE
        list.tail.next := item;
        list.tail := item
    END;
    INC(list.size)
END Append;

(** Remove and return the first list element. *)
PROCEDURE RemoveFirst*(list: List; VAR result: ListItemPtr);
BEGIN
    IF list.head # NIL THEN
        result := list.head;
        list.head := list.head.next;
        IF list.head = NIL THEN
            list.tail := NIL
        END;
        DEC(list.size)
    ELSE
        result := NIL
    END
END RemoveFirst;

(** Insert a new element after a given node. *)
PROCEDURE InsertAfter*(list: List; after: ListItemPtr; item: ListItemPtr);
BEGIN
    IF after # NIL THEN
        item.next := after.next;
        after.next := item;
        IF list.tail = after THEN
            list.tail := item
        END;
        INC(list.size)
    END
END InsertAfter;

(** Return the number of elements in the list. *)
PROCEDURE Count*(list: List): INTEGER;
BEGIN
    RETURN list.size
END Count;

(** Test if the list is empty. *)
PROCEDURE IsEmpty*(list: List): BOOLEAN;
BEGIN
    RETURN list.head = NIL
END IsEmpty;

(** Apply a procedure to each element in the list, passing a state variable. 
If visit returns FALSE, iteration stops. *)
PROCEDURE Foreach*(list: List; visit: Collections.VisitProc; VAR state: Collections.VisitorState);
VAR current: ListItemPtr; cont: BOOLEAN;
BEGIN
    current := list.head;
    cont := TRUE;
    WHILE (current # NIL) & cont DO
        cont := visit(current, state);
        current := current.next
    END
END Foreach;

END LinkedList.