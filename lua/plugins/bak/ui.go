if true then return {} end

return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		keys = {
			{
			"<leader>ue",
			function()
				require("edgy").toggle()
			end,
			desc = "Edgy Toggle",
			},
			-- stylua: ignore
			{ "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
		},
		opts = function()
			local opts = {
			bottom = {
				{
				ft = "toggleterm",
				size = { height = 0.4 },
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
				},
				{
				ft = "noice",
				size = { height = 0.4 },
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
				},
				{
				ft = "lazyterm",
				title = "LazyTerm",
				size = { height = 0.4 },
				filter = function(buf)
					return not vim.b[buf].lazyterm_cmd
				end,
				},
				"Trouble",
				{ ft = "qf", title = "QuickFix" },
				{
				ft = "help",
				size = { height = 20 },
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
				},
				{ title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
				{ title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
			},
			left = {
				{ title = "Neotest Summary", ft = "neotest-summary" },
			},
			right = {
				{ title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
			},
			keys = {
				-- increase width
				["<c-Right>"] = function(win)
				win:resize("width", 2)
				end,
				-- decrease width
				["<c-Left>"] = function(win)
				win:resize("width", -2)
				end,
				-- increase height
				["<c-Up>"] = function(win)
				win:resize("height", 2)
				end,
				-- decrease height
				["<c-Down>"] = function(win)
				win:resize("height", -2)
				end,
			},
			}
		
			if LazyVim.has("neo-tree.nvim") then
			local pos = {
				filesystem = "left",
				buffers = "top",
				git_status = "right",
				document_symbols = "bottom",
				diagnostics = "bottom",
			}
			local sources = LazyVim.opts("neo-tree.nvim").sources or {}
			for i, v in ipairs(sources) do
				table.insert(opts.left, i, {
				title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == v
				end,
				pinned = true,
				open = function()
					vim.cmd(("Neotree show position=%s %s dir=%s"):format(pos[v] or "bottom", v, LazyVim.root()))
				end,
				})
			end
			end
		
			for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
			opts[pos] = opts[pos] or {}
			table.insert(opts[pos], {
				ft = "trouble",
				filter = function(_buf, win)
				return vim.w[win].trouble
					and vim.w[win].trouble.position == pos
					and vim.w[win].trouble.type == "split"
					and vim.w[win].trouble.relative == "editor"
					and not vim.w[win].trouble_preview
				end,
			})
			end
			return opts
		end,
	},
	{
		"echasnovski/mini.animate",
		recommended = true,
		event = "VeryLazy",
		opts = function()
			local mouse_scrolled = false
			for _, scroll in ipairs({ "Up", "Down" }) do
			local key = "<ScrollWheel" .. scroll .. ">"
			vim.keymap.set({ "", "i" }, key, function()
				mouse_scrolled = true
				return key
			end, { expr = true })
			end
		
			vim.api.nvim_create_autocmd("FileType", {
			pattern = "grug-far",
			callback = function()
				vim.b.minianimate_disable = true
			end,
			})
		
			LazyVim.toggle.map("<leader>ua", {
			name = "Mini Animate",
			get = function()
				return not vim.g.minianimate_disable
			end,
			set = function(state)
				vim.g.minianimate_disable = not state
			end,
			})
		
			local animate = require("mini.animate")
			return {
			resize = {
				timing = animate.gen_timing.linear({ duration = 50, unit = "total" }),
			},
			scroll = {
				timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
				subscroll = animate.gen_subscroll.equal({
				predicate = function(total_scroll)
					if mouse_scrolled then
					mouse_scrolled = false
					return false
					end
					return total_scroll > 1
				end,
				}),
			},
			}
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = "LazyFile",
		opts = {
		-- symbol = "▏",
		symbol = "│",
		options = { try_as_border = true },
		},
		init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
			"alpha",
			"dashboard",
			"fzf",
			"help",
			"lazy",
			"lazyterm",
			"mason",
			"neo-tree",
			"notify",
			"toggleterm",
			"Trouble",
			"trouble",
			},
			callback = function()
			vim.b.miniindentscope_disable = true
			end,
		})
		end,
	},
	{
		"echasnovski/mini.starter",
		version = false,
		event = "VimEnter",
		opts = function()
		local logo = table.concat({
			"            ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z",
			"            ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    ",
			"            ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       ",
			"            ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         ",
			"            ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           ",
			"            ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           ",
		}, "\n")
		local pad = string.rep(" ", 22)
		local new_section = function(name, action, section)
			return { name = name, action = action, section = pad .. section }
		end

		local starter = require("mini.starter")
		local config = {
			evaluate_single = true,
			header = logo,
			items = {
			new_section("Find file",       LazyVim.pick(),                        "Telescope"),
			new_section("New file",        "ene | startinsert",                   "Built-in"),
			new_section("Recent files",    LazyVim.pick("oldfiles"),              "Telescope"),
			new_section("Find text",       LazyVim.pick("live_grep"),             "Telescope"),
			new_section("Config",          LazyVim.pick.config_files(),           "Config"),
			new_section("Restore session", [[lua require("persistence").load()]], "Session"),
			new_section("Lazy Extras",     "LazyExtras",                          "Config"),
			new_section("Lazy",            "Lazy",                                "Config"),
			new_section("Quit",            "qa",                                  "Built-in"),
			},
			content_hooks = {
			starter.gen_hook.adding_bullet(pad .. "░ ", false),
			starter.gen_hook.aligning("center", "center"),
			},
		}
		return config
		end,
		config = function(_, config)
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
			pattern = "MiniStarterOpened",
			callback = function()
				require("lazy").show()
			end,
			})
		end

		local starter = require("mini.starter")
		starter.setup(config)

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function(ev)
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			local pad_footer = string.rep(" ", 8)
			starter.config.footer = pad_footer .. "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
			if vim.bo[ev.buf].filetype == "ministarter" then
				pcall(starter.refresh)
			end
			end,
		})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = function()
			local tsc = require("treesitter-context")

			LazyVim.toggle.map("<leader>ut", {
			name = "Treesitter Context",
			get = tsc.enabled,
			set = function(state)
				if state then
				tsc.enable()
				else
				tsc.disable()
				end
			end,
			})

			return { mode = "cursor", max_lines = 3 }
		end,
	},
}