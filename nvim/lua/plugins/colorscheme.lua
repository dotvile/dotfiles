return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    style = "deep",
  },
  config = function(_, opts)
    require("onedark").setup(opts)
    require("onedark").load()
  end,
}
