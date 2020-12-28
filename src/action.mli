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

open Keyword (* from sdk/ *)

(* A semantic action is a piece of OCaml code together with information about
   the Menhir keywords that appear in this code. The code can be represented
   internally as a piece of text or (more generally) as an IL expression. *)
type t

(* -------------------------------------------------------------------------- *)

(* Constructors. *)

(* [from_stretch s] builds an action out of a textual piece of code. *)
val from_stretch: Stretch.t -> t

(* [from_il_expr] builds an action out of an IL expression. *)
val from_il_expr: IL.expr -> t

(* [compose x a1 a2] builds the action [let x = a1 in a2]. This combinator is
   used during inlining (that is, while eliminating %inlined symbols). *)
val compose : string -> t -> t -> t

(* [bind p x a] binds the OCaml pattern [p] to the OCaml variable [x] in the
   semantic action [a]. Therefore, it builds the action [let p = x in a]. *)
val bind: IL.pattern -> string -> t -> t

(* -------------------------------------------------------------------------- *)

(* Accessors. *)

(* [to_il_expr] converts an action to an IL expression. *)
val to_il_expr: t -> IL.expr

(* [is_standard a] indicates whether the action [a] originates from Menhir's
   standard library. Via inlining, several actions can be combined into one;
   in that case, we take a conjunction *)
val is_standard: t -> bool

(* [keywords a] is the set of keywords used in the action [a]. *)
val keywords: t -> KeywordSet.t

(* [has_syntaxerror a] tests whether the keyword [$syntaxerror] appears
   in the set [keywords a]. *)
val has_syntaxerror: t -> bool

(* [has_beforeend a] tests whether the keyword [$endpos($0)] appears in
   the set [keywords a]. *)
val has_beforeend: t -> bool

(* -------------------------------------------------------------------------- *)

(* Keyword expansion. *)

(* [define keyword keywords f a] defines away the keyword [keyword]. This
   keyword is removed from the set of keywords of the action [a]; the set
   [keywords] is added in its place. The code of the action [a] is transformed
   by the function [f], which typically wraps its argument in some new [let]
   bindings. *)

val define: keyword -> KeywordSet.t -> (IL.expr -> IL.expr) -> t -> t

(* -------------------------------------------------------------------------- *)

(* Variable renaming and keyword transformation. *)

(* Some keyword contains names: [$startpos(foo)] is an example. If one wishes
   for some reason to rename the variable [foo] to [bar], then this keyword
   must be renamed to [$startpos(bar)]. Furthermore, during inlining, it may
   be necessary to transform a keyword into another keyword: e.g., if [x] is
   inlined away and replaced with a sequence of [y] and [z], then
   [$startpos(x)] must be renamed to [$startpos(y)] and [$endpos(x)] must be
   renamed to [$endpos(z)]. *)

(* A variable-to-variable substitution is a finite map of variables to
   variables. It can be semantically interpreted as a simultaneous binding
   construct, that is, as a [let/and] construct. *)
type subst

(* The empty substitution. *)
val empty: subst

(* Extending a substitution. *)
val extend: string -> string -> subst -> subst

(* [rename f phi a] transforms the action [a] by applying the renaming [phi]
   as well as the keyword transformations determined by the function [f].

   The function [f] is applied to each (not-yet-renamed) keyword and may
   decide to transform it into another keyword, by returning [Some _], or to
   not transform it, by returning [None]. In the latter case, [phi] still
   applies to the keyword. *)
val rename:
  (subject * where -> (subject * where) option) ->
  subst -> t -> t
