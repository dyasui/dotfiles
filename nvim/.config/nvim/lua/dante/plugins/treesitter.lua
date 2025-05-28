return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate", -- treesitter update
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- import nvim-treesitter plugins
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({
      highlight = {
        enable = true,
        disable = { "latex" , "norg" },
        additional_vim_regex_highlighting = { "markdown" },
      },
      indent = { enable = true },
      autotag = { enable= true },
      --ensure these language parsers are installed
      ensure_installed = {
        "bash",
        -- "bibtex",
        "c",
        "css",
        "csv",
        "julia",
        "lua",
        "markdown_inline",
        -- "norg",
        "r",
        "vim",
        "vimdoc",
      },
      ignore_installed = { 'org' }
    })

  end,
}
