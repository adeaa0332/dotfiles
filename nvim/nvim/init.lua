-- ============================================================
-- 1. Bootstrap the plugin manager (mini.deps)
-- ============================================================
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing mini.nvim..." | redraw')
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', -- FIXED: full repo URL
    mini_path,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
end
require('mini.deps').setup({ path = { package = path_package } })

-- ============================================================
-- 2. Core editor options (set early so everything inherits them)
-- ============================================================
vim.g.mapleader = ' '        -- Space as leader
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true    -- highlight the current line
vim.opt.signcolumn = 'yes'   -- stop the gutter from jumping around
vim.opt.termguicolors = true -- required for modern colorschemes
vim.opt.scrolloff = 8        -- keep some context above/below the cursor
vim.opt.mouse = 'a'
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.cmd([[filetype plugin indent on]])

-- ============================================================
-- 3. Install plugins
-- ============================================================
MiniDeps.add({ source = 'williamboman/mason.nvim' })
MiniDeps.add({ source = 'williamboman/mason-lspconfig.nvim' })
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
MiniDeps.add({ source = 'nvim-lua/plenary.nvim' })
MiniDeps.add({ source = 'nvim-telescope/telescope.nvim' })
MiniDeps.add({ source = 'windwp/nvim-autopairs' })
MiniDeps.add({
  source = 'saghen/blink.cmp',
  checkout = 'v1.6.0',  -- pin a release tag so you get the prebuilt fuzzy binary
  depends = { 'rafamadriz/friendly-snippets' },
})

-- ============================================================
-- 1. Bootstrap the plugin manager (mini.deps)
-- ============================================================
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing mini.nvim..." | redraw')
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', -- FIXED: full repo URL
    mini_path,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
end
require('mini.deps').setup({ path = { package = path_package } })

-- ============================================================
-- 2. Core editor options (set early so everything inherits them)
-- ============================================================
vim.g.mapleader = ' '        -- Space as leader
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true    -- highlight the current line
vim.opt.signcolumn = 'yes'   -- stop the gutter from jumping around
vim.opt.termguicolors = true -- required for modern colorschemes
vim.opt.scrolloff = 8        -- keep some context above/below the cursor
vim.opt.mouse = 'a'
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.cmd([[filetype plugin indent on]])

-- ============================================================
-- 3. Install plugins
-- ============================================================
MiniDeps.add({ source = 'williamboman/mason.nvim' })
MiniDeps.add({ source = 'williamboman/mason-lspconfig.nvim' })
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
MiniDeps.add({ source = 'nvim-lua/plenary.nvim' })
MiniDeps.add({ source = 'nvim-telescope/telescope.nvim' })
MiniDeps.add({ source = 'windwp/nvim-autopairs' })


-- Colorscheme (swap for catppuccin / kanagawa / gruvbox-material if you like)
MiniDeps.add({ source = 'folke/tokyonight.nvim' })

-- ============================================================
-- 4. Pretty UI (all from the mini.nvim you already have)
-- ============================================================
require('mini.icons').setup()      -- icons; set up BEFORE telescope/statusline
require('mini.statusline').setup()  -- mode / git / diagnostics / location bar
require('mini.tabline').setup()     -- buffer tabs across the top
require('mini.starter').setup()     -- dashboard on empty startup
require('nvim-autopairs').setup()


vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#8a90b0' })        -- dim grey for other lines
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e0e0e0', bold = true }) -- bright for current line
  end,
})
-- Colorscheme (wrapped so a missing plugin on first launch doesn't error)
pcall(vim.cmd, 'colorscheme tokyonight-night')

-- ============================================================
-- 5. Telescope (nicer layout + borders)
-- ============================================================
require('telescope').setup({
  defaults = {
    prompt_prefix = '   ',
    selection_caret = '  ',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = { prompt_position = 'top', preview_width = 0.55 },
      width = 0.87,
      height = 0.80,
    },
    sorting_strategy = 'ascending',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  },
})

-- ============================================================
-- 7. Mason + LSP
-- ============================================================
require('mason').setup({
  ui = {
    border = 'rounded',
    icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
  },
})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls' },
})

-- Rounded borders on hover / signature popups
vim.o.winborder = 'rounded'

require('lspconfig').ts_ls.setup({
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx',
    'typescript', 'typescriptreact',
  },
})

require('blink.cmp').setup({
  keymap = { preset = 'default' },  -- <C-y> accept, <C-n>/<C-p> move, <C-e> cancel
  appearance = { nerd_font_variant = 'mono' },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    menu = { border = 'rounded' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
})
-- Prettier diagnostic gutter symbols
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ============================================================
-- 8. Keymaps
-- ============================================================
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })

vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Prev buffer' })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keyboard shortcuts',
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

-- ============================================================
-- 9. Convenience command to pull parsers
-- ============================================================
vim.api.nvim_create_user_command('InstallParsers', function()
  vim.cmd('TSInstall javascript typescript lua')
end, {})

-- ============================================================
-- 1. Bootstrap the plugin manager (mini.deps)
-- ============================================================
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing mini.nvim..." | redraw')
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', -- FIXED: full repo URL
    mini_path,
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
end
require('mini.deps').setup({ path = { package = path_package } })

