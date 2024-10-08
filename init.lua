-- generic config
vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.wo.number = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.wrap = false
vim.o.laststatus = 0
vim.cmd "set noshowmode"
vim.o.title = true
vim.o.termguicolors = true
vim.opt.titlestring = [[%t – %{fnamemodify(getcwd(), ':t')}]]
vim.o.splitright = true

-- clipboard magic
vim.api.nvim_set_option('clipboard', 'unnamedplus');

-- package manager (Lazy)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- plugins
local plugins = {
	{
		'eraserhd/parinfer-rust',
		build = {
			'cargo build --release'
		}
	},
	{
		'b0o/incline.nvim',
		config = function()
			require('incline').setup()
		end,
		event = 'VeryLazy'
	},
	'Olical/conjure',
	'lewis6991/gitsigns.nvim',
	'navarasu/onedark.nvim',
	'neovim/nvim-lspconfig',
	--'askonomm/vscode.nvim',
	'nvim-treesitter/nvim-treesitter',
	'mg979/vim-visual-multi',
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
			'nvim-telescope/telescope.nvim',
			'ibhagwan/fzf-lua',
		},
		config = true
	},
	'github/copilot.vim',
	{
		'nvim-neo-tree/neo-tree.nvim',
		branch = 'v3.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
			'MunifTanjim/nui.nvim',
			'3rd/image.nvim'
		}
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.8',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
}

require('lazy').setup(plugins, {})

-- plugin: gitsigns
require('gitsigns').setup()

-- plugin: onedark
require('onedark').setup({
	style = 'warmer',
	colors = { fg = '#ffffff' },
})

require('onedark').load()

-- plugin: treesitter
require('nvim-treesitter.configs').setup({
	highlight = {
		enable = true
	},
	indent = {
		enable = true
	},
})

-- plugin: telescope
require('telescope').setup({
	defaults = {
		layout_strategy = 'vertical',
		layout_config = {
			prompt_position = 'bottom',
			height = 0.9
		},
	},
	pickers = {
		find_files = {
			find_command = { 
				'rg', '--files', '--hidden', '--glob=!.git/', '--glob=!node_modules/',
				'--glob=!dist/', '--glob=!build/', '--glob=!target/', '--glob=!*.min.js',
				'--glob=!*.min.css', '--glob=!*.min.html', '--glob=!*.min.json',
				'--glob=!vendor/'
			}
		}
	},
})


-- lsp
require('lspconfig').tsserver.setup({})

require('lspconfig').intelephense.setup({
	settings = {
		intelephense = {
			environment = {
				phpVersion = '8.3',
			},
		},
	},
	root_dir = function(fname) return vim.loop.cwd() end,
})

require('lspconfig').jsonls.setup({})

require('lspconfig').cssls.setup({})

require('lspconfig').html.setup({})

require('lspconfig').clojure_lsp.setup({})

-- shortcuts
local ts = require('telescope.builtin')

-- shortcuts: general
vim.keymap.set('n', 'mo', '<cmd>Neotree<cr>')
vim.keymap.set('n', 'mc', '<cmd>Neotree close<cr>')
vim.keymap.set('n', 'bp', '<cmd>BufferPrevious<cr>')
vim.keymap.set('n', 'bn', '<cmd>BufferNext<cr>')
vim.keymap.set('n', 'bc', '<cmd>BufferClose<cr>')
vim.keymap.set('n', 'ff', ts.find_files, {})
vim.keymap.set('n', 'fg', ts.live_grep, {})
vim.keymap.set('n', 'fb', ts.buffers, {})
vim.keymap.set('n', 'fh', ts.help_tags, {})

-- shortcuts: lsp
vim.keymap.set('n', 'ld', ts.lsp_definitions, {})
vim.keymap.set('n', 'lr', ts.lsp_references, {})
vim.keymap.set('n', 'li', ts.lsp_implementations, {})
vim.keymap.set('n', 'lh', '<cmd>lua vim.lsp.buf.hover()<cr>')
vim.keymap.set('n', 'lrn', '<cmd>lua vim.lsp.buf.rename()<cr>')
vim.keymap.set('n', 'lca', '<cmd>lua vim.lsp.buf.code_action()<cr>')
vim.keymap.set('n', 'lff', '<cmd>lua vim.lsp.buf.format()<cr>')
vim.keymap.set('n', 'le', '<cmd>lua vim.diagnostic.open_float()<cr>')

-- shortcuts: git
vim.keymap.set('n', 'gs', ts.git_status, {})
vim.keymap.set('n', 'gc', ts.git_commits, {})
vim.keymap.set('n', 'gb', ts.git_branches, {})
vim.keymap.set('n', 'gz', ts.git_stash, {})
vim.keymap.set('n', 'gg', '<cmd>Neogit<cr>')

-- shortcuts: clojure
vim.keymap.set('n', 'ev', '<cmd>ConjureEvalCurrentForm<cr>')
vim.keymap.set('n', 'er', '<cmd>ConjureEvalRootForm<cr>')
vim.keymap.set('n', 'eb', '<cmd>ConjureEvalBuf<cr>')
vim.keymap.set('n', 'repl', '<cmd>ConjureLogVSplit<cr>')

-- misc
vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = '#232326' })
vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = '#232326' })
vim.api.nvim_set_hl(0, 'NeoTreeVertSplit', { bg = '#232326' })
vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { bg = '#232326', fg = '#232326' })
vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = '#232326' })

require('show_mode')
