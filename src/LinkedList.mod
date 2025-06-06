(** TestLinkedList.Mod - Tests for LinkedList.Mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE LinkedList;

(**
    This module implements a Linked List. 
    It provides basic operations such as initialization,
    appending items, removing the first item, and checking if the list is empty.
    The list is built using pointers to a custom item type defined in Collections.
 *)

IMPORT Collections;

TYPE
    List* = RECORD
    (** Linked list type. *)
        head*: Collections.ListItemPtr;
        tail*: Collections.ListItemPtr;
        size*: INTEGER
END;
    (** This type defines a callback to iterate over elements of a linked list, with a user-supplied state. 
       Iteration stops if the function procedure returns FALSE. *)
    VisitProc* = PROCEDURE(item: Collections.ListItemPtr; VAR state: Collections.VisitorState): BOOLEAN;

(** Initialize the Linked List. *)
PROCEDURE Init*(VAR list: List);
BEGIN
    list.head := NIL;
    list.tail := NIL;
    list.size := 0
END Init;

(** Append a new element. *)
PROCEDURE Append*(VAR list: List; item: Collections.ListItemPtr);
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
PROCEDURE RemoveFirst*(VAR list: List; VAR result: Collections.ListItemPtr);
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
PROCEDURE InsertAfter*(VAR list: List; after: Collections.ListItemPtr; item: Collections.ListItemPtr);
BEGIN
    IF after = NIL THEN
        (* Cannot insert after NIL; do nothing. *)
    ELSE
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
PROCEDURE Foreach*(list: List; visit: VisitProc; VAR state: Collections.VisitorState);
VAR current: Collections.ListItemPtr; cont: BOOLEAN;
BEGIN
    current := list.head;
    cont := TRUE;
    WHILE (current # NIL) & cont DO
        cont := visit(current, state);
        current := current.next
    END
END Foreach;

END LinkedList.