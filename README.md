# futhark-server-sml [![CI](https://github.com/diku-dk/futhark-server-sml/workflows/build/badge.svg)](https://github.com/diku-dk/futhark-server-sml/actions)

A Standard ML implementation of the
[Futhark](https://futhark-lang.org) [server
protocol](https://futhark.readthedocs.io/en/latest/server-protocol.html),
allowing simple relatively simple interoperability between Futhark and
SML programs.

## Overview of MLB files

* [lib/github.com/diku-dk/futhark-server-sml/futhark-server.mlb](lib/github.com/diku-dk/futhark-server-sml/futhark-server.mlb):

  * **signature [SERVER](lib/github.com/diku-dk/futhark-server-sml/SERVER.sig)** (low-level interface)
  * **structure Server :> SERVER**
  * **signature [SERVER_VARS](lib/github.com/diku-dk/futhark-server-sml/SERVER_VARS.sig)** (high-level interface)
  * **structure ServerVars :> SERVER_VARS**

## Installation via [smlpkg](https://github.com/diku-dk/smlpkg)

```
$ smlpkg add github.com/diku-dk/futhark-server-sml
$ smlpkg sync
```

You can now reference the `mlb`-file using relative paths from within
your own project's `mlb`-files.

## Usage

[See this very simple example program.](test/test.sml)

## Compatibility

Tested with MLton and MLKit.  Should in principle work with any SML
implementation that supports a reasonable subset of the Basis library
(e.g. SML/NJ), but you may need to manually load the files if they
don't support MLB.
