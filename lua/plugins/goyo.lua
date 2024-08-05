return {
  {
    "junegunn/goyo.vim",
    cmd = "Goyo",
    keys = { { "<leader>ug", "<cmd>Goyo<cr>", desc = "Toggle Goyo mode" } },
    config = function()
      vim.g.goyo_width = 120
      vim.g.goyo_auto_save = 0
      vim.g.goyo_font = "Fira Code Medium"
      vim.g.goyo_height = '100%'

      local augroup = vim.api.nvim_create_augroup('GoyoCmds', { clear = true })
      local autocmd = vim.api.nvim_create_autocmd
      local bind = vim.keymap.set
      local unbind = vim.keymap.del

      local enter = function()
        vim.opt.wrap = true
        vim.opt.linebreak = true
        bind({'n', 'x'}, 'k', 'gk')
        bind({'n', 'x'}, 'j', 'gj')
        bind('n', 'O', 'O<Enter><Up>')
      end

      local leave = function()
        vim.opt.wrap = false
        vim.opt.linebreak = false
        unbind({'n', 'x'}, 'k')
        unbind({'n', 'x'}, 'j')
        unbind('n', 'O')
      end

      autocmd('User', { pattern = 'GoyoEnter', group = augroup, callback = enter })
      autocmd('User', { pattern = 'GoyoLeave', group = augroup, callback = leave })
    end,
  },
  {
    "junegunn/limelight.vim",
    dependencies = { "junegunn/goyo.vim" },
    cmd = "Limelight",
    keys = { { "<leader>l", "<cmd>Limelight<cr>", desc = "Toggle Limelight" } },
    config = function()
      vim.g.limelight_conceal_ctermfg = "gray"
      vim.g.limelight_conceal_ctermfg = 240
      vim.g.limelight_conceal_guifg = "DarkGray"
      vim.g.limelight_conceal_guifg = "#777777"
      vim.g.limelight_default_coefficient = 0.7
      vim.g.limelight_paragraph_span = 5
      vim.g.limelight_bop = "^\\s"
      vim.g.limelight_eop = "\\ze\\n^\\s"
      vim.g.limelight_priority = -1
    end,
  },
}