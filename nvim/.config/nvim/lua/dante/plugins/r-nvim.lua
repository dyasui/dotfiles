return {
  "R-nvim/R.nvim",
  version = "~0.1.0",
  config = function()
    vim.g.R_app = "~/Library/Python/3.9/bin/radian"
    vim.g.R_cmd = "R"
    vim.g.R_external_term = "kitty"
    vim.g.R_editing_mode = "vi"
    vim.g.pdfviewer = "skim"
  end,
}
