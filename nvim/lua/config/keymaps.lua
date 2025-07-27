vim.opt.clipboard = "unnamedplus" -- 共享系统剪贴板

-- 撤销 (Cmd+U)
vim.keymap.set("n", "<D-u>", ":undo<CR>", { noremap = true, silent = true })
vim.keymap.set("i", "<D-u>", "<Esc>:undo<CR>a", { noremap = true, silent = true })

-- Neovide 专属设置
if vim.g.neovide then
  -- 复制粘贴 (Ctrl+Shift+C/V)
  vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true })
  vim.keymap.set("n", "<C-S-v>", '"+p', { noremap = true, silent = true })
  vim.keymap.set("i", "<C-S-v>", "<C-r>+", { noremap = true, silent = true })

  -- Neovide 专用保存快捷键 (Cmd+S)
  vim.keymap.set("n", "<D-s>", ":w<CR>", { noremap = true, silent = true })
  vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>a", { noremap = true, silent = true }) -- 插入模式也生效
  -- 其他 Neovide 优化
  vim.g.neovide_input_use_logo = true
  vim.g.neovide_remember_window_size = true -- 记住窗口大小
end
