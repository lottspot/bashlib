# .config.mk provides variables:
# MODLIST: conversion of $(modlist) string to a list
# DEPCHECK: same as $(depcheck)
# BASHLIB_SRCS: source files which satisfy the build defined in $(modlist)
include .config.mk

lib: dist/lib.sh

dist/lib.sh: .config.mk $(BASHLIB_SRCS) | dist
	scripts/gendepcheck mode=$(DEPCHECK) modlist=$(modlist) | cat - $(BASHLIB_SRCS) > $@

dist:
	mkdir -p $@

config: .config.mk

# args in form: modlist=mod1,mod2/submod,etc depcheck=warn|return|exit
.config.mk:
	scripts/genconfig modlist=$(modlist) depcheck=$(depcheck) > $@

clean:
	rm -rf dist
	rm -f .config.mk

.PHONY: lib config clean
