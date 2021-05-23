# Build

## insta start ##

```
make
. dist/lib.sh
```

This builds all bashlib modules with
runtime dependency checks disabled.

## options ##

Options can be passed on the make command line
to configure the build.

* `modlist=`: a comma-separated list of modules to include
 in the build. Modules can be specified in the form `<modname>`
 or in the more specific form `<modname>/<sourcename>`
* `depcheck=`: One of "warn", "return", or "exit". Enables
 runtime dependency checks by specifying the action to be taken
 on check failure.

### example ###

To perform a configured build:

```
make modlist=core,util/kv_fs depcheck=return
```
