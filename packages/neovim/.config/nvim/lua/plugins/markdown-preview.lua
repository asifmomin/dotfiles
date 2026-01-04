return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "cd app && npx --yes yarn install",
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview", ft = "markdown" },
    { "<leader>mt", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle", ft = "markdown" },
  },
  config = function()
    -- Don't auto-close preview when switching buffers
    vim.g.mkdp_auto_close = 0

    -- Optional: only refresh on save (not on every change)
    -- vim.g.mkdp_refresh_slow = 1
  end,
}
