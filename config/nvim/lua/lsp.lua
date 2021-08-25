local on_attach = function(client, bufnr)
	-- Format on save
	vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")

	-- Disable native lsp formatting
	-- if client ~= "efm" then
	-- 	client.resolved_capabilities.document_formatting = false
	-- end

	--Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

local function setup_servers()
	require("lspinstall").setup()

	local servers = require("lspinstall").installed_servers()
	for _, server in pairs(servers) do
		local config = { on_attach = on_attach }

		if server == "lua" then
			config.settings = {
				Lua = {
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
				},
			}
			-- elseif server == "svelte" then
			-- 	config.settings = {
			-- 		svelte = { plugin = { svelte = { format = { enable = false } } } },
			-- 	}
		elseif server == "efm" then
			local prettierdConfig = {
				formatCommand = 'prettierd "${INPUT}"',
				formatStdin = true,
			}

			config.init_options = { documentFormatting = true }
			config.settings = {
				rootMarkers = { ".git/" },
				languages = {
					lua = {
						{ formatCommand = "stylua -s -", formatStdin = true },
					},
					javascript = { prettierdConfig },
					javascriptreact = { prettierdConfig },
					typescript = { prettierdConfig },
					typescriptreact = { prettierdConfig },
				},
			}
			config.filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "lua" }
		end

		require("lspconfig")[server].setup(config)
	end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require("lspinstall").post_install_hook = function()
	setup_servers() -- reload installed servers
	vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- local null_ls = require("null-ls")
-- null_ls.config({
-- 	sources = {
-- 		null_ls.builtins.formatting.stylua,
-- 		null_ls.builtins.formatting.prettier,
-- 	},
-- })
-- require("lspconfig")["null-ls"].setup({
-- 	on_attach = on_attach,
-- })

vim.lsp.protocol.CompletionItemKind = {
	"   (Text) ",
	"   (Method)",
	"   (Function)",
	"   (Constructor)",
	" ﴲ  (Field)",
	"[] (Variable)",
	"   (Class)",
	" ﰮ  (Interface)",
	"   (Module)",
	" 襁 (Property)",
	"   (Unit)",
	"   (Value)",
	" 練 (Enum)",
	"   (Keyword)",
	"   (Snippet)",
	"   (Color)",
	"   (File)",
	"   (Reference)",
	"   (Folder)",
	"   (EnumMember)",
	" ﲀ  (Constant)",
	" ﳤ  (Struct)",
	"   (Event)",
	"   (Operator)",
	"   (TypeParameter)",
}

for _, sign in ipairs({
	{ name = "LspDiagnosticsSignError", text = "" },
	{ name = "LspDiagnosticsSignWarning", text = "" },
	{ name = "LspDiagnosticsSignHint", text = "" },
	{ name = "LspDiagnosticsSignInformation", text = "" },
}) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
function OrgImports(wait_ms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit)
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end

vim.cmd([[
augroup GO_LSP
	autocmd!
	autocmd BufWritePre *.go :silent! lua OrgImports(3000)
augroup END
]])
