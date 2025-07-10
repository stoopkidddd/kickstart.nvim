return {
  'yetone/avante.nvim',
  enabled = false,
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = 'perplexity',
    vendors = {
      perplexity = {
        __inherited_from = 'openai',
        api_key_name = 'PERPLEXITY_API_KEY',
        endpoint = 'https://api.perplexity.ai',
        model = 'sonar-reasoning-pro',
      },
      openrouter = {
        __inherited_from = 'openai',
        endpoint = 'https://openrouter.ai/api/v1',
        api_key_name = 'OPENROUTER_API_KEY',
        model = 'google/gemini-2.5-pro-preview-03-25',
      },
    },
    -- rag_service = {
    --   enabled = true,
    --   host_mount = os.getenv 'HOME', -- Host mount path for the rag service
    --   provider = 'ollama', -- The provider to use for RAG service (e.g. openai or ollama)
    --   llm_model = '', -- The LLM model to use for RAG service
    --   embed_model = '', -- The embedding model to use for RAG service
    --   endpoint = 'https://api.openai.com/v1', -- The API endpoint for RAG service
    -- },
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    -- 'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
