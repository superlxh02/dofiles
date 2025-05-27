-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- 对错误警告的图标
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
-- 在输入模式下也更新提示，设置为 true 也许会影响性能
update_in_insert = true,
})
