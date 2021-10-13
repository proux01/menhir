(******************************************************************************)
(*                                                                            *)
(*                                   Menhir                                   *)
(*                                                                            *)
(*                       François Pottier, Inria Paris                        *)
(*              Yann Régis-Gianas, PPS, Université Paris Diderot              *)
(*                                                                            *)
(*  Copyright Inria. All rights reserved. This file is distributed under the  *)
(*  terms of the GNU General Public License version 2, as described in the    *)
(*  file LICENSE.                                                             *)
(*                                                                            *)
(******************************************************************************)

(** This module is an extension of Stdlib.List *)

include module type of List

(** A list subject to a condition. (Be careful, though: the list is of course
    constructed even if the condition is false.) *)
val ifn : bool -> 'a list -> 'a list

(** A list subject to a condition. (Be careful, though: the list is of course
    constructed even if the condition is false.) *)
val if1 : bool -> 'a -> 'a list

(** A lazy version of [ifn], where the list is constructed only if the condition
    is true. *)
val ifnlazy : bool -> (unit -> 'a list) -> 'a list

(** The sum of a list of integers. *)
val sum : int list -> int

(** [at_most k xs] tests whether the list [xs] contains at most [k] elements. *)
val at_most : int -> 'a list -> bool

(** [drop k xs] is the list [xs] deprived of its first [k] elements. *)
val drop : int -> 'a list -> 'a list

(** [take k xs] is the list of the first [k] elements of the list [xs]. *)
val take : int -> 'a list -> 'a list
