---@type function?, function?
local icon_provider, hl_provider

local function get_kind_icon(CTX)
  -- Evaluate icon provider
  if not icon_provider then
    local _, mini_icons = pcall(require, 'mini.icons')
    if _G.MiniIcons then
      icon_provider = function(ctx)
        local is_specific_color = ctx.kind_hl and ctx.kind_hl:match '^HexColor' ~= nil
        if ctx.item.source_name == 'LSP' then
          local icon, hl = mini_icons.get('lsp', ctx.kind or '')
          if icon then
            ctx.kind_icon = icon
            if not is_specific_color then
              ctx.kind_hl = hl
            end
          end
        elseif ctx.item.source_name == 'Path' then
          ctx.kind_icon, ctx.kind_hl = mini_icons.get(ctx.kind == 'Folder' and 'directory' or 'file', ctx.label)
        end
      end
    end
    if not icon_provider then
      local lspkind_avail, lspkind = pcall(require, 'lspkind')
      if lspkind_avail then
        icon_provider = function(ctx)
          if ctx.item.source_name == 'LSP' then
            local icon = lspkind.symbolic(ctx.kind, { mode = 'symbol' })
            if icon then
              ctx.kind_icon = icon
            end
          end
        end
      end
    end
    if not icon_provider then
      icon_provider = function() end
    end
  end
  -- Evaluate highlight provider
  if not hl_provider then
    local highlight_colors_avail, highlight_colors = pcall(require, 'nvim-highlight-colors')
    if highlight_colors_avail then
      local kinds
      hl_provider = function(ctx)
        if not kinds then
          kinds = require('blink.cmp.types').CompletionItemKind
        end
        if ctx.item.kind == kinds.Color then
          local doc = vim.tbl_get(ctx, 'item', 'documentation')
          if doc then
            local color_item = highlight_colors_avail and highlight_colors.format(doc, { kind = kinds[kinds.Color] })
            if color_item and color_item.abbr_hl_group then
              if color_item.abbr then
                ctx.kind_icon = color_item.abbr
              end
              ctx.kind_hl = color_item.abbr_hl_group
            end
          end
        end
      end
    end
    if not hl_provider then
      hl_provider = function() end
    end
  end
  -- Call resolved providers
  icon_provider(CTX)
  hl_provider(CTX)
  -- Return text and highlight information
  return { text = CTX.kind_icon .. CTX.icon_gap, highlight = CTX.kind_hl }
end

return {
  'Saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '^1',
  opts_extend = { 'sources.default', 'cmdline.sources', 'term.sources' },
  opts = {
    -- remember to enable your providers here
    sources = {
      default = { 'lsp', 'path', 'buffer' },
      per_filetype = {
        codecompanion = { 'codecompanion' },
      },
    },
    keymap = {
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-N>'] = { 'select_next', 'show' },
      ['<C-P>'] = { 'select_prev', 'show' },
      ['<C-J>'] = { 'select_next', 'fallback' },
      ['<C-K>'] = { 'select_prev', 'fallback' },
      ['<C-U>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-D>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        'snippet_forward',
        'fallback',
      },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
      trigger = { show_on_insert_on_trigger_character = true, show_on_keyword = true },
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= 'cmdline'
        end,
        border = 'rounded',
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
        draw = {
          -- We don't need label_description now because label and label_description are already
          -- combined together in label by colorful-menu.nvim.
          columns = { { 'kind_icon' }, { 'label', gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require('colorful-menu').blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require('colorful-menu').blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
      accept = {
        auto_brackets = { enabled = true },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = {
          border = 'rounded',
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
        },
      },
      ghost_text = { enabled = true },
    },
    signature = {
      window = {
        border = 'rounded',
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
      },
    },
  },
  specs = {
    {
      'folke/lazydev.nvim',
      optional = true,
      specs = {
        {
          'Saghen/blink.cmp',
          opts = function(_, opts)
            if pcall(require, 'lazydev.integrations.blink') then
              return vim.tbl_deep_extend('force', opts, {
                sources = {
                  -- add lazydev to your completion providers
                  default = { 'lazydev' },
                  providers = {
                    lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
                  },
                },
              })
            end
          end,
        },
      },
    },
    {
      'catppuccin',
      optional = true,
      ---@type CatppuccinOptions
      opts = { integrations = { blink_cmp = true } },
    },
    -- disable built in completion plugins
    { 'hrsh7th/nvim-cmp', enabled = false },
    { 'rcarriga/cmp-dap', enabled = false },
  },
}
