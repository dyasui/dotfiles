vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- escape insert mode w/ jk
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode w/ jk" })
-- leader for common functions
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save buffer"})
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close buffer"})

-- open file explorer
-- keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "open file explorer" })

keymap.set("n", "<ESC>", ":nohl<CR>", { desc = "clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- align after scrolling up/down
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- -- window management
-- keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
-- keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window horizonally" })
-- keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
-- keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "close split" })

-- buffer navigation
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>bi", "<cmd>ls<CR>", { desc = "List buffers interactively" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- tab navigation
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<Tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<BS>", "<cmd>tabp<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tn", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Better window navigation
keymap.set("n", "<leader>h", "<C-w>h", { desc = "window left" })
keymap.set("n", "<leader>j", "<C-w>j", { desc = "window down" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "window up" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "window right" })

-- Easy align columns of text
keymap.set("n", "ga", "<Plug>(EasyAlign)")

-- Exit terminal mode with ESC 
keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "exit terminal" })
