return {
  "chipsenkbeil/org-roam.nvim",
  tag = "0.1.0",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      "nvim-orgmode/orgmode",
      tag = "0.3.4",
    },
  },
  config = function()
    require("org-roam").setup({
      directory = "~/orgfiles",
    })
  end
}
