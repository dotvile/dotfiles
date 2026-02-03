return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function()
    local logo = [[
▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
▐                                                                                                                  ▌
▐                                                                                                                  ▌
▐    oooooo     oooo  o8o  oooo                  .o8                .                                    .o88o.    ▌
▐     `888.     .8'   `"'  `888                 "888              .o8                                    888 `"    ▌
▐      `888.   .8'   oooo   888   .ooooo.   .oooo888   .ooooo.  .o888oo  .ooooo.   .ooooo.  ooo. .oo.   o888oo     ▌
▐       `888. .8'    `888   888  d88' `88b d88' `888  d88' `88b   888   d88' `"Y8 d88' `88b `888P"Y88b   888       ▌
▐        `888.8'      888   888  888ooo888 888   888  888   888   888   888       888   888  888   888   888       ▌
▐         `888'       888   888  888    .o 888   888  888   888   888 . 888   .o8 888   888  888   888   888       ▌
▐          `8'       o888o o888o `Y8bod8P' `Y8bod88P" `Y8bod8P'   "888" `Y8bod8P' `Y8bod8P' o888o o888o o888o      ▌
▐                                                                                                                  ▌
▐                                                                                                                  ▌
▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
        ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"

    local opts = {
      theme = "doom",
      hide = {
        -- this is taken care of by lualine
        -- enabling this messes up the actual laststatus setting after loading a file
        statusline = false,
      },
      config = {
        header = vim.split(logo, "\n"),
        -- stylua: ignore
        center = {
          { action = "Telescope file_browser", desc = " Files", icon = " ", key = "f" },
          { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
          { action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
          { action = "Telescope live_grep", desc = " Find Text", icon = " ", key = "g" },
          { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
          { action = "qa", desc = " Quit", icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "DashboardLoaded",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    return opts
  end,
  config = true,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
