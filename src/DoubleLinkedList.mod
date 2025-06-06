(** 
    DoubleLinkedList.Mod

    Copyright (C) 2025
    Released under The 3-Clause BSD License.
*)
MODULE DoubleLinkedList;

IMPORT Collections;

TYPE
    DoubleListItem* = RECORD (Collections.Item)
        next*: POINTER TO DoubleListItem;
        prev*: POINTER TO DoubleListItem
    END;
    DoubleListItemPtr* = POINTER TO DoubleListItem;

    List* = POINTER TO ListDesc;  (* Opaque pointer type *)
    ListDesc = RECORD
        head: DoubleListItemPtr;
        tail: DoubleListItemPtr;
        size: INTEGER
    END;

    VisitProc* = PROCEDURE(item: DoubleListItemPtr; VAR state: Collections.VisitorState): BOOLEAN;

(* Constructor: Allocate and initialize a new double linked list *)
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

(* Append a new element. *)
PROCEDURE Append*(list: List; item: DoubleListItemPtr);
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
PROCEDURE RemoveFirst*(list: List; VAR result: DoubleListItemPtr);
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
PROCEDURE RemoveLast*(list: List; VAR result: DoubleListItemPtr);
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
PROCEDURE InsertAfter*(list: List; after: DoubleListItemPtr; item: DoubleListItemPtr);
BEGIN
    IF after # NIL THEN
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
PROCEDURE InsertBefore*(list: List; before: DoubleListItemPtr; item: DoubleListItemPtr);
BEGIN
    IF before # NIL THEN
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
PROCEDURE Foreach*(list: List; visit: VisitProc; VAR state: Collections.VisitorState);
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
