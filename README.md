# .julia

System image driven Julia configuration

This repository aims to provide an easy to setup Julia configuration with two system image driven environments:

- `nvim-lspconfig`: an environment that builds a system image specifically for [LanguageServer.jl](https://github.com/julia-vscode/LanguageServer.jl)
- `repl`: an environment that adds a few common REPL packages: [OhMyREPL.jl](https://github.com/KristofferC/OhMyREPL.jl), [Revise.jl](https://github.com/timholy/Revise.jl), and [KittyTerminalImages.jl](https://github.com/simonschoelly/KittyTerminalImages.jl)

## 🚀 Getting Started

1. Copy all of the files into place. Run the following commands from the root of this repository

```sh
mkdir -p ~/.julia/{config,environments}
mv ~/.julia/config/startup.jl ~/.julia/config/startup.jl.bak 2>/dev/null
cp config/startup.jl ~/.julia/config/startup.jl
cp -r environments/nvim-lspconfig/ ~/.julia/environments/nvim-lspconfig
cp -r environments/repl/ ~/.julia/environments/repl
```

2. Set up the `nvim-lspconfig` environment:

```sh
cd ~/.julia/environments/nvim-lspconfig
make # follow the instructions in the file that opens
```

3. Set up the `repl` environment:

```sh
cd ~/.julia/environments/repl
make
# This opens a REPL, follow these steps:
# 1. Press Ctrl+r, then once fzf opens press Ctrl+c
# 2. Copy the text below in its entirety and paste it into the REPL and press Enter
```

```julia
print("Hello, World")
for i in 1:10
  print(i)
end
(((((())))))
using Revise
exit()
```

4. Add the following function to your shell configuration:

```sh
julia() {
  julia_bin=${JULIA_DEPOT_PATH:-~/.julia}/environments/repl/bin/julia
  if [[ -f "${julia_bin}" ]]; then
    "${julia_bin}" "$@"
  else
    command julia "$@"
  fi
}
```
