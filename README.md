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

# If using GNU Stow
stow -t ~ .

# If not using GNU Stow
cp .julia/config/startup.jl ~/.julia/config/startup.jl
cp -r .julia/environments/nvim-lspconfig/ ~/.julia/environments/nvim-lspconfig
cp -r .julia/environments/repl/ ~/.julia/environments/repl
```

2. Set up the `nvim-lspconfig` environment:

   1. Configure `julials` in your Neovim environment

      <details>
      <summary>AstroNvim</summary>

      Save the following as `julials.lua` in your `plugins/` folder:

      ```julia
      return {
        "AstroNvim/astrolsp",
        opts = {
          servers = { "julials" },
          config = {
            julials = {
              on_new_config = function(new_config)
                -- check for nvim-lspconfig julia sysimage shim
                local julia = (vim.env.JULIA_DEPOT_PATH or vim.fn.expand "~/.julia")
                  .. "/environments/nvim-lspconfig/bin/julia"
                if require("lspconfig").util.path.is_file(julia) then
                  new_config.cmd[1] = julia
                else
                  new_config.autostart = false -- only auto start if sysimage is available
                end
              end,
              settings = {
                julia = {
                  lint = {
                    -- recommended default used by Julia VS Code extension
                    missingrefs = "none",
                  },
                },
              },
            },
          },
        },
      }
      ```

      </details>

      <details>
      <summary>Neovim <code>nvim-lspconfig</code></summary>

      Save the following where necessary in your configuration:

      ```julia
      require("lspconfig").julials.setup({
          on_new_config = function(new_config, _)
              local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
              if require("lspconfig").util.path.is_file(julia) then
                  new_config.cmd[1] = julia
              end
          end,
          -- ...
      })
      ```

      </details>

   2. Build the system image

      ```sh
      cd ~/.julia/environments/nvim-lspconfig
      make # follow the instructions in the file that opens
      ```

3. Set up the `repl` environment:

   1. Configure your shell environment with the following:

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

   2. Build the system image

      ```sh
      cd ~/.julia/environments/repl
      make
      # This opens a REPL, follow these steps:
      # 1. Press Ctrl+r, then once fzf opens press Ctrl+c
      # 2. Paste the text below in its entirety into the REPL and press Enter
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

## ⚙️ Updating

Change directories to the environment you want to update and run:

```sh
make update
```

## 💻 REPL

Sometimes you may want to open a direct REPL into the environment with the base Julia installation, but you have a shell alias/function which points to your `repl` environment system image. I have provided a simple command to help with this. Simply change directories to the environment you want to update and run:

```sh
make repl
```
