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
g.mapleader = [[ ]]              -- Make the spacebar the leader key
o.number = true                  -- Line numbers are good
o.backspace = "indent,eol,start" -- Allow backspace in insert mode
o.history = 1000                 -- Store lots of :cmdline history
o.showcmd = true                 -- Show incomplete cmds down the bottom
o.autoread = true                -- Reload files changed outside vim
o.ttimeout = true                -- https://vi.stackexchange.com/a/20220
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
o.showtabline = 0 -- Going tabless

-- Create a command named 'Vimrc' that will open the .vimrc file
cmd("command! Vimrc :e $HOME/.config/nvim/init.lua")

-- Bink yanked text
cmd([[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua require("vim.highlight").on_yank({higroup = "Search", timeout = 200})
  augroup END
]])

vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
  pattern = { "*.*" },
  desc = "save view (folds), when closing file",
  command = "mkview",
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*.*" },
  desc = "load view (folds), when opening file",
  command = "silent! loadview",
})

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

function _G.tex_compile()
  local Job = require("plenary.job")

  Job:new({
    command = "tectonic",
    args = { "--keep-intermediates", "main.tex" },
  }):start()
end

cmd([[
augroup tex_compile
    autocmd!
    autocmd BufWritePost,FileWritePost	main.tex lua tex_compile()
augroup END
]])

-- https://github.com/szebniok/tree-sitter-wgsl
vim.filetype.add({ extension = { wgsl = "wgsl" } })

-- https://github.com/neovim/nvim-lspconfig/issues/69#issuecomment-1877781941
-- do
--   local method = "textDocument/publishDiagnostics"
--   local default_handler = vim.lsp.handlers[method]
--
--   vim.lsp.handlers[method] = function(err, result, ctx, config)
--     default_handler(err, result, ctx, config)
--
--     if result and result.diagnostics then
--       for _, v in ipairs(result.diagnostics) do
--         v.bufnr = ctx.bufnr
--         v.lnum = v.range.start.line + 1
--         v.col = v.range.start.character + 1
--         v.text = v.message
--       end
--
--       local qflist = vim.fn.getqflist({ title = 0, id = 0 })
--
--       vim.fn.setqflist({}, qflist.title == "LSP Workspace Diagnostics" and "r" or " ", {
--         title = "LSP Workspace Diagnostics",
--         items = vim.diagnostic.toqflist(result.diagnostics),
--       })
--
--       -- don't steal focus from other qf lists
--       if qflist.id ~= 0 and qflist.title ~= "LSP Workspace Diagnostics" then
--         vim.cmd("colder")
--       end
--     end
--   end
-- end

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
map("n", "<leader>k", "<cmd>Telescope lsp_document_symbols<CR>", "silent")
map("n", "<leader>K", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "silent")

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
-- map("n", "gR", "<cmd>TroubeToggle lsp_references<cr>", "silent")
-- --
-- map("n", "<C-\\>", "<cmd>lua require('trouble').next({skip_groups = true, jump = true});<CR>zz", "silent")
-- map("n", "<C-]>", "<cmd>lua require('trouble').previous({skip_groups = true, jump = true});<CR>zz", "silent")

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

-- Yeet from clipboard
map("nv", "<C-p>", '"+p')

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

-- Quickfix baby (is in trouble)
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
-- map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", "silent")
-- map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", "silent")
-- map("n", ">b", "<cmd>BufferLineMoveNext<cr>", "silent")
-- map("n", "<b", "<cmd>BufferLineMovePrev<cr>", "silent")

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

-- Just a command to open my snippets
cmd("command! Snip :Telescope find_files cwd=$HOME/.config/nvim/snippets")

-- Going zen mode
map("n", "<leader>z", "<cmd>ZenMode<cr>", "silent")

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

map("n", "<space>fb", ":Telescope file_browser<CR>")

