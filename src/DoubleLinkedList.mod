(** 
    DoubleLinkedList.Mod

    Copyright (C) 2025
    Released under The 3-Clause BSD License.
*)
MODULE DoubleLinkedList;

(**
    This module implements a Double Linked List.
    It provides basic operations such as initialization,
    appending items, removing the first item, and checking if the list is empty.
    The list is built using pointers to a custom item type defined in Collections.
    Each node has both next and prev pointers.
 *)

IMPORT Collections;

TYPE
    DoubleListItem* = RECORD (Collections.Item)
        (*  Represents a list node in a double-linked list. *)
        next*: POINTER TO DoubleListItem;
        prev*: POINTER TO DoubleListItem
    END;
    DoubleListItemPtr* = POINTER TO DoubleListItem;

    List* = RECORD
        (* Represents a double-linked list. *)
        head*: DoubleListItemPtr;
        tail*: DoubleListItemPtr;
        size*: INTEGER
    END;
   
(* Initialize the Double Linked List. *)
PROCEDURE Init*(VAR list: List);
BEGIN
    list.head := NIL;
    list.tail := NIL;
    list.size := 0
END Init;

(* Append a new element. *)
PROCEDURE Append*(VAR list: List; item: DoubleListItemPtr);
BEGIN
    item.next := NIL;
    item.prev := list.tail;
    IF list.head = NIL THEN
        list.head := item;
        list.tail := item
    ELSE
        list.tail.next := item;
        list.tail := item
    END;
    INC(list.size)
END Append;

(* Remove and return the first list element. *)
PROCEDURE RemoveFirst*(VAR list: List; VAR result: DoubleListItemPtr);
BEGIN
    IF list.head # NIL THEN
        result := list.head;
        list.head := list.head.next;
        IF list.head # NIL THEN
            list.head.prev := NIL
        ELSE
            list.tail := NIL
        END;
        DEC(list.size)
    ELSE
        result := NIL
    END
END RemoveFirst;

(* Remove and return the last list element. *)
PROCEDURE RemoveLast*(VAR list: List; VAR result: DoubleListItemPtr);
BEGIN
    IF list.tail # NIL THEN
        result := list.tail;
        list.tail := list.tail.prev;
        IF list.tail # NIL THEN
            list.tail.next := NIL
        ELSE
            list.head := NIL
        END;
        DEC(list.size)
    ELSE
        result := NIL
    END
END RemoveLast;

(* Insert a new element after a given node. *)
PROCEDURE InsertAfter*(VAR list: List; after: DoubleListItemPtr; item: DoubleListItemPtr);
BEGIN
    IF after = NIL THEN
        (* Cannot insert after NIL; do nothing. *)
    ELSE
        item.next := after.next;
        item.prev := after;
        IF after.next # NIL THEN
            after.next.prev := item
        ELSE
            list.tail := item
        END;
        after.next := item;
        INC(list.size)
    END
END InsertAfter;

(* Insert a new element before a given node. *)
PROCEDURE InsertBefore*(VAR list: List; before: DoubleListItemPtr; item: DoubleListItemPtr);
BEGIN
    IF before = NIL THEN
        (* Cannot insert before NIL; do nothing. *)
    ELSE
        item.prev := before.prev;
        item.next := before;
        IF before.prev # NIL THEN
            before.prev.next := item
        ELSE
            list.head := item
        END;
        before.prev := item;
        INC(list.size)
    END
END InsertBefore;

(* Return the number of elements in the list. *)
PROCEDURE Count*(list: List): INTEGER;
BEGIN
    RETURN list.size
END Count;

(* Test if the list is empty. *)
PROCEDURE IsEmpty*(list: List): BOOLEAN;
BEGIN
    RETURN list.head = NIL
END IsEmpty;

(** Apply a procedure to each element in the list, passing a state variable. 
If visit returns FALSE, iteration stops. *)
PROCEDURE Foreach*(list: List; visit: Collections.VisitProc; VAR state: Collections.VisitorState);
VAR current: DoubleListItemPtr; cont: BOOLEAN;
BEGIN
    current := list.head;
    cont := TRUE;
    WHILE (current # NIL) & cont DO
        cont := visit(current, state);
        current := current.next
    END
END Foreach;

END DoubleLinkedList.