-- ============================================================
-- 2. Core editor options (set early so everything inherits them)
-- ============================================================
vim.g.mapleader = ' '        -- Space as leader
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true    -- highlight the current line
vim.opt.signcolumn = 'yes'   -- stop the gutter from jumping around
vim.opt.termguicolors = true -- required for modern colorschemes
vim.opt.scrolloff = 8        -- keep some context above/below the cursor
vim.opt.mouse = 'a'
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.cmd([[filetype plugin indent on]])

-- ============================================================
-- 3. Install plugins
-- ============================================================
MiniDeps.add({ source = 'williamboman/mason.nvim' })
MiniDeps.add({ source = 'williamboman/mason-lspconfig.nvim' })
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
MiniDeps.add({ source = 'nvim-lua/plenary.nvim' })
MiniDeps.add({ source = 'nvim-telescope/telescope.nvim' })
MiniDeps.add({ source = 'windwp/nvim-autopairs' })


-- Colorscheme (swap for catppuccin / kanagawa / gruvbox-material if you like)
MiniDeps.add({ source = 'folke/tokyonight.nvim' })

-- ============================================================
-- 4. Pretty UI (all from the mini.nvim you already have)
-- ============================================================
require('mini.icons').setup()      -- icons; set up BEFORE telescope/statusline
require('mini.statusline').setup()  -- mode / git / diagnostics / location bar
require('mini.tabline').setup()     -- buffer tabs across the top
require('mini.starter').setup()     -- dashboard on empty startup
require('nvim-autopairs').setup()


vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#8a90b0' })        -- dim grey for other lines
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e0e0e0', bold = true }) -- bright for current line
  end,
})
-- Colorscheme (wrapped so a missing plugin on first launch doesn't error)
pcall(vim.cmd, 'colorscheme tokyonight-night')

-- ============================================================
-- 5. Telescope (nicer layout + borders)
-- ============================================================
require('telescope').setup({
  defaults = {
    prompt_prefix = '   ',
    selection_caret = '  ',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = { prompt_position = 'top', preview_width = 0.55 },
      width = 0.87,
      height = 0.80,
    },
    sorting_strategy = 'ascending',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  },
})

-- ============================================================
-- 7. Mason + LSP
-- ============================================================
require('mason').setup({
  ui = {
    border = 'rounded',
    icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
  },
})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls' },
})

-- Rounded borders on hover / signature popups
vim.o.winborder = 'rounded'

require('lspconfig').ts_ls.setup({
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx',
    'typescript', 'typescriptreact',
  },
})

-- Prettier diagnostic gutter symbols
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ============================================================
-- 8. Keymaps
-- ============================================================
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })

vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Prev buffer' })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keyboard shortcuts',
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

-- ============================================================
-- 9. Convenience command to pull parsers
-- ============================================================
vim.api.nvim_create_user_command('InstallParsers', function()
  vim.cmd('TSInstall javascript typescript lua')
end, {})


-- Colorscheme (swap for catppuccin / kanagawa / gruvbox-material if you like)
MiniDeps.add({ source = 'folke/tokyonight.nvim' })

-- ============================================================
-- 4. Pretty UI (all from the mini.nvim you already have)
-- ============================================================
require('mini.icons').setup()      -- icons; set up BEFORE telescope/statusline
require('mini.statusline').setup()  -- mode / git / diagnostics / location bar
require('mini.tabline').setup()     -- buffer tabs across the top
require('mini.starter').setup()     -- dashboard on empty startup
require('nvim-autopairs').setup()


vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#8a90b0' })        -- dim grey for other lines
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e0e0e0', bold = true }) -- bright for current line
  end,
})
-- Colorscheme (wrapped so a missing plugin on first launch doesn't error)
pcall(vim.cmd, 'colorscheme tokyonight-night')

-- ============================================================
-- 5. Telescope (nicer layout + borders)
-- ============================================================
require('telescope').setup({
  defaults = {
    prompt_prefix = '   ',
    selection_caret = '  ',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = { prompt_position = 'top', preview_width = 0.55 },
      width = 0.87,
      height = 0.80,
    },
    sorting_strategy = 'ascending',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  },
})

-- ============================================================
-- 7. Mason + LSP
-- ============================================================
require('mason').setup({
  ui = {
    border = 'rounded',
    icons = { package_installed = '✓', package_pending = '➜', package_uninstalled = '✗' },
  },
})
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls' },
})

-- Rounded borders on hover / signature popups
vim.o.winborder = 'rounded'

require('lspconfig').ts_ls.setup({
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx',
    'typescript', 'typescriptreact',
  },
})

-- Prettier diagnostic gutter symbols
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ============================================================
-- 8. Keymaps
-- ============================================================
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })

vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Prev buffer' })

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keyboard shortcuts',
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})

-- ============================================================
-- 9. Convenience command to pull parsers
-- ============================================================
vim.api.nvim_create_user_command('InstallParsers', function()
  vim.cmd('TSInstall javascript typescript lua')
end, {})
