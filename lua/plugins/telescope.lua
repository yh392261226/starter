return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {"<leader>/", false},
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
  },
  
  -- 使用函数式配置确保正确加载顺序
  init = function()
    -- 确保在Telescope加载前设置默认值
    require("telescope").setup({
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            anchor = "bottom",
            height = 0.4,
            preview_width = 0.6,
            prompt_position = "bottom",
          },
        },
        border = true,
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
          layout_config = {
            width = 0.8,  -- 增加宽度设置
          }
        },
      }
    })
  end,
  
  -- 添加此配置确保覆盖所有设置
  config = function(_, opts)
    require("telescope").setup(opts)
  end
}