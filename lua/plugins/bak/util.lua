if true then return {} end

return {
    {
        "ahmedkhalf/project.nvim",
        opts = {
            manual_mode = true,
        },
        event = "VeryLazy",
        config = function(_, opts)
            require("project_nvim").setup(opts)
            LazyVim.on_load("telescope.nvim", function()
            require("telescope").load_extension("projects")
            end)
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        optional = true,
        keys = {
            { "<leader>fp", pick, desc = "Projects" },
        },
    },
    {
        "ibhagwan/fzf-lua",
        optional = true,
        keys = {
            { "<leader>fp", pick, desc = "Projects" },
        },
    },
    {
        "echasnovski/mini.starter",
        optional = true,
        opts = function(_, opts)
            local items = {
            {
                name = "Projects",
                action = pick,
                section = string.rep(" ", 22) .. "Telescope",
            },
            }
            vim.list_extend(opts.items, items)
        end,
    },
    {
        "nvimdev/dashboard-nvim",
        optional = true,
        opts = function(_, opts)
            local projects = {
            action = pick,
            desc = " Projects",
            icon = " ",
            key = "p",
            }
        
            projects.desc = projects.desc .. string.rep(" ", 43 - #projects.desc)
            projects.key_format = "  %s"
        
            table.insert(opts.config.center, 3, projects)
        end,
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },
    {
        "goolord/alpha-nvim",
        optional = true,
        opts = function(_, dashboard)
            local button = dashboard.button("p", " " .. " Projects", pick)
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
            table.insert(dashboard.section.buttons.val, 4, button)
        end,
    },
}