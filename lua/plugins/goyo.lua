if true then return {} end

return {
  -- add symbols-outline
  {
    "junegunn/limelight.vim",
    dependencies = { "junegunn/goyo.vim" },
    cmd = "Limelight",
    keys = { { "<leader>ug", "<cmd>Limelight<cr>", desc = "Toggle Goyo mode" } },
    opts = {
      
    },
  },
}
