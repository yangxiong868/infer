(*
 * Copyright (c) 2017 - present Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)


(** Method signature with annotations. *)

type t = {
  ret : Annot.Item.t * Typ.t; (** Annotated return type. *)
  params: (Mangled.t * Annot.Item.t * Typ.t) list; (** Annotated parameters. *)
} [@@deriving compare]

type annotation =
  | Nullable
  | Present
[@@deriving compare]

(** Check if the annotated signature is for a wrapper of an anonymous inner class method.
    These wrappers have the same name as the original method, every type is Object, and the
    parameters are called x0, x1, x2. *)
val is_anonymous_inner_class_wrapper : t -> Procname.t -> bool

(** Check if the given parameter has a Nullable annotation in the given signature *)
val param_is_nullable : Pvar.t -> t -> bool

(** Mark the return of the method_annotation with the given annotation. *)
val method_annotation_mark_return : annotation -> Annot.Method.t -> Annot.Method.t

(** Mark the annotated signature with the given annotation map. *)
val mark : Procname.t -> annotation -> t -> bool * bool list -> t

(** Mark the return of the annotated signature with the given annotation. *)
val mark_return : annotation -> t -> t

(** Mark the return of the annotated signature @Strict. *)
val mark_return_strict : t -> t

(** Get a method signature with annotations from a proc_attributes. *)
val get : ProcAttributes.t -> t

(** Add the annotation to the item_annotation. *)
val mk_ia : annotation -> Annot.Item.t -> Annot.Item.t

(** Pretty print a method signature with annotations. *)
val pp : Procname.t -> Format.formatter -> t -> unit
