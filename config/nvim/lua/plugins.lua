return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
  use("williamboman/nvim-lsp-installer")
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp").lspconfig()
		end,
	})
	use("tpope/vim-fugitive")
	use({
		"karb94/neoscroll.nvim",
		config = function()
			require("neoscroll").setup()
		end,
	})
	use({
		"lervag/vimtex",
		ft = "tex",
	})
	-- use({
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	event = "BufRead",
	-- 	config = function()
	-- 		require("indent_blankline").setup({
	-- 			show_current_context = true,
	-- 		})
	-- 	end,
	-- })
	use({
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup({
				bind = true,
				doc_lines = 2,
				floating_window = true,
				fix_pos = true,
				hint_enable = true,
				hint_prefix = " ",
				hint_scheme = "String",
				hi_parameter = "Search",
				max_height = 22,
				max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
				handler_opts = {
					border = "single", -- double, single, shadow, none
				},
				zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
				padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
			})
		end,
	})
	use({
		"folke/todo-comments.nvim",
		config = function()
			require("todo-comments").setup({})
		end,
	})
	use("nvim-telescope/telescope-project.nvim")
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
	-- use({ "kabouzeid/nvim-lspinstall" })
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"onsails/lspkind-nvim",
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip-integ",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("lsp").cmp()
		end,
	})
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({})
		end,
	})
	use({ "lewis6991/gitsigns.nvim", config = [[require("git")]] })
	use({
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup()
		end,
	})
	-- use("JoosepAlviste/nvim-ts-context-commentstring")
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
	use("akinsho/bufferline.nvim")
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
