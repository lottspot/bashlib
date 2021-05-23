# Modules #

## module structure ##

The bashlib source code is divided into separate
modules, each of which can be built individually.
Modules are grouped by their dependencies. Each
module contains one or more source files which are
grouped by purpose/function. The dependency
groupings for modules is as follows:

- **core**: Functions provided in the core module
 must be pure bash implementations; they rely only
 on language features and shell builtins (as defined in section
 `SHELL BUILTIN COMMANDS` of [`bash(1)`](https://linux.die.net/man/1/bash))
- **util**: Functions provided in the util module
 may only rely on standard shell utilities (as defined in
 [IEEE Std 1003.1](https://pubs.opengroup.org/onlinepubs/9699919799/))
- **<kernel-name>**: Functions provided in modules named after OS
 kernels (e.g., `linux`) may, in addition to standard shell utilities,
 depend on OS specific shell utilities or system features
 (e.g., util-linux, /proc filesystem).
- _all others_: Functions which fall outside of aforementioned dependency
 requirements (i.e., those depending on any external cli programs) must
 be grouped into separate dedicated modules. Functions depending on the
 same external program should always be grouped into the same module.

## mod.ini ##

Each module must contain a mod.ini file which defines dependencies for
each source file. The file defines two types of dependencies for each
source:

1. Required bashlib modules
2. Required shell commands

These dependencies are used to configure builds of bashlib and generate
bashlib's runtime dependency checks respectively. Each section in a mod.ini
will define one of these dependency types for a single module source.

### format ###

Each section name must take the form `[<sourcename>.<mods|cmds>]`, where <sourcename>
is the name of the source file without its .sh extension.

#### mods section ####

Each line of a `[<sourcename>.mods]` section must specify a bashlib module upon
which the source depends. Modules can be specified in the form `<modname>` to
declare dependency on an entire module or `<modname>/<sourcename>` to more narrowly
declare dependency.

#### cmds section ####

Each line of a `[<sourcename>.cmds]` section must specify a cli utility upon which
the source depends. CLI utilities may be specified simply by their command name,
e.g., `grep`, or they may be specified in the form `<package>/<cmd>`, e.g.,
`coreutils/cat`. The latter form provides no functional difference to the former;
it is simply for informational purposes, and results in a slightly more detailed
error message from runtime dependency checks.

#### example ####

The util modules provides a good mod.ini sample:

```
[cfg.mods]
core/string

[cfg.cmds]
coreutils/tr

[kv_fs.cmds]
coreutils/rm
coreutils/mkdir
coreutils/cat
```
