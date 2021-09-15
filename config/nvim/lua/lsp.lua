local on_attach = function(client, bufnr)
	-- Format on save
	vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")

	-- Disable native lsp formatting
	client.resolved_capabilities.document_formatting = false

	--Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

local null_ls = require("null-ls")
null_ls.config({
	sources = NullLsSources(null_ls),
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
for i, v in pairs(LSPServers) do
	if type(i) == "number" then
		require("lspconfig")[v].setup({ on_attach = on_attach, capabilities = capabilities })
	else
		v.on_attach = on_attach
		v.capabilities = capabilities
		require("lspconfig")[i].setup(v)
	end
end

local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
	formatting = {
		format = function(_, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			return vim_item
		end,
	},
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = CmpMapping(cmp),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
	},
})

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
