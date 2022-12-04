vim.keymap.set('n', 'gd<CR>', function()
  require('gtd').exec({ command = 'edit' })
end)
vim.keymap.set('n', 'gds', function()
  require('gtd').exec({ command = 'split' })
end)
vim.keymap.set('n', 'gdv', function()
  require('gtd').exec({ command = 'vsplit' })
end)
