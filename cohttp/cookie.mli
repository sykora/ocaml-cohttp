(*
 * Copyright (C) <2012> Anil Madhavapeddy <anil@recoil.org>
 * Copyright (C) <2009> David Sheets <sheets@alum.mit.edu>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

type expiration = [ `Session ]

type cookie = string * string
(** A cookie is simply a key/value pair send from the client to the server *)

module Set_cookie_hdr : sig

  type t = {
    cookie: cookie;
    expiration : expiration;
    domain : string option;
    path : string option;
    secure : bool } with fields
  (** A header which a server sends to a client to request that the client
    returns the cookie in future requests, under certain conditions. *)

  val make :
    ?expiration:expiration ->
    ?path:string ->
    ?domain:string -> ?secure:bool -> cookie -> t

  val serialize :
    ?version:[ `HTTP_1_0 | `HTTP_1_1 ] ->
    t -> string * string
  (** Return an HTTP header *)

  val extract : Header.t -> (string * t) list
  (** Return the list of cookies sent by the server *)

  val cookie : t -> cookie
  (** The name-value binding *)

  val value : t -> string
  (** The value *)

  val expiration : t -> expiration
  (** The expiration *)

  val domain : t -> string option
  (** The domain for which the cookie is valid, if any *)

  val path : t -> string option
  (** The path for which the cookie is valid, if any *)

  val secure : t -> bool
  (** Has the cookie's secure attribute been set? *)
end

module Cookie_hdr : sig

  val extract : Header.t -> cookie list
  (** Return the list of cookies sent by the client *)

  val serialize : cookie list -> string * string
  (** [serialize cookies] returns an HTTP header containing [cookies] *)
end
