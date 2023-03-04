local cmd = vim.cmd
local g = vim.g
local o = vim.o
local map = require("utils").map

-- Auto compile when plugins.lua is changed
cmd("autocmd BufWritePost plugins.lua source <afile> | PackerCompile")

-- Load plugins
require("plugins")

------------------ General Config --------------------
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

------------------ LSP --------------------
CmpMapping = function(cmp)
	local types = require("cmp.types")

	return {
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
		-- ["<Tab>"] = cmp.mapping(function(fallback)
		-- 	local has_words_before = function()
		-- 		unpack = unpack or table.unpack
		-- 		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		-- 		return col ~= 0
		-- 			and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		-- 	end
		--
		-- 	if luasnip.expand_or_jumpable() then
		-- 		luasnip.expand_or_jump()
		-- 	elseif has_words_before() then
		-- 		cmp.complete()
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, { "i", "s" }),
		-- ["<S-Tab>"] = cmp.mapping(function(fallback)
		-- 	if luasnip.jumpable(-1) then
		-- 		luasnip.jump(-1)
		-- 	else
		-- 		fallback()
		-- 	end
		-- end, { "i", "s" }),
	}
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
LSPServers = {
	-- go install golang.org/x/tools/gopls@latest
	"gopls",
	-- pnpm install -g vscode-langservers-extracted
	"cssls",
	"html",
	"jsonls",
	-- pnpm install -g sql-language-server
	"sqlls",
	-- pnpm install -g @tailwindcss/language-server
	"tailwindcss",
	-- pnpm install -g svelte-language-server
	"svelte",
	-- pnpm install -g typescript typescript-language-server
	"tsserver",
	"rust_analyzer",
	"pyright",
	-- java_language_server = { cmd = { "/Users/boogie/Downloads/java-language-server/dist/lang_server_mac.sh" } },
	-- brew install tectonic && brew install texlab
	texlab = {
		settings = {
			texlab = {
				build = {
					onSave = true,
					executable = "tectonic",
					args = {
						"%f",
						"--synctex",
						"--keep-logs",
						"--keep-intermediates",
					},
				},
			},
		},
	},

	-- Just using lsp installer for now
	"ccls",

	-- Just using lsp installer for now
	-- sumneko_lua = {
	-- 	-- ~/.local/share/nvim/lsp_servers/sumneko_lua
	-- 	cmd = { vim.fn.stdpath("data") .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server" },
	-- 	settings = {
	-- 		Lua = {
	-- 			runtime = {
	-- 				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
	-- 				version = "LuaJIT",
	-- 				-- Setup your lua path
	-- 				path = runtime_path,
	-- 			},
	-- 			diagnostics = {
	-- 				-- Get the language server to recognize the `vim` global
	-- 				globals = { "vim" },
	-- 			},
	-- 		},
	-- 	},
	-- },
}

NullLsSources = function(null_ls)
	local h = require("null-ls.helpers")

	-- vim.env.PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/.prettierrc"

	-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
	return {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd.with({
			filetypes = {
				"typescriptreact",
				"typescript",
				"javascriptreact",
				"javascript",
				"svelte",
				"json",
				"jsonc",
				"css",
				"html",
			},
		}),
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.clang_format.with({
			filetypes = { "java" },
		}),
		-- null_ls.builtins.formatting.google_java_format.with({
		-- 	extra_args = { "--skip-javadoc-formatting" },
		-- }),
		null_ls.builtins.formatting.rustfmt,
		h.make_builtin({
			method = null_ls.methods.FORMATTING,
			filetypes = { "tex" },
			generator_opts = {
				command = "latexindent",
				ignore_stderr = true,
				to_stdin = true,
				args = { "-g /dev/stderr" },
			},
			factory = h.formatter_factory,
		}),
	}
end

-- Treat javascript as javascriptreact
cmd([[
augroup filetype_jsx
    autocmd!
    autocmd FileType javascript set filetype=javascriptreact
augroup END
]])

g["tex_flavor"] = "latex"

------------------ Mapping --------------------
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
map("nv", "<leader>d", '"_d')

-- Paste without overwriting the default register
map("v", "<leader>p", '"_dP')

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

map("n", "<A-h>", ":lua require('smart-splits').resize_left()<CR>", "silent")
map("n", "<A-j>", ":lua require('smart-splits').resize_up()<CR>", "silent")
map("n", "<A-k>", ":lua require('smart-splits').resize_down()<CR>", "silent")
map("n", "<A-l>", ":lua require('smart-splits').resize_right()<CR>", "silent")

-- <C-w> too hard...
-- map("n", "<leader>w", "<C-w>")

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
-- imap <silent><expr> <C-k> <Plug>(luasnip-expand-or-jump)

-- cmd([[
-- " press <Tab> to expand or jump in a snippet. These can also be mapped separately
-- " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
-- imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
--
-- snoremap <silent> <C-l> <cmd>lua require('luasnip').jump(1)<Cr>
-- inoremap <silent> <C-l> <cmd>lua require('luasnip').jump(1)<Cr>
-- snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>
-- inoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>
-- ]])

-- Vsnip
-- cmd([[
--   " Expand
--   imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
--   smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
--   " Expand or jump
--   imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
--   smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
--   " Jump forward or backward
--   imap <expr> <tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<tab>'
--   smap <expr> <tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<tab>'
--   imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
--   smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
--   xmap <tab> <Plug>(vsnip-cut-text)
--   "imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
--   "smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
--   "imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
--   "smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
-- ]])
