fun test () =
    let val s = Server.startServer (List.nth (CommandLine.arguments (),0)) []
        val x = ServerVars.varFromValue s (Convert.i64.toFuthark (Int64.fromInt 10))
        val y = ServerVars.varFromValue s (Convert.i64.toFuthark (Int64.fromInt 100))
        val [res] = ServerVars.call s "sum_i64_range" [x,y]
        val res_sml = Convert.i64.fromFuthark (ServerVars.varToValue s res)
        val () = print("Result: " ^ Int64.toString res_sml ^ "\n")
        val () = Server.stopServer s
    in () end

val _ = test ()
