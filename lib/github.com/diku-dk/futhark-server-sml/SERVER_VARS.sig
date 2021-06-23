(* A higher-level (although still relatively untyped) interface to the
server protocol that automates creation of server-side variables.  You
still need to free them yourself when you are done with them (or use
cmdClear). *)

signature SERVER_VARS = sig
  (* A handle to a server variable. *)
  eqtype var

  (* Free a server variable.  Do not use it again! *)
  val freeVar : Server.server -> var -> unit

  (* Retrieve the Futhark value of a server variable.  The variable can still be used afterwards. *)
  val varToValue : Server.server -> var -> Data.value

  (* Create a new server variable from a Futhark value. *)
  val varFromValue : Server.server -> Data.value -> var

  (* Call an entry point on the server with the given variables as
  arguments, and returning new variables for the results.  Make sure
  you pass variables of the right types! *)
  val call : Server.server -> Server.entryname -> var list -> var list
end
