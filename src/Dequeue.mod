(*
    Dequeue.Mod
    Double-ended queue implementation using DoubleLinkedList.
    Copyright (C) 2025
    Released under The 3-Clause BSD License.
*)
MODULE Dequeue;

IMPORT DoubleLinkedList, Collections;

TYPE
    Item* = RECORD (DoubleLinkedList.ListItem)
        (** A base type for items in the dequeue. *)
        (** Extend this type to add more fields as needed. *)
    END;
    ItemPtr* = POINTER TO Item;

    Dequeue* = POINTER TO DequeueDesc;
    DequeueDesc = RECORD
        list: DoubleLinkedList.List
    END;


(* Constructor: Allocate and initialize a new dequeue. *)
PROCEDURE New*(): Dequeue;
VAR dq: Dequeue;
BEGIN
    NEW(dq);
    dq.list := DoubleLinkedList.New();
    RETURN dq
END New;

(* Destructor: Free the dequeue. *)
PROCEDURE Free*(VAR dq: Dequeue);
BEGIN
    IF dq # NIL THEN
        DoubleLinkedList.Free(dq.list);
        dq := NIL
    END
END Free;

(* Add an item to the front of the dequeue. *)
PROCEDURE Prepend*(dq: Dequeue; item: ItemPtr);
VAR head: DoubleLinkedList.ListItemPtr;
BEGIN
    IF DoubleLinkedList.IsEmpty(dq.list) THEN
        DoubleLinkedList.Append(dq.list, item(ItemPtr))
    ELSE
        head := DoubleLinkedList.Head(dq.list);
        DoubleLinkedList.InsertBefore(dq.list, head, item)
    END
END Prepend;

(* Add an item to the back of the dequeue. *)
PROCEDURE Append*(dq: Dequeue; item: ItemPtr);
BEGIN
    DoubleLinkedList.Append(dq.list, item(ItemPtr))
END Append;

(* Remove and return the first item. *)
PROCEDURE RemoveFirst*(dq: Dequeue; VAR result: ItemPtr);
VAR dllItem: DoubleLinkedList.ListItemPtr;
BEGIN
    DoubleLinkedList.RemoveFirst(dq.list, dllItem);
    result := dllItem(ItemPtr)
END RemoveFirst;

(* Remove and return the last item. *)
PROCEDURE RemoveLast*(dq: Dequeue; VAR result: ItemPtr);
VAR dllItem: DoubleLinkedList.ListItemPtr;
BEGIN
    DoubleLinkedList.RemoveLast(dq.list, dllItem);
    result := dllItem(ItemPtr)
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
