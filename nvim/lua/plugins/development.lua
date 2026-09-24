local function paste_clipboard()
  vim.api.nvim_paste(vim.fn.getreg "+", true, -1)
end

local function bottom_terminal()
  vim.cmd "1ToggleTerm size=12 direction=horizontal"
end

local function floating_terminal()
  vim.cmd "2ToggleTerm direction=float"
end

---@type LazySpec
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        opt = {
          clipboard = "unnamedplus",
          number = true,
          relativenumber = true,
          signcolumn = "yes",
        },
      },
      mappings = {
        n = {
          -- These are also the default AstroNvim mappings; keeping them here makes
          -- the requested keys explicit and protects them from future overrides.
          ["<Leader>e"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
          ["<Leader>a"] = { function() require("aerial").toggle() end, desc = "Toggle symbol outline" },

          ["<F7>"] = { bottom_terminal, desc = "Bottom terminal" },
          ["<F8>"] = { floating_terminal, desc = "Floating terminal" },
          ["<C-S-`>"] = { bottom_terminal, desc = "Bottom terminal" },
          ["<C-S-/>"] = { floating_terminal, desc = "Floating terminal" },

          ["<D-c>"] = { '"+yy', desc = "Copy line" },
          ["<D-v>"] = { paste_clipboard, desc = "Paste" },
          ["<D-z>"] = { "u", desc = "Undo" },
          ["<D-S-z>"] = { "<C-r>", desc = "Redo" },
          ["<D-s>"] = { "<Cmd>write<CR>", desc = "Save file" },
        },
        i = {
          ["<F7>"] = { bottom_terminal, desc = "Bottom terminal" },
          ["<F8>"] = { floating_terminal, desc = "Floating terminal" },
          ["<C-S-`>"] = { bottom_terminal, desc = "Bottom terminal" },
          ["<C-S-/>"] = { floating_terminal, desc = "Floating terminal" },
          ["<D-v>"] = { paste_clipboard, desc = "Paste" },
          ["<D-z>"] = { "<C-o>u", desc = "Undo" },
          ["<D-S-z>"] = { "<C-o><C-r>", desc = "Redo" },
          ["<D-s>"] = { "<Esc><Cmd>write<CR>a", desc = "Save file" },
        },
        v = {
          ["<D-c>"] = { '"+y', desc = "Copy selection" },
          ["<D-v>"] = { '"_d"+P', desc = "Paste over selection" },
        },
        c = {
          ["<D-v>"] = { "<C-r>+", desc = "Paste" },
        },
        t = {
          ["<F7>"] = { bottom_terminal, desc = "Bottom terminal" },
          ["<F8>"] = { floating_terminal, desc = "Floating terminal" },
          ["<C-S-`>"] = { bottom_terminal, desc = "Bottom terminal" },
          ["<C-S-/>"] = { floating_terminal, desc = "Floating terminal" },
          ["<D-v>"] = { paste_clipboard, desc = "Paste" },
        },
      },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    opts = {
      direction = "horizontal",
      size = 12,
      float_opts = { border = "rounded" },
    },
  },

  -- Show variable values inline while a debug session is paused.
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
}
