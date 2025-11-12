return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    window = {
      mappings = {
        -- Copy relative path to clipboard (Y already copies absolute path)
        ["y"] = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local cwd = vim.fn.getcwd()
          local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
          vim.fn.setreg("+", relative_path)
          vim.notify("Copied relative path: " .. relative_path)
        end,
      },
    },
    filesystem = {
      filtered_items = {
        visible = false, -- Hidden files are hidden by default
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_by_name = {
          -- Add files/folders you want to always hide
          ".git",
          ".DS_Store",
          "thumbs.db",
        },
        never_show = {
          -- Files that should never be shown
          ".DS_Store",
          "thumbs.db",
        },
        always_show = {
          -- Hidden files/folders you want to always show
          ".cgbr",
          ".gitignore",
          ".env.example",
          ".github",
        },
      },
    },
  },
}
