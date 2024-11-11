vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- escape insert mode w/ jk
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode w/ jk" })
-- leader for common functions
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save buffer"})
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close buffer"})

keymap.set("n", "<ESC>", "<cmd>nohl<CR>", { desc = "clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "-", "<C-x>", { desc = "Decrement number" })

-- align after scrolling up/down
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

-- window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split (w)indow (v)ertically" })
keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split (w)indow (h)orizonally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })

-- buffer navigation
keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
keymap.set("n", "<leader>bi", "<cmd>ls<CR>", { desc = "List buffers interactively" })
keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- tab navigation
keymap.set("n", "<leader><Tab>", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader><Tab>d", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<Tab>", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<S-Tab>", "<cmd>tabp<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tn", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Better window navigation
keymap.set("n", "<leader>h", "<C-w>h", { desc = "window left" })
keymap.set("n", "<leader>j", "<C-w>j", { desc = "window down" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "window up" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "window right" })

-- Easy align columns of text
keymap.set("n", "ga", "<Plug>(EasyAlign)")

-- Exit terminal mode with ESC 
keymap.set("t", "<C-ESC>", "<C-\\><C-n>", { desc = "exit terminal" })

-- toggle zen mode
keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", {desc = "(z)en mode"})

-- tree view
keymap.set("n", "<leader>te", "<cmd>NvimTreeToggle<CR>", { desc = "(t)oggle file (e)xplorer" }) -- toggle file explorer

-- auto sessions
keymap.set("n", "<leader>r", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory

-- fzf 
keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "(f)ind (f)iles" }) -- open fzf
keymap.set("n", "<leader>fh", "<cmd>FzfLua files cwd=~<CR>", { desc = "(f)ind in (h)ome"}) -- open fzf
keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", { desc = "(f)ind (r)ecent" }) 
keymap.set("n", "<leader>fs", "<cmd>FzfLua live_grep<CR>", { desc = "(f)ind (s)tring" }) 

-- terminal
keymap.set("n", "<leader>tt", "<cmd>FloatermToggle<CR>", { desc = "(t)oggle (t)erminal" })

-- w3m browser
keymap.set("n", "<leader>e", "<cmd>W3m ", { desc = "(e)xplore web" })
keymap.set("n", "<leader>et", "<cmd>W3mTab ", { desc = "(e)xplore in new (t)ab" })
keymap.set("n", "<leader>es", "<cmd>W3mSplit ", { desc = "(e)xplore (s)plit" })
keymap.set("n", "<leader>ev", "<cmd>W3mVsplit ", { desc = "(e)xplore (v)split" })
keymap.set("n", "<leader>ey", "<cmd>W3mCopyUrl", { desc = "copy url from w3m" })
keymap.set("n", "<leader>er", "<cmd>W3mReload", { desc = "(r)eload W3m page" })
keymap.set("n", "<leader>eh", "<cmd>W3mHistory", { desc = "w3m (h)istory" })
keymap.set("n", "<leader>ec", "<cmd>W3mHistory", { desc = "w3m (h)istory (c)lear" })
