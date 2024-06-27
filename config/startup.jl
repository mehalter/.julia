atreplinit() do repl
    repl_image = joinpath(get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")), "environments", "repl", "repl.so")
    # Only setup REPL if using the REPL system image
    if unsafe_string(Base.JLOptions().image_file) == repl_image
        @eval begin
            using OhMyREPL
            colorscheme!("GitHubDark")
            OhMyREPL.enable_pass!("RainbowBrackets", true)
            if haskey(ENV, "KITTY_LISTEN_ON")
                using KittyTerminalImages
                pushKittyDisplay!()
            end

            if haskey(ENV, "TERM_PROGRAM") && ENV["TERM_PROGRAM"] == "vscode"
                # in VS Code REPL
                OhMyREPL.enable_autocomplete_brackets(false)
            else
                # not in VS Code REPL
                # using Revise
            end
        end
    end
end
