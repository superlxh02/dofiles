---@type LazySpec
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      term_colors = true,
      dim_inactive = { enabled = false },
      auto_integrations = true,
      integrations = {
        aerial = true,
        blink_cmp = { style = "bordered" },
        dap = true,
        dap_ui = true,
        gitsigns = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = { enabled = true },
        neotree = true,
        snacks = { indent_scope_color = "lavender" },
        treesitter = true,
        which_key = true,
      },
    },
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    -- AstroNvim v5's native Nerd Font icon provider. It also provides a
    -- nvim-web-devicons compatibility layer for plugins that expect it.
    "nvim-mini/mini.icons",
    opts = {
      style = "glyph",
    },
  },
}
