return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Configure linters for markdown files
      linters_by_ft = {
        markdown = { "markdownlint" },
      },
    },
  },
}
