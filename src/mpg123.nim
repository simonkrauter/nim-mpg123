when defined(windows):
    const soname = "libmpg123-0.dll"
elif defined(macosx):
    const soname = "libmpg123-0.dylib"
else:
    const soname = "libmpg123.so(|.0)"

{.pragma: mpg123, cdecl, dynlib: soname.}

type
  TMGP123Handle* = pointer

const 
  MPG123_DONE*       = -12
  MPG123_NEW_FORMAT* = -11
  MPG123_NEED_MORE*  = -10
  MPG123_ERR*        = -1
  MPG123_OK*         = 0

proc mpg123_plain_strerror*(errcode: cint): cstring {.mpg123, importc: "mpg123_plain_strerror".}

proc mpg123_strerror*(mh: TMGP123Handle): cstring {.mpg123, importc: "mpg123_strerror".}

proc mpg123_init*(): cint {.mpg123, importc: "mpg123_init".}

proc mpg123_new*(decoder: cstring, error: ptr cint): TMGP123Handle {.mpg123, importc: "mpg123_new".}

proc mpg123_open*(mh: TMGP123Handle, path: cstring): cint {.mpg123, importc: "mpg123_open".}

proc mpg123_getformat*(mh: TMGP123Handle, rate: ptr clong, channels: ptr cint, encoding: ptr int): cint {.mpg123, importc: "mpg123_getformat".}

proc mpg123_format*(mh: TMGP123Handle, rate: clong, channels: cint, encoding: int): cint {.mpg123, importc: "mpg123_format".}

proc mpg123_read*(mh: TMGP123Handle, outmemory: pointer, outmemsize: cint, done: ptr cint): cint {.mpg123, importc: "mpg123_read".}

