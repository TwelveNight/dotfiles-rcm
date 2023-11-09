local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.editor.leap" }, -- best jump with f/t

    -- { import = "lazyvim.plugins.extras.editor.mini-files" }, -- floating file explorer
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" }, -- jump animate
    -- { import = "lazyvim.plugins.extras.util.mini-hipatterns" }, --highlight patterns in text

    -- { import = "lazyvim.plugins.extras.util.project" }, --find project
    -- { import = "lazyvim.plugins.extras.test.core" }, -- test
    -- { import = "lazyvim.plugins.extras.coding.copilot" }, --AI

    -- { import = "lazyvim.plugins.extras.vscode" },

    -- { import = "lazyvim.plugins.extras.dap.core" }, -- debug
    -- { import = "lazyvim.plugins.extras.dap.nlua" },

    -- { import = "lazyvim.plugins.extras.formatting.prettier" }, -- js
    -- { import = "lazyvim.plugins.extras.linting.eslint" },
    -- { import = "lazyvim.plugins.extras.lang.tailwind" }, -- css
    -- { import = "lazyvim.plugins.extras.lang.typescript" }, -- ts
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.lang.go" },
    -- { import = "lazyvim.plugins.extras.lang.python" },
    -- { import = "lazyvim.plugins.extras.lang.clangd" },
    -- { import = "lazyvim.plugins.extras.lang.docker" },

    --
    -- { import = "lazyvim.plugins.extras.ui.edgy" -

    -- import/override with your plugins
    { import = "plugins" },
    { import = "plugins/scheme" },
    -- { import = "plugins/code" },
    { import = "plugins/code/completion" },
    { import = "plugins/code/lsp" },
    { import = "plugins/code/lang/go" },
    { import = "plugins/code/lang/front-end" },
    { import = "plugins/code/lang/cpp" },
    { import = "plugins/code/chore" },
    { import = "plugins/code/cmp" },
    { import = "plugins/git" },
    { import = "plugins/override" },
    { import = "plugins/override/telescope" },
    { import = "plugins/chore" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
