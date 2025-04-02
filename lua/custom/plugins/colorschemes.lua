return {
  { 'ellisonleao/gruvbox.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'catppuccin/nvim' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'marko-cerovac/material.nvim' },
  { 'navarasu/onedark.nvim' },
  { 'projekt0n/github-nvim-theme' },
  { 'sainnhe/gruvbox-material' },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd 'colorscheme carbonfox'
    end,
  },
  { 'tiagovla/tokyodark.nvim' },
  { 'rose-pine/neovim' },
  { 'shaunsingh/nord.nvim' },
  { 'olimorris/onedarkpro.nvim' },
  { 'sainnhe/sonokai' },
  {
    '2giosangmitom/nightfall.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
