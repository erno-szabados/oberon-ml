
(** TestLinkedList.Mod - Tests for LinkedList.Mod.

Copyright (C) 2025

Released under The 3-Clause BSD License.
*)

MODULE Collections;

(** 
  This module provides base types for the collection implementations.
  Types using the collections should extend these.
 *)

  TYPE
    Item* = RECORD
      (* Minimal universal base type *)
    END;
    ItemPtr* = POINTER TO Item;

    ListItem* = RECORD (Item)
      (* A useful base type for collections with nodes having next elements.  *)
      next*: POINTER TO ListItem
    END;
    ListItemPtr* = POINTER TO ListItem;

END Collections.