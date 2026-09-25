local function paste_clipboard()
  vim.api.nvim_paste(vim.fn.getreg "+", true, -1)
end

local function bottom_terminal()
  vim.cmd "1ToggleTerm size=12 direction=horizontal"
end

local function floating_terminal()
  vim.cmd "2ToggleTerm direction=float"
end

local function find_in_file()
  require("spectre").open_file_search()
end

local function find_in_project()
  require("spectre").open()
end

local function find_files()
  require("snacks").picker.files {
    hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
    layout = { preset = "select" },
  }
end

local function after_escape(callback)
  return function()
    local escape = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
    vim.api.nvim_feedkeys(escape, "nx", false)
    vim.schedule(callback)
  end
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

          ["<D-f>"] = { find_in_file, desc = "Search/replace current file" },
          ["<D-S-f>"] = { find_in_project, desc = "Search/replace workspace" },
          ["<D-p>"] = { find_files, desc = "Find files" },
          ["<F2>"] = { find_in_file, desc = "Search/replace current file (Cmd+F)" },
          ["<F3>"] = { find_in_project, desc = "Search/replace workspace (Cmd+Shift+F)" },
          ["<F4>"] = { find_files, desc = "Find files (Cmd+P)" },

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
          ["<D-f>"] = { after_escape(find_in_file), desc = "Search/replace current file" },
          ["<D-S-f>"] = { after_escape(find_in_project), desc = "Search/replace workspace" },
          ["<D-p>"] = { after_escape(find_files), desc = "Find files" },
          ["<F2>"] = { after_escape(find_in_file), desc = "Search/replace current file (Cmd+F)" },
          ["<F3>"] = { after_escape(find_in_project), desc = "Search/replace workspace (Cmd+Shift+F)" },
          ["<F4>"] = { after_escape(find_files), desc = "Find files (Cmd+P)" },
          ["<D-v>"] = { paste_clipboard, desc = "Paste" },
          ["<D-z>"] = { "<C-o>u", desc = "Undo" },
          ["<D-S-z>"] = { "<C-o><C-r>", desc = "Redo" },
          ["<D-s>"] = { "<Esc><Cmd>write<CR>a", desc = "Save file" },
        },
        v = {
          ["<D-f>"] = { after_escape(find_in_file), desc = "Search/replace current file" },
          ["<D-S-f>"] = { after_escape(find_in_project), desc = "Search/replace workspace" },
          ["<D-p>"] = { after_escape(find_files), desc = "Find files" },
          ["<F2>"] = { after_escape(find_in_file), desc = "Search/replace current file (Cmd+F)" },
          ["<F3>"] = { after_escape(find_in_project), desc = "Search/replace workspace (Cmd+Shift+F)" },
          ["<F4>"] = { after_escape(find_files), desc = "Find files (Cmd+P)" },
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
