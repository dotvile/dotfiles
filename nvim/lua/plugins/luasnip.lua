return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require("luasnip")
    local types = require("luasnip.util.types")

    require("luasnip.loaders.from_vscode").lazy_load()

    luasnip.config.set_config({
      history = true,
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "<- Choice", "Error" } },
          },
        },
      },
    })

    vim.keymap.set({ "i", "s" }, "<c-n>", function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<c-t>", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { silent = true })
  end,
}
