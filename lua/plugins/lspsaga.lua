local keymap = vim.keymap.set
local saga = require('lspsaga')

saga.setup()

-- Lsp finder find the symbol definition implement reference
-- if there is no implement it will hide
-- when you use action in finder like open vsplit then you can
-- use <C-t> to jump back
-- keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

-- Peek Definition
-- you can edit the definition file in this flaotwindow
-- also support open/vsplit/etc operation check definition_action_keys
-- support tagstack C-t jump back
-- keymap("n", "<Leader>pd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
