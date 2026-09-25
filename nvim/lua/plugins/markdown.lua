---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "markdown.mdx" },
      render_modes = { "n", "c", "t" },
      completions = { blink = { enabled = true } },
      heading = { width = "full" },
      code = { width = "full", border = "thin" },
    },
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<Leader>Mr"] = { "<Cmd>RenderMarkdown toggle<CR>", desc = "Toggle inline rendering" }
      maps.n["<Leader>Mv"] = { "<Cmd>RenderMarkdown preview<CR>", desc = "Preview inside Neovim" }
    end,
  },
}
