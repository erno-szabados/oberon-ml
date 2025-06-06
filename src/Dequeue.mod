(*
    Dequeue.Mod
    Double-ended queue implementation using DoubleLinkedList.
    Copyright (C) 2025
    Released under The 3-Clause BSD License.
*)
MODULE Dequeue;

IMPORT DoubleLinkedList, Collections;

TYPE
    Dequeue* = RECORD
        list: DoubleLinkedList.List
    END;
    ItemPtr* = DoubleLinkedList.DoubleListItemPtr;

(* Initialize the dequeue. *)
PROCEDURE Init*(VAR dq: Dequeue);
BEGIN
    DoubleLinkedList.Init(dq.list)
END Init;

(* Add an item to the front of the dequeue. *)
PROCEDURE Prepend*(VAR dq: Dequeue; item: ItemPtr);
BEGIN
    IF dq.list.head = NIL THEN
        DoubleLinkedList.Append(dq.list, item)
    ELSE
        DoubleLinkedList.InsertBefore(dq.list, dq.list.head, item)
    END
END Prepend;

(* Add an item to the back of the dequeue. *)
PROCEDURE Append*(VAR dq: Dequeue; item: ItemPtr);
BEGIN
    DoubleLinkedList.Append(dq.list, item)
END Append;

(* Remove and return the first item. *)
PROCEDURE RemoveFirst*(VAR dq: Dequeue; VAR result: ItemPtr);
BEGIN
    DoubleLinkedList.RemoveFirst(dq.list, result)
END RemoveFirst;

(* Remove and return the last item. *)
PROCEDURE RemoveLast*(VAR dq: Dequeue; VAR result: ItemPtr);
BEGIN
    DoubleLinkedList.RemoveLast(dq.list, result)
END RemoveLast;

(* Return the number of items in the dequeue. *)
PROCEDURE Count*(dq: Dequeue): INTEGER;
VAR result: INTEGER;
BEGIN
    result := DoubleLinkedList.Count(dq.list);
    RETURN result
END Count;

(* Test if the dequeue is empty. *)
PROCEDURE IsEmpty*(dq: Dequeue): BOOLEAN;
VAR result: BOOLEAN;
BEGIN
    result := DoubleLinkedList.IsEmpty(dq.list);
    RETURN result
END IsEmpty;

(* Apply a procedure to each element in the dequeue. *)
PROCEDURE Foreach*(dq: Dequeue; visit: Collections.VisitProc; VAR state: Collections.VisitorState);
BEGIN
    DoubleLinkedList.Foreach(dq.list, visit, state)
END Foreach;

END Dequeue.
