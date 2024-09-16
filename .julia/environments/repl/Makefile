# MIT License. Copyright (c) 2024 Micah Halter
#
# This Makefile if heavily based on the Makefile by Fredrik Ekre for building system images
# for the Julia LanguageServer.jl but is used to can be used to build a custom Julia system
# image for packages used to drive the Julia REPL.
# Original: https://github.com/fredrikekre/.dotfiles/blob/master/.julia/environments/nvim-lspconfig/Makefile
#
# Usage instructions:
#
#   1. Place this Makefile in ~/.julia/environments/repl (create the directory if
#      it doesn't already exist).
#
#   2. Change directory to ~/.julia/environments/repl and run `make`. This will
#      start up a julia REPL. Run a few basic commands to use OhMyREPL a bit then quit
#      the REPL.
#
#   4. Upon exiting Julia, PackageCompiler.jl will compile a custom system image which can be
#      called by running the `julia` shim found in `~/.julia/environments/repl/bin/julia`
#
# Update instructions:
#
#  To update the system image (e.g. when upgrading Julia or plugin versions)
#  run the following commands from the ~/.julia/environments/repl directory:
#
#      make update

JULIA ?= $(shell which julia)
JULIA_PROJECT=
SRCDIR:=$(shell dirname $(abspath $(firstword $(MAKEFILE_LIST))))
ifeq ($(shell uname -s),Linux)
	SYSIMAGE=repl.so
else
	SYSIMAGE=repl.dylib
endif

REPL_PKGS:=$(shell echo '["OhMyREPL", "KittyTerminalImages", "Revise", "TestEnv"]')

default: clean $(SYSIMAGE)

$(SYSIMAGE): Manifest.toml packagecompiler/Manifest.toml packagecompiler/precompile_statements.jl
	JULIA_LOAD_PATH=${PWD}:${PWD}/packagecompiler:@stdlib ${JULIA} -e 'using PackageCompiler; PackageCompiler.create_sysimage(${REPL_PKGS}, sysimage_path="$(SYSIMAGE)", precompile_statements_file="packagecompiler/precompile_statements.jl")'

Manifest.toml: Project.toml
	JULIA_LOAD_PATH=${PWD}/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.instantiate()'

Project.toml:
	JULIA_LOAD_PATH=${PWD}/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.add(${REPL_PKGS})'

packagecompiler/Manifest.toml: packagecompiler/Project.toml
	JULIA_LOAD_PATH=${PWD}/packagecompiler/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.instantiate()'

packagecompiler/Project.toml:
	mkdir -p packagecompiler
	JULIA_LOAD_PATH=${PWD}/packagecompiler/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.add("PackageCompiler")'

packagecompiler/precompile_statements.jl: Manifest.toml bin/julia
	JULIA_TRACE_COMPILE=1 bin/julia

bin/julia:
	mkdir -p bin
	echo "$$JULIA_SHIM" > $@
	chmod +x $@

clean:
	rm -rf $(SYSIMAGE) packagecompiler bin

update_packages:
	JULIA_LOAD_PATH=${PWD}/Project.toml:@stdlib ${JULIA} -e 'using Pkg; Pkg.update()'

repl:
	JULIA_LOAD_PATH=${PWD}/Project.toml:@stdlib ${JULIA}

update: update_packages default

.PHONY: clean update update_packages repl default

export JULIA_SHIM
define JULIA_SHIM
#!/bin/bash
JULIA=${JULIA}
JULIA_LOAD_PATH="$${JULIA_LOAD_PATH:-:}:${PWD}"
if [[ $${JULIA_TRACE_COMPILE} = "1" ]]; then
    export JULIA_REPL=1
    exec $${JULIA} --trace-compile=${PWD}/packagecompiler/precompile_statements.jl "$$@"
elif [[ -f ${PWD}/$(SYSIMAGE) ]]; then
    exec $${JULIA} --sysimage=${PWD}/$(SYSIMAGE) "$$@"
else
    exec $${JULIA} "$$@"
fi
endef
