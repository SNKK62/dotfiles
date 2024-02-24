local status, saga = pcall(require, "lspsaga")
if (not status) then return end

saga.setup{
  ui = {
    -- currently only round theme
    theme = 'round',
    -- this option only work in neovim 0.9
    title = false,
    -- border type can be single,double,rounded,solid,shadow.
    border = 'rounded',
    winblend = 6,
    expand = '',
    collapse = '',
    preview = ' ',
    code_action = '💡',
    diagnostic = '',
    incoming = ' ',
    outgoing = ' ',
    colors = {
      --float window normal background color normal_bg = '#232136',
    },
    kind = {},
  },

  preview = {
    lines_above = 1,
    lines_below = 10,
  },
  scroll_preview = {
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
  },
  request_timeout = 2000,

  finder = {
    keys = {
      toggle_or_open = { 'o', '<CR>' },
      vsplit = 'v',
      split = 's',
      tabe = 't',
      quit = { 'q', '<ESC>' },
    },
    methods = {
      tyd = 'textDocument/typeDefinition',
    },
    default = 'ref+imp+def',
  },

  code_action = {
    num_shortcut = true,
    show_server_name = true,
    extend_gitsigns = true,
  },
  -- disable all lightbulb
  lightbulb = {
    enable = false,
    enable_in_insert = false,
    sign = false,
    sign_priority = 40,
    virtual_text = false,
  },

  diagnostic = {
    show_code_action = true,
    show_source = true,
    jump_num_shortcut = true,
    keys = {
      exec_action = 'o',
      quit = 'q',
      go_action = 'g'
    },
  },

  definition = {
    keys = {
      edit = '<C-c>o',
      vsplit = '<C-c>v',
      split = '<C-c>s',
      tabe = '<C-c>t',
      quit = 'q',
      close = '<C-c>q',
    },
  },

  outline = {
    layout = "float"
  },
  -- disable winbar's symbols
  -- symbol_in_winbar = {
  --   enable = false,
  --   separator = ' ',
  --   hide_keyword = true,
  --   show_file = true,
  --   folder_level = 2,
  --   respect_root = false,
  --   color_mode = true,
  -- },
}

