(* A low level interface to the server protocol.  In particular, it
does not make it very convenient to send or receive values. *)
signature SERVER = sig

  type server

  (* Passing server executable and executable options.  Make sure to
  call 'stopServer' eventually. *)
  val startServer : string -> string list -> server

  (* Shut down the server. *)
  val stopServer : server -> unit

  type varname = string
  type typename = string
  type entryname = string
  type filename = string

  (* Direct interface to protocol commands. *)
  val cmdRestore : server -> filename -> (varname * typename) list -> unit
  val cmdStore : server -> filename -> varname list -> unit
  val cmdCall : server -> entryname -> varname list -> varname list -> string
  val cmdFree : server -> varname list -> unit
  val cmdRename : server -> varname -> varname -> unit
  val cmdInputs : server -> entryname -> string
  val cmdOutputs : server -> entryname -> string
  val cmdClear : server -> unit
  val cmdReport : server -> string


  (* Send a raw command consisting of the given words.  Useful if the
  protocol has gained new commands without this library being
  updated. *)
  val sendCommand : server -> string list -> string

end
