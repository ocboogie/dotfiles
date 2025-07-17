return {
  {
    "LazyVim/LazyVim",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader><tab>",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>t", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    },
  },
  { "andymass/vim-matchup", enabled = false },
  { "echasnovski/mini.animate", enabled = false },
  -- {
  --   "echasnovski/mini.animate",
  --   opt = {
  --     cursor = { enable = false },
  --     resize = { enable = false },
  --     open = { enable = false },
  --     close = { enable = false },
  --   },
  -- },
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
      n_lines = 100,
    },
  },
  { "folke/flash.nvim", enabled = false },
  { "mini.pairs", enabled = false },
  {
    "Saghen/blink.cmp",
    opts = {
      keymap = {
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        ghost_text = {
          enabled = false,
        },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
      },
    },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --
  --     opts.completion = {
  --       completeopt = "menu,menuone,noinsert,noselect",
  --     }
  --     opts.preselect = cmp.PreselectMode.None
  --     opts.mapping = vim.tbl_extend("force", opts.mapping, {
  --       ["<CR>"] = cmp.mapping.confirm({ select = false }),
  --     })
  --     opts.experimental.ghost_text = false
  --   end,
  --   keys = {
  --     {
  --       "<tab>",
  --       false,
  --       expr = true,
  --       silent = true,
  --       mode = "i",
  --     },
  --     { "<tab>", false, mode = "s" },
  --     { "<s-tab>", false, mode = { "i", "s" } },
  --   },
  -- },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_filetypes = {
        markdown = true,
      }
    end,
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["/"] = "noop",
        },
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      open_mapping = "<C-t>",
      direction = "float",
    },
  },
  {
    "lervag/vimtex",
    opts = function()
      vim.g.vimtex_view_method = "skim"
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              target = "wasm32-unknown-unknown",
            },
          },
        },
      },
    },
  },

  { "andymass/vim-matchup" },

  {
    "kawre/leetcode.nvim",
    opts = {
      lang = "python3",
    },
  },

  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       -- javascript = { "prettier" },
  --       -- typescript = { "prettier" },
  --     },
  --   },
  -- },
  -- { "folke/persistence.nvim", false },
}
