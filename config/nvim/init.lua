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
o.completeopt = "menuone,noselect"
o.ttimeoutlen = 100
o.hidden = true
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
	return {
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
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
	java_language_server = { cmd = { "/Users/boogie/Downloads/java-language-server/dist/lang_server_mac.sh" } },
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
	sumneko_lua = {
		-- ~/.local/share/nvim/lsp_servers/sumneko_lua
		cmd = { vim.fn.stdpath("data") .. "/lsp_servers/sumneko_lua/extension/server/bin/lua-language-server" },
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					path = runtime_path,
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
			},
		},
	},
}

NullLsSources = function(null_ls)
	local h = require("null-ls.helpers")

	-- vim.env.PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath "config" .. "/.prettierrc"

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
-- I ain't perfect I need some tree
map("n", "<leader><tab>", ":NvimTreeToggle<CR>", "silent")

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

-- Yeet into clipboard
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
map("n", "]q", ":cnext<CR>zz")
map("n", "[q", ":cprev<CR>zz")
map(
	"n",
	"<leader>q",
	'"<cmd>".(get(getqflist({"winid": 1}), "winid") != 0? "cclose" : "botright copen")."<cr>"',
	"silent expr"
)

-- Git
map("n", "<leader>gg", "<cmd>Git<cr>", "silent")

-- <C-w> too hard...
map("n", "<leader>w", "<C-w>")

-- Snippin
map("i", "<Tab>", "vsnip#jumpable(1) ? 'vsnip-jump-next' : '<Tab>'", "expr")
