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

include List

(** A list subject to a condition. (Be careful, though: the list is
   of course constructed even if the condition is false.) *)
let ifn condition xs =
  if condition then
    xs
  else
    []

(** A list subject to a condition. (Be careful, though: the list is
         of course constructed even if the condition is false.) *)
let if1 condition x =
  if condition then
    [ x ]
  else
    []

(** A lazy version of [ifn], where the list is constructed only
         if the condition is true. *)
let ifnlazy condition xs =
  if condition then
    xs()
  else
    []

let sum li =
  fold_left (+) 0 li

let rec at_most k xs =
  match xs with
  | [] ->
      true
  | _ :: xs ->
      k > 0 && at_most (k - 1) xs

let rec drop k xs =
  match k, xs with
  | 0, _
  | _, [] ->
      xs
  | _, _ :: xs ->
      drop (k - 1) xs

let rec take k xs =
  match k, xs with
  | 0, _
  | _, [] ->
      []
  | _, x :: xs ->
      x :: take (k - 1) xs