-- Harpoonin
map("n", "<leader>e", "<cmd>lua require('harpoon.mark').add_file()<CR>", "silent")
map("n", "<leader>E", "<cmd>lua require('harpoon.mark').rm_file()<CR>", "silent")
map("n", "<leader>n", "<cmd>Telescope harpoon marks<CR>", "silent")
map("n", "<leader>N", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "silent")
map("n", "<leader>o", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", "silent")
map("n", "<leader>i", "<cmd>lua require('harpoon.ui').nav_next()<CR>", "silent")

------------------ Plugins -------------------- {{{1
require("lazy").setup({
  -- Core
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },
  {
    "stevearc/dressing.nvim",
  },

  -- Visuals
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      cmd.colorscheme("catppuccin")
      require("catppuccin").setup({
        integrations = {
          fidget = true,
          harpoon = true,
          cmp = true,
          gitsigns = true,
          treesitter = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = true,
          },
          mason = true,
          neotree = true,
          telescope = {
            enabled = true,
          },
          lsp_trouble = true,
          which_key = true,
        },
      })
    end,
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({})
    end,
  },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  {
    "rebelot/heirline.nvim",
    event = "UiEnter",
    config = function()
      require("statusbar")
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {},
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = function()
      require("fidget").setup({
        window = {
          blend = 0,
        },
      })
    end,
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          -- you may turn on/off statusline in zen mode by setting 'laststatus'
          -- statusline will be shown only if 'laststatus' == 3
          laststatus = 3,
        },
        alacritty = {
          enabled = false,
          font = "14", -- font size
        },
      },
    },
  },

  -- Navigation
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-project.nvim", "nvim-telescope/telescope-file-browser.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = { ["<c-s>"] = require("trouble").open_with_trouble },
            n = { ["<c-s>"] = require("trouble").open_with_trouble },
          },
        },
      })
      telescope.load_extension("projects")
      telescope.load_extension("file_browser")
      telescope.load_extension("harpoon")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
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
  "famiu/bufdelete.nvim",
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup({})
    end,
  },
  "ThePrimeagen/harpoon",

  -- LSP
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    lazy = true,
    config = false,
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    config = true,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "onsails/lspkind-nvim",
      "dcampos/nvim-snippy",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "dcampos/cmp-snippy",
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_cmp()

      local snippy = require("snippy")
      snippy.setup({})

      local cmp = require("cmp")
      local types = require("cmp.types")

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        sources = {
          { name = "path" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "snippy" },
          { name = "buffer" },
          { name = "nvim_lsp_signature_help" },
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
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = require("lspkind").cmp_format({
            mode = "symbol", -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          }),
        },
        snippet = {
          expand = function(args)
            snippy.expand_snippet(args.body)
          end,
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lsp_zero = require("lsp-zero")
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
      end)

      require("mason").setup({})
      require("mason-lspconfig").setup({
        -- Replace the language servers listed here
        -- with the ones you want to install
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
          end,
        },
      })

      lsp_zero.set_sign_icons({
        error = "",
        warn = "",
        hint = "",
        info = "",
      })

      -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/lsp.md#configure-diagnostics
      -- vim.diagnostic.config({
      -- 	virtual_text = true,
      -- 	signs = true,
      -- 	update_in_insert = false,
      -- 	underline = true,
      -- 	severity_sort = false,
      -- 	float = true,
      -- })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = { "jay-babu/mason-null-ls.nvim" },
    config = function()
      local null_ls = require("null-ls")

      local autoformat = true

      vim.api.nvim_create_user_command("AutoFormatToggle", function()
        autoformat = not autoformat
      end, { desc = "Toggle format on save" })

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      null_ls.setup({
        -- debug = true,
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                if autoformat then
                  vim.lsp.buf.format({ async = false })
                end
              end,
            })
          end
        end,
        sources = {
          -- null_ls.builtins.formatting.rustfmt.with({
          -- 	extra_args = { "--edition=2021" },
          -- }),
          -- null_ls.builtins.formatting.zigfmt,
          null_ls.builtins.formatting.prettierd.with({
            extra_filetypes = { "svelte" },
          }),
          null_ls.builtins.formatting.rustywind.with({
            extra_filetypes = { "svelte" },
          }),
        },
      })

      -- See mason-null-ls.nvim's documentation for more details:
      -- https://github.com/jay-babu/mason-null-ls.nvim#setup
      require("mason-null-ls").setup({
        ensure_installed = {
          -- Opt to list sources here, when available in mason.
        },
        automatic_installation = false,
        handlers = {},
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
    "echasnovski/mini.comment",
    version = "*",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("ts_context_commentstring").setup({})
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring.internal").calculate_commentstring()
                or vim.bo.commentstring
          end,
        },
      })
    end,
  },

  -- Editor
  "tpope/vim-fugitive",
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
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
        highlight = { enable = true },
        indent = { enable = true },
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
  {
    "echasnovski/mini.bracketed",
    version = "*",
    config = function()
      require("mini.bracketed").setup()
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_filetypes = {
        markdown = true,
      }
    end,
  },
  -- {
  --   "OscarCreator/rsync.nvim",
  --   build = "rm Cargo.lock && make",
  --   config = function()
  --     require("rsync").setup()
  --   end,
  -- },

  -- Languages
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      -- vim.g.vimtex_view_method = "zathura"
      -- vim.g.vimtex_quickfix_enabled = 0
      -- vim.g.vimtex_view_skim_sync = 1
      -- vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_quickfix_enabled = 0
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
    end,
  },
})
