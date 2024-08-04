if true then return {} end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = { ensure_installed = { "go", "gomod", "gowork", "gosum", "cpp", "c", "java", "js", "javascript", "typescript", "typescriptreact", "json", "yaml", "html", "css", "rust", "python", "php", "lua", "sql", "markdown", "toml", "cmake", "git_config", "gitcommit", "git_rebase", "gitignore", "gitattributes", "json5", "http", "graphql" } },
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
        servers = {
            gopls = {
                settings = {
                    gopls = {
                    gofumpt = true,
                    codelenses = {
                        gc_details = false,
                        generate = true,
                        regenerate_cgo = true,
                        run_govulncheck = true,
                        test = true,
                        tidy = true,
                        upgrade_dependency = true,
                        vendor = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                    analyses = {
                        fieldalignment = true,
                        nilness = true,
                        unusedparams = true,
                        unusedwrite = true,
                        useany = true,
                    },
                    usePlaceholders = true,
                    completeUnimported = true,
                    staticcheck = true,
                    directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                    semanticTokens = true,
                    },
                },
            },

            -- Ensure mason installs the server
            clangd = {
                keys = {
                    { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                },
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(
                    "Makefile",
                    "configure.ac",
                    "configure.in",
                    "config.h.in",
                    "meson.build",
                    "meson_options.txt",
                    "build.ninja"
                    )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
                    fname
                    ) or require("lspconfig.util").find_git_ancestor(fname)
                end,
                capabilities = {
                    offsetEncoding = { "utf-16" },
                },
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--fallback-style=llvm",
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            },

            neocmake = {},

            jsonls = {
                -- lazy-load schemastore when needed
                on_new_config = function(new_config)
                    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                end,
                settings = {
                    json = {
                    format = {
                        enable = true,
                    },
                    validate = { enable = true },
                    },
                },
            },

            
        },
        setup = {
            gopls = function(_, opts)
            -- workaround for gopls not supporting semanticTokensProvider
            -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
            LazyVim.lsp.on_attach(function(client, _)
                if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                    full = true,
                    legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                    },
                    range = true,
                }
                end
            end, "gopls")
            -- end workaround
            end,

            clangd = function(_, opts)
                local clangd_ext_opts = LazyVim.opts("clangd_extensions.nvim")
                require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
                return false
            end,
        },
        },
    },
    {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "goimports", "gofumpt", "codelldb" } },
    },
    {
        "leoluz/nvim-dap-go",
        opts = {},
    },
    {
        "fredrikaverpil/neotest-golang",
    },
    {
        "echasnovski/mini.icons",
        opts = {
            file = {
            [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
            },
            filetype = {
            gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        optional = true,
        dependencies = {
            {
            "williamboman/mason.nvim",
            opts = { ensure_installed = { "gomodifytags", "impl" } },
            },
        },
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.sources = vim.list_extend(opts.sources or {}, {
            nls.builtins.code_actions.gomodifytags,
            nls.builtins.code_actions.impl,
            nls.builtins.formatting.goimports,
            nls.builtins.formatting.gofumpt,
            nls.builtins.diagnostics.cmake_lint,
            nls.builtins.diagnostics.clangd,
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
            go = { "goimports", "gofumpt" },
            },
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = {
            "fredrikaverpil/neotest-golang",
        },
        opts = {
            adapters = {
            ["neotest-golang"] = {
                -- Here we can set options for neotest-golang, e.g.
                -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
                dap_go_enabled = true, -- requires leoluz/nvim-dap-go
            },
            },
        },
    },
    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        config = function() end,
        opts = {
            inlay_hints = {
            inline = false,
            },
            ast = {
            --These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = "",
            },
            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = "",
            },
            },
        },
        {
            "nvim-cmp",
            opts = function(_, opts)
              table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
            end,
        },
    },
    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = {
            -- Ensure C/C++ debugger is installed
            "williamboman/mason.nvim",
            optional = true,
            opts = { ensure_installed = { "codelldb", "cmakelang", "cmakelint" } },
        },
        opts = function()
            local dap = require("dap")
            if not dap.adapters["codelldb"] then
            require("dap").adapters["codelldb"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                command = "codelldb",
                args = {
                    "--port",
                    "${port}",
                },
                },
            }
            end
            for _, lang in ipairs({ "c", "cpp" }) do
            dap.configurations[lang] = {
                {
                type = "codelldb",
                request = "launch",
                name = "Launch file",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                },
                {
                type = "codelldb",
                request = "attach",
                name = "Attach to process",
                pid = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
                },
            }
            end
        end,
    },
    {
        "Civitasv/cmake-tools.nvim",
        lazy = true,
        init = function()
            local loaded = false
            local function check()
            local cwd = vim.uv.cwd()
            if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
                require("lazy").load({ plugins = { "cmake-tools.nvim" } })
                loaded = true
            end
            end
            check()
            vim.api.nvim_create_autocmd("DirChanged", {
            callback = function()
                if not loaded then
                check()
                end
            end,
            })
        end,
        opts = {},
    },
    {
        "mfussenegger/nvim-lint",
        optional = true,
        opts = {
            linters_by_ft = {
            cmake = { "cmakelint" },
            },
        },
    },
    {
        "petertriho/cmp-git", opts = {}
    },
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false, -- last release is way too old
    }


}