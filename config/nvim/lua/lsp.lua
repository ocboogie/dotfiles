M = {}

local on_attach = function(client)
	-- Disable native lsp formatting, because I don't want both null-ls and
	-- native lsp formatting
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false
end

M.lspconfig = function()
	local null_ls = require("null-ls")
	null_ls.setup({
		sources = NullLsSources(null_ls),
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})

	local lspconfig = require("lspconfig")

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	for i, v in pairs(LSPServers) do
		if type(i) == "number" then
			lspconfig[v].setup({ on_attach = on_attach, capabilities = capabilities })
		else
			v.on_attach = on_attach
			v.capabilities = capabilities
			lspconfig[i].setup(v)
		end
	end

	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
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
end

M.lspconfig_installer = function()
	local lsp_installer = require("nvim-lsp-installer")
	lsp_installer.on_server_ready(function(server)
		local opts = {}
		if server.name == "jdtls" then
			opts.on_attach = on_attach
			opts.root_dir = function()
				return "/Users/boogie/School/CSE12/PA2"
			end
		end
		server:setup(opts)
	end)
end

M.cmp = function()
	local cmp = require("cmp")
	local lspkind = require("lspkind")
	-- local luasnip = require("luasnip")
	local snippy = require("snippy")

	snippy.setup({
		expand_options = {
			m = function()
				return vim.fn["vimtex#syntax#in_mathzone"]() == 1
			end,
			c = function()
				return vim.fn["vimtex#syntax#in_comment"]() == 1
			end,
		},
	})

	cmp.setup({
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = lspkind.cmp_format({
				mode = "symbol", -- show only symbol annotations
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			}),
		},
		preselect = cmp.PreselectMode.None,
		-- formatting = {
		-- 	format = function(_, vim_item)
		-- 		vim_item.kind = require("lspkind").presets.default[vim_item.kind]
		-- 		return vim_item
		-- 	end,
		-- },
		snippet = {
			expand = function(args)
				-- require("luasnip").lsp_expand(args.body)
				snippy.expand_snippet(args.body) -- For `snippy` users.
			end,
		},
		mapping = CmpMapping(cmp),
		sources = {
			{ name = "nvim_lsp" },
			{ name = "snippy" },
			{ name = "buffer" },
		},
	})
end

return M
