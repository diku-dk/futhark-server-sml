structure ServerVars :> SERVER_VARS = struct
datatype var = var of Server.varname

fun varName (var v) = v

val counter = ref 0

fun newVar () =
    let val i = !counter
        val () = counter := i + 1
    in var ("var_" ^ Int.toString i) end

fun freeVar s (var v) = Server.cmdFree s [v]

fun withTmpFile f =
    let val tmpf = OS.FileSys.tmpName()
    in (f tmpf before OS.FileSys.remove tmpf)
       handle e => (OS.FileSys.remove tmpf; raise e)
    end

fun varToValue s v =
    withTmpFile
      (fn tmpf =>
          let val () = Server.cmdStore s tmpf [varName v]
          in Data.readValue (BinIO.openIn tmpf) end)

fun numOutputs s entryname =
    length (String.fields (fn c => c = #" ") (Server.cmdOutputs s entryname))

fun call s entryname inputs =
    let val outputs = List.tabulate (numOutputs s entryname, fn _ => newVar ())
    in Server.cmdCall s entryname (map varName outputs) (map varName inputs);
       outputs
    end

fun elemToStr Data.bool = "bool"
  | elemToStr Data.u8 = "u8"
  | elemToStr Data.u16 = "u16"
  | elemToStr Data.u32 = "u32"
  | elemToStr Data.u64 = "u64"
  | elemToStr Data.i8 = "i8"
  | elemToStr Data.i16 = "i16"
  | elemToStr Data.i32 = "i32"
  | elemToStr Data.i64 = "i64"
  | elemToStr Data.f32 = "f32"
  | elemToStr Data.f64 = "f64"

fun dimStr d = "[" ^ Int.toString d ^ "]"

fun valueTypeStr v =
    concat (map dimStr (Data.valueShape v)) ^ elemToStr(Data.valueElemType v)

fun varFromValue s v =
    withTmpFile
      (fn tmpf =>
          let val tmpf_s = BinIO.openOut tmpf
              val () = Data.writeValue v tmpf_s
              val () = BinIO.closeOut tmpf_s
              val v' = newVar ()
              val () = Server.cmdRestore s tmpf [(varName v', valueTypeStr v)]
          in v' end)

end
