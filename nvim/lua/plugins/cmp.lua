return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-git",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "windwp/nvim-autopairs",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    local sources = {
      default = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
        { name = "buffer" },
      },
      gitcommit = {
        { name = "git" },
        { name = "buffer" },
      },
      cmdline = {
        search = { { name = "buffer" } },
        command = { { name = "path" }, { name = "cmdline" } },
      },
    }

    local mappings = {
      default = {
        ["<left>"] = cmp.mapping.scroll_docs(-4),
        ["<right>"] = cmp.mapping.scroll_docs(4),
        ["<esc>"] = cmp.mapping.abort(),
        ["<down>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.choice_active() then
            luasnip.change_choice(1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<up>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<M-Space>"] = cmp.mapping.complete(),
      },
      cmdline = {
        search = cmp.mapping.preset.cmdline({
          ["<Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end, { "c" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "c" }),
        }),
        command = cmp.mapping.preset.cmdline(),
      },
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = mappings.default,
      sources = sources.default,
    })

    cmp.setup.filetype("gitcommit", {
      sources = sources.gitcommit,
    })

    cmp.setup.cmdline({ "/", "?" }, {
      mapping = mappings.cmdline.search,
      sources = sources.cmdline.search,
    })

    cmp.setup.cmdline(":", {
      mapping = mappings.cmdline.command,
      sources = sources.cmdline.command,
    })

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
  end,
}
