-- vim:fdm=marker
local cmd = vim.cmd
local g = vim.g
local o = vim.o
local map = require("utils").map

-- Lazy.nvim setup {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- }}}
------------------ General Config -------------------- {{{1
g.mapleader = [[ ]] -- Make the spacebar the leader key
o.number = true -- Line numbers are good
o.backspace = "indent,eol,start" -- Allow backspace in insert mode
o.history = 1000 -- Store lots of :cmdline history
o.showcmd = true -- Show incomplete cmds down the bottom
o.autoread = true -- Reload files changed outside vim
o.ttimeout = true -- https://vi.stackexchange.com/a/20220
o.completeopt = "menu,menuone,noselect"
o.ttimeoutlen = 100
o.hidden = true
o.showmode = false
o.mouse = "a"
o.swapfile = false
o.backup = false
o.writebackup = false
o.showtabline = 2
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.cursorline = true
o.signcolumn = "yes"
o.colorcolumn = "80"
o.undofile = true
o.termguicolors = true
o.smartcase = true
o.incsearch = true
o.ignorecase = true
o.laststatus = 2

-- Create a command named 'Vimrc' that will open the .vimrc file
cmd("command! Vimrc :e $HOME/.config/nvim/init.lua")

-- Bink yanked text
cmd([[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua require("vim.highlight").on_yank({higroup = "Search", timeout = 200})
  augroup END
]])

------------------ LSP -------------------- {{{1
-- Treat javascript as javascriptreact
cmd([[
augroup filetype_jsx
    autocmd!
    autocmd FileType javascript set filetype=javascriptreact
augroup END
]])

g["tex_flavor"] = "latex"

cmd([[
syntax spell toplevel
autocmd FileType tex setlocal spell
]])

------------------ Mapping -------------------- {{{1
-- See https://github.com/neovide/neovide/issues/1340
-- vim.cmd("map <C-[> <Esc>")

-- I ain't perfect I need some tree
map("n", "<leader><tab>", ":Neotree toggle<CR>", "silent")

-- Searching
map("n", "<leader>;", "<cmd>Telescope projects<cr>")
map("n", "<leader><space>", "<cmd>Telescope find_files<cr>")
map("n", "<leader>t", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>b", "<cmd>Telescope buffers<cr>")
map("n", "<leader>n", "<cmd>Telescope lsp_document_symbols<CR>", "silent")
map("n", "<leader>N", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "silent")

-- LSP
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", "silent")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "silent")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", "silent")
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "silent")
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", "silent")
map("nv", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", "silent")

-- Diagnostics
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", "silent")
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", "silent")
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", "silent")
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", "silent")
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", "silent")
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", "silent")

-- Show all diagnostics on current line in floating window
map("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", "silent")

-- Switch to last
map("n", "<leader>s", "<C-^>")

-- Disable search
map("n", "<leader>\\", "<cmd>nohlsearch<CR>", "silent")

-- Yeet
map("n", "Y", "y$")

-- Copy into clipboard
map("nv", "<C-y>", '"+y')
map("nv", "<C-Y>", '"+y$')

-- Yeet from clipboard
map("nv", "<C-p>", '"+p')
map("nv", "<C-P>", '"+P')

-- Delete without overwriting the default register
-- map("nv", "<leader>d", '"_d')

-- Paste without overwriting the default register
-- map("v", "<leader>p", '"_dP')

-- Indent without leaving visual mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Add banklines (without comments)
map("n", "<C-,>", ":set paste<CR>O<ESC>j:set nopaste<CR>", "silent")
map("n", "<C-.>", ":set paste<CR>o<ESC>k:set nopaste<CR>", "silent")

-- Quickfix baby
map("n", "<C-\\>", ":cnext<CR>zz", "silent")
map("n", "<C-]>", ":cprev<CR>zz", "silent")
map(
	"n",
	"<leader>q",
	'"<cmd>".(get(getqflist({"winid": 1}), "winid") != 0? "cclose" : "botright copen")."<cr>"',
	"silent expr"
)

-- Git
map("n", "<leader>gg", "<cmd>Git<cr>", "silent")

-- Buffer tabs
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", "silent")
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", "silent")
map("n", ">b", "<cmd>BufferLineMoveNext<cr>", "silent")
map("n", "<b", "<cmd>BufferLineMovePrev<cr>", "silent")

-- Buffers are hard
map("n", "<leader>h", "<C-w>s", "silent")
map("n", "<leader>v", "<C-w>v", "silent")
map("n", "<leader>c", "<C-w>c", "silent")
map("n", "<leader>C", ":Bdelete<CR>", "silent")

map("n", "<C-h>", ":lua require('smart-splits').move_cursor_left()<CR>", "silent")
map("n", "<C-j>", ":lua require('smart-splits').move_cursor_down()<CR>", "silent")
map("n", "<C-k>", ":lua require('smart-splits').move_cursor_up()<CR>", "silent")
map("n", "<C-l>", ":lua require('smart-splits').move_cursor_right()<CR>", "silent")

-- map("n", "<C-H>", ":lua require('smart-splits').resize_left()<CR>", "silent")
-- map("n", "<C-J>", ":lua require('smart-splits').resize_up()<CR>", "silent")
-- map("n", "<C-K>", ":lua require('smart-splits').resize_down()<CR>", "silent")
-- map("n", "<C-L>", ":lua require('smart-splits').resize_right()<CR>", "silent")

-- <C-w> too hard...
-- map("n", "<leader>w", "<C-w>")

-- https://castel.dev/post/lecture-notes-1/#correcting-spelling-mistakes-on-the-fly
cmd([[
  inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
]])

cmd("command! Snip :Telescope find_files cwd=$HOME/.config/nvim/snippets")

-- Acing those interviews :')
cmd([[
	nnoremap <leader>ll :LeetCodeList<cr>
	nnoremap <leader>lt :LeetCodeTest<cr>
	nnoremap <leader>ls :LeetCodeSubmit<cr>
	nnoremap <leader>li :LeetCodeSignIn<cr>
]])

-- Snippin
cmd([[
  imap <expr> <Tab> snippy#can_expand_or_advance() ? '<Plug>(snippy-expand-or-advance)' : '<Tab>'
  imap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
  smap <expr> <Tab> snippy#can_jump(1) ? '<Plug>(snippy-next)' : '<Tab>'
  smap <expr> <S-Tab> snippy#can_jump(-1) ? '<Plug>(snippy-previous)' : '<S-Tab>'
  xmap <Tab> <Plug>(snippy-cut-text)
]])

------------------ Plugins -------------------- {{{1
require("lazy").setup({
	"nvim-lua/plenary.nvim",
	"famiu/bufdelete.nvim",
	"andweeb/presence.nvim",
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{
		"akinsho/bufferline.nvim",
		version = "v3.*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup()
		end,
	},
	{
		"catppuccin/nvim",
		priority = 1000,
		name = "catppuccin",
		config = function()
			cmd.colorscheme("catppuccin")
			require("catppuccin").setup({
				fidget = true,
			})
		end,
	},
	{
		"declancm/cinnamon.nvim",
		config = function()
			require("cinnamon").setup()
		end,
	},
	"tpope/vim-fugitive",
	{
		"rebelot/heirline.nvim",
		event = "UiEnter",
		config = function()
			require("statusbar")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = "nvim-telescope/telescope-project.nvim",
		config = function()
			local telescope = require("telescope")
			telescope.setup({})
			telescope.load_extension("projects")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
			})
		end,
	},
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v1.x",
		dependencies = {
			-- LSP Support
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			{
				"ray-x/lsp_signature.nvim",
				config = function()
					require("lsp_signature").setup({})
				end,
			},

			-- Autocompletion
			"hrsh7th/nvim-cmp",
			"dcampos/nvim-snippy",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"dcampos/cmp-snippy",
			"dcampos/nvim-snippy",
		},
		config = function()
			local lsp = require("lsp-zero").preset({
				name = "minimal",
				set_lsp_keymaps = true,
				manage_nvim_cmp = false,
				manage_luasnip = false,
				suggest_lsp_servers = false,
				virtual_text = true,
			})

			local cmp = require("cmp")
			local types = require("cmp.types")
			local snippy = require("snippy")

			snippy.setup({})

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						snippy.expand_snippet(args.body)
					end,
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = require("lspkind").cmp_format({
						mode = "symbol", -- show only symbol annotations
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					}),
				},
				mapping = {
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
					}),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
					["<C-n>"] = cmp.mapping(
						cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
						{ "i", "c" }
					),
					["<C-p>"] = cmp.mapping(
						cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
						{ "i", "c" }
					),
				},
				sources = {
					{ name = "path" },
					{ name = "nvim_lsp" },
					{ name = "snippy" },
					{ name = "buffer" },
					{ name = "orgmode" },
				},
			})

			lsp.setup()

			local null_ls = require("null-ls")
			local null_opts = lsp.build_options("null-ls", {})

			-- See mason-null-ls.nvim's documentation for more details:
			-- https://github.com/jay-babu/mason-null-ls.nvim#setup
			require("mason-null-ls").setup({
				ensure_installed = {
					-- Opt to list sources here, when available in mason.
				},
				automatic_installation = false,
				handlers = {},
			})

			null_ls.setup({
				on_attach = function(client, bufnr)
					null_opts.on_attach(client, bufnr)

					local format_cmd = function(input)
						vim.lsp.buf.format({
							id = client.id,
							timeout_ms = 5000,
							async = input.bang,
						})
					end

					local bufcmd = vim.api.nvim_buf_create_user_command
					bufcmd(bufnr, "NullFormat", format_cmd, {
						bang = true,
						range = true,
						desc = "Format using null-ls",
					})

					-- Format on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = format_cmd,
					})
				end,
				sources = {
					null_ls.builtins.formatting.zigfmt,
				},
			})

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/lsp.md#configure-diagnostics
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = false,
				float = true,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				window = {
					mappings = {
						["/"] = "noop",
					},
				},
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "契" },
					topdelete = { text = "契" },
					changedelete = { text = "▎" },
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				manual_mode = true,
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		event = "BufWinEnter",
		config = function()
			require("toggleterm").setup({
				open_mapping = "<C-t>",
				direction = "float",
			})
		end,
	},
	{
		"lervag/vimtex",
		ft = "tex",
		config = function()
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_quickfix_enabled = 0
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	},
	{
		"folke/which-key.nvim",
		opts = {},
	},
	{
		"mrjones2014/smart-splits.nvim",
		config = function()
			require("smart-splits").setup({})
		end,
	},
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({
				window = {
					blend = 0,
				},
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup()
		end,
	},
	-- {
	-- 	"echasnovski/mini.jump",
	-- 	version = "*",
	-- 	config = function()
	-- 		require("mini.jump").setup()
	-- 	end,
	-- },
	{
		"echasnovski/mini.bracketed",
		version = "*",
		config = function()
			require("mini.bracketed").setup()
		end,
	},
	{
		"nvim-orgmode/orgmode",
		config = function()
			require("orgmode").setup_ts_grammar()

			-- Tree-sitter configuration
			require("nvim-treesitter.configs").setup({
				-- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
				highlight = {
					enable = true,
					disable = { "org" }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
					additional_vim_regex_highlighting = { "org" }, -- Required since TS highlighter doesn't support all syntax features (conceal)
				},
				ensure_installed = { "org" }, -- Or run :TSUpdate org
			})

			require("orgmode").setup({
				org_agenda_files = { "~/my-orgs/**/*" },
			})
		end,
	},
})
