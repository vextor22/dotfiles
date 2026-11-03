-- =======================
-- 1. Leader Key
-- =======================
vim.g.mapleader = ","
vim.g.maplocalleader = ","


-- Bootstrap lazy.nvim automatically if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- CRITICAL for Neovim 0.10.4!
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c","cpp", "lua", "vim", "vimdoc", "query" },
        highlight = { enable = true },
      })
    end,
  },
  {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    -- put your config here
  end,
},
  {
    "ibhagwan/fzf-lua",
    config = function()
      local fzf = require("fzf-lua")
      fzf.setup({})
      vim.keymap.set("n", "<Leader>ff", fzf.files, { desc = "Find files" })
      vim.keymap.set("n", "<Leader>fb", fzf.buffers, { desc = "Find open buffers" })
      vim.keymap.set("n", "<Leader>fg", fzf.live_grep, { desc = "Live grep project" })
      vim.keymap.set("n", "<Leader>fs", fzf.lsp_document_symbols, { desc = "Find LSP symbols" })
    end,
  },
},{
  performance = {
    rtp = { reset = false }, -- Stop lazy.nvim from deleting Debian's /usr/lib parser path!
  },
} )

-- clear highlighting with ,<space>
vim.keymap.set("n", "<leader> ", "<cmd>nohlsearch<CR>", {desc = "Clear search highlight"})

-- =======================
-- 2. Line numbers, cursor, visuals 
-- =======================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.cmd.colorscheme("habamax")

local function set_cursor_underline()
	vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bg = "NONE" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true, fg = "#fabd2f" })
end

set_cursor_underline()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_cursor_underline,
})

-- ============================================================================
-- 3. TABS & INDENTATION
-- ============================================================================
vim.opt.tabstop = 2        -- Visual width of a <Tab> character
vim.opt.shiftwidth = 2     -- Number of spaces used for each step of auto-indent
vim.opt.softtabstop = 2    -- Number of spaces <Tab> / <BS> counts for while editing
vim.opt.expandtab = true   -- Convert tabs to spaces (note: Makefiles still use real tabs)
vim.opt.smartindent = true -- Smart auto-indenting on new lines for C-like languages

-- ============================================================================
-- 4. THE "STUFF YOU'RE PROBABLY FORGETTING" (Essential QoL Settings)
-- ============================================================================
-- Prevent text from jumping left/right when clangd warnings/errors appear in the gutter
vim.opt.signcolumn = "yes"

-- Keep 8 lines of context visible above/below the cursor when scrolling
vim.opt.scrolloff = 8

-- Case-insensitive search UNLESS you type a capital letter
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Persistent undo: keeps your undo history across sessions even after closing the file
vim.opt.undofile = true

-- Intuitive window splitting (open new splits to the right and bottom)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sync yanks/pastes with your system clipboard (optional—comment out if you prefer registers separate)
vim.opt.clipboard = "unnamedplus"

-- Faster completion and CursorHold trigger time (default is 4000ms)
vim.opt.updatetime = 250


-- ============================================================================
-- 5. NATIVE C INTELLISENSE (Works on Neovim 0.8, 0.9, 0.10, and 0.11+)
-- ============================================================================
-- Built-in :Man plugin is enabled by default in Neovim, so pressing K on non-LSP buffers
-- or running :Man 3 malloc opens formatted man pages in a split.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp" },
  callback = function(args)
    -- Find project root via compile_commands.json or .git, fallback to file's directory
    local root_file = vim.fs.find(
      { "compile_commands.json", ".clangd", ".git" },
      { upward = true, path = vim.fs.dirname(args.file) }
    )[1]
    local root_dir = root_file and vim.fs.dirname(root_file) or vim.fs.dirname(args.file)

    vim.lsp.start({
      name = "clangd",
      cmd = { "clangd", "--background-index", "--clang-tidy" },
      root_dir = root_dir,
    })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)       -- Jump to definition
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)      -- Jump to header declaration
    vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)            -- Hover signature & docs
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)       -- List all references
    vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)   -- Rename symbol across project
    vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float, opts) -- Show compiler error popup
    vim.keymap.set("i", "<C-Space>", vim.lsp.buf.completion, opts)    -- Trigger autocomplete
  end,
})

-- ==========================
-- 6. Nav helpers
-- ==========================
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)"})
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)"})

-- Auto-equalize split sizes when resize terminal
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
})
-- Disable blinking cursor
vim.opt.guicursor = "a:blinkon0"

-- Highlight matching brackets when typing 
vim.opt.showmatch = true

-- close quickfix with <leader>a
vim.keymap.set("n", "<Leader>a", "<cmd>cclose<CR>", { desc = "Close quickfix list" })
