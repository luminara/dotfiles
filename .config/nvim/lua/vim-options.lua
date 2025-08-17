vim.opt.backup = true
vim.opt.swapfile = true
vim.opt.writebackup = true
vim.opt.backupext = ".bak"
vim.opt.backupdir = vim.fn.expand("~/.cache/nvim/backup")
vim.opt.directory = vim.fn.expand("~/.cache/nvim/swap")

local function is_under_mnt(path)
  return string.match(path, "^/mnt/")
end

vim.cmd([[
  augroup NvimBackupSwapConfig
    autocmd!
    autocmd BufWritePre * lua SetupBackupSwap()
  augroup END
]])

-- Lua function to dynamicly set up the backup and swap paths for files under path /mnt
function SetupBackupSwap()
  local file_path = vim.fn.expand("%:p")
  if is_under_mnt(file_path) then
    local base_dir = vim.fn.fnamemodify(file_path, ":p:h"):match("^(.-/[^/]+/[^/]+)")
    local backup_dir = base_dir .. "/.nvim/backup"
    local swap_dir = base_dir .. "/.nvim/swap"

    -- Create the backup and swap directories if they do not exist
    vim.fn.mkdir(backup_dir, "p")
    vim.fn.mkdir(swap_dir, "p")

    -- Set Neovim options for backup and swap
    vim.opt.backupdir = backup_dir
    vim.opt.directory = swap_dir
  end
end

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set linebreak")
vim.g.mapleader = " "

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { noremap = true, silent = true })
vim.wo.number = true

vim.opt.clipboard = "unnamedplus"

vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>c", "1z=", { noremap = true, silent = true })
