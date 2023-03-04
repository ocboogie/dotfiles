return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("famiu/bufdelete.nvim")
	use("andweeb/presence.nvim")
	use({
		"akinsho/bufferline.nvim",
		tag = "v2.*",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("bufferline").setup({})
		end,
	})
	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		config = function()
			require("lsp").lspconfig()
		end,
	})
	use("tpope/vim-fugitive")
	use({
		"declancm/cinnamon.nvim",
		config = function()
			require("cinnamon").setup()
		end,
	})
	use({
		"lervag/vimtex",
		ft = "tex",
		-- config = function()
		-- 	vim.g.vimtex_compiler_method = "tectonic"
		-- end,
	})
	use({
		"Darazaki/indent-o-matic",
		config = function()
			require("indent-o-matic").setup({})
		end,
	})
	use({
		"itchyny/lightline.vim",
		config = function()
			vim.cmd([[
				let g:lightline = {
	     	\ 'colorscheme': 'catppuccin',
				\ 'enable': { 'tabline': 0 },
	     	\ }
			]])
			-- require("feline").setup({})
		end,
		-- config = function()
		-- 	require("statusbar")
		-- end,
	})
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
	-- use({
	-- 	"folke/todo-comments.nvim",
	-- 	config = function()
	-- 		require("todo-comments").setup({})
	-- 	end,
	-- })
	use("nvim-telescope/telescope-project.nvim")
	use({
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
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
	use({
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup()
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"dcampos/nvim-snippy",
			"onsails/lspkind-nvim",
			"dcampos/cmp-snippy",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("lsp").cmp()
		end,
	})
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
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
	})
	use({ "lewis6991/gitsigns.nvim", config = [[require("git")]] })
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				manual_mode = true,
			})
		end,
	})
	use("folke/lsp-colors.nvim")
	use({
		"akinsho/toggleterm.nvim",
		event = "BufWinEnter",
		config = function()
			require("toggleterm").setup({
				open_mapping = "<C-t>",
				direction = "float",
			})
		end,
	})
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	})
	-- use({
	-- 	"dracula/vim",
	-- 	config = function()
	-- 		vim.cmd("colorscheme dracula")
	-- 	end,
	-- })
	-- use({
	-- 	"folke/tokyonight.nvim",
	-- 	config = function()
	-- 		vim.cmd("colorscheme tokyonight")
	-- 	end,
	-- })
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				-- for example, context is off by default, use this to turn it on
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	})
	use({
		"ianding1/leetcode.vim",
		config = function()
			vim.g.leetcode_browser = "firefox"
			vim.g.leetcode_solution_filetype = "python3"
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	})
	use({
		"mrjones2014/smart-splits.nvim",
		config = function()
			require("smart-splits").setup({})
		end,
	})
end)
