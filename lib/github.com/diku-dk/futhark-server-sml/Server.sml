structure Server : SERVER = struct

type server = {proc: (TextIO.instream, TextIO.outstream) Unix.proc,
               stdin: TextIO.outstream,
               stdout: TextIO.instream
              }

type varname = string
type typename = string
type entryname = string
type filename = string

exception CmdFailure of string

val debugTrace = false

fun debugIn s =
    (if debugTrace then print ("<<< " ^ s) else (); s)

fun debugOut s =
    (if debugTrace then print (">>> " ^ s) else (); s)

fun responseLines stream =
    case TextIO.inputLine stream of
        NONE => raise Fail "Unexpected EOF from server"
      | SOME l =>
        (case debugIn l of
             "%%% OK\n" => []
          | _ => l :: responseLines stream)

fun checkForFailure [] = []
  | checkForFailure ("%%% FAILURE"::ls) = raise CmdFailure (concat ls)
  | checkForFailure (l::ls) = l :: checkForFailure ls

fun startServer prog opts : server =
    let val proc = Unix.execute(prog, opts)
        val (stdout, stdin) = Unix.streamsOf proc
        val _ = responseLines stdout
    in {proc = proc, stdin = stdin, stdout = stdout} end

fun stopServer (s: server) =
    (Unix.reap (#proc s); ())

fun quoteWord s =
    if List.exists (fn c => c = #" ") (explode s)
    then "\"" ^ s ^ "\""
    else s

fun unwords [] = ""
  | unwords [x] = x
  | unwords (x::y::zs) = x ^ " " ^ y ^ " " ^ unwords zs

fun sendCommand (s: server) command =
    let val command' = unwords (map quoteWord command) ^ "\n"
    in TextIO.output (#stdin s, debugOut command');
       TextIO.flushOut (#stdin s);
       concat (checkForFailure (responseLines (#stdout s)))
    end

fun sendCommand_ s command = (sendCommand s command; ())

fun cmdRestore s fname vs =
    sendCommand_ s ("restore" :: fname :: List.concat (map (fn (v,t) => [v,t]) vs))
fun cmdStore s fname vs = sendCommand_ s ("store" :: fname :: vs)
fun cmdCall s entryname outs ins = sendCommand s ("call" :: entryname :: outs @ ins)
fun cmdFree s vs = sendCommand_ s ("free"::vs)
fun cmdRename s oldname newname = sendCommand_ s ["rename", oldname, newname]
fun cmdInputs s entry = sendCommand s ["inputs", entry]
fun cmdOutputs s entry = sendCommand s ["outputs", entry]
fun cmdClear s = sendCommand_ s ["clear"]
fun cmdReport s = sendCommand s ["report"]

end
