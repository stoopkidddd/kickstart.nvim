return {
  'ggml-org/llama.vim',
  enabled = true,
  init = function()
    vim.g.llama_config = {
      show_info = 0,
    }
  end,
}
