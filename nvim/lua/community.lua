---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- Theme. Personal overrides live in lua/plugins/theme.lua.
  { import = "astrocommunity.colorscheme.catppuccin" },

  -- Language support (Treesitter, LSP, formatters and DAP adapters).
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.docker" },

  -- Front-end: Vue also imports the TypeScript pack; Tailwind imports HTML/CSS.
  -- React/TSX is covered by the TypeScript pack.
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.eslint" },
  { import = "astrocommunity.pack.prettier" },
}
