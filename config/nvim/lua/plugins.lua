return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use({ "neovim/nvim-lspconfig", config = [[require("lsp")]] })
	use("machakann/vim-sandwich")
	use("psliwka/vim-smoothie")
	use("christoomey/vim-tmux-navigator")
	use("tpope/vim-fugitive")
	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		config = function()
			local telescope = require("telescope")
			telescope.setup({})
			telescope.load_extension("projects")
		end,
	})
	use({
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
	})
	use({ "kabouzeid/nvim-lspinstall" })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"onsails/lspkind-nvim",
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
		},
	})
	use("kyazdani42/nvim-tree.lua")
	use({ "lewis6991/gitsigns.nvim", config = [[require("git")]] })
	use({
		"terrortylor/nvim-comment",
		event = "BufRead",
		config = function()
			require("nvim_comment").setup({
				hook = function()
					require("ts_context_commentstring.internal").update_commentstring()
				end,
			})
		end,
	})
	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
	})
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			vim.g.nvim_tree_update_cwd = 1
			vim.g.nvim_tree_respect_buf_cwd = 1

			require("project_nvim").setup({
				manual_mode = true,
			})
		end,
	})
	use("kyazdani42/nvim-web-devicons")
	use({
		"hoob3rt/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
				},
			})
		end,
	})
	use({ "romgrk/barbar.nvim", event = "BufWinEnter" })
	use({
		"akinsho/nvim-toggleterm.lua",
		event = "BufWinEnter",
		config = function()
			require("toggleterm").setup({
				open_mapping = "<C-t>",
				direction = "float",
			})
		end,
	})
	use({
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd("colorscheme tokyonight")
		end,
	})
end)
