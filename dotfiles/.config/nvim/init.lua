-- nvim global = vim.o
-- nvim local window = vim.wo
-- nvim local buffer = vim.bo
vim.o.number = true        -- enable line numbers

vim.opt.mouse     = { a = true }

vim.opt.listchars = { trail = '•', tab = '└─' }
vim.cmd( 'set list!' )

--vim.cmd [[ map <S-Insert> <MiddleMouse> ]]
vim.cmd [[ map! <S-Insert> <C-R>+ ]]
vim.cmd( 'colorscheme wombat256my' )
--vim.opt.guifont = { "Ubuntu Mono", ":h14" }
--vim.opt.guifont = { "DejaVu Sans Mono", ":h15" }
--vim.opt.guifont = {"DejaVu Sans Mono", ":h20"}
--vim.g.guifont = "DejaVu Sans Mono:h16"
--vim.opt.guifont = "JetBrainsMono Nerd Font:h14"

-- Make the background on any theme used transparent
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

vim.g.nobackup = true
vim.opt.showcmd = true     -- display incomplete commands
vim.opt.incsearch = true   -- do incremental searching
vim.opt.ignorecase = true  -- search case insensitve
vim.opt.smartcase = true   -- if search is cased do sensitive search
vim.opt.hls = true         -- highlight search
vim.opt.wrapscan = true    -- start over on EOL
vim.opt.scs = true         -- case insensitive if uppercase chars in pattern
vim.opt.cursorline = true  -- highlight line of cursor position

if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1 -- enable use of the logo (cmd) key
  vim.g.neovide_opacity = 0.95
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

if vim.g.GtkGuiLoaded == 1 then
  vim.opt.guifont = "JetBrainsMono NF ExtraLight 13"
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>',  { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

-- Disable zig auto-format
vim.g.zig_fmt_autosave = 0
