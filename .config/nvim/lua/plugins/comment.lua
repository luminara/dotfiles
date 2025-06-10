return {
  "numToStr/Comment.nvim",
  opts = {},
  lazy = false,
  config = function()
    require("Comment").setup({
      toggler = {
        line = "<leader>cm",
        block = "gbc",
      },
    })
  end,
}
