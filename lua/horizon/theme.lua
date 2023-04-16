local c = require('horizon.palette')

---@class horizon.Opts
---@field fg string
---@field bg string
---@field sp string
---@field bold boolean
---@field italic boolean
---@field underline boolean
---@field undercurl boolean
---@field reverse boolean
---@field standout boolean
---@field link string

---@alias horizon.HighlightDef {[string]: horizon.Opts}
---@alias Theme 'light' | 'dark'

local api = vim.api

local M = {}

---@param theme horizon.HighlightDef
local function get_lsp_kind_highlights(theme)
  return {
    -- LSP Kind Items
    ['module'] = { fg = c.yelloworange },
    ['snippet'] = { fg = c.purple },
    ['folder'] = { fg = theme.fg },
    ['color'] = { fg = theme.fg },
    ['file'] = { link = 'Directory' },
    ['text'] = { link = '@string' },
    ['method'] = { link = '@method' },
    ['function'] = { link = '@function' },
    ['constructor'] = { link = '@constructor' },
    ['field'] = { link = '@field' },
    ['variable'] = { link = '@variable' },
    ['property'] = { link = '@property' },
    ['unit'] = { link = '@constant' },
    ['value'] = { link = '@variable' },
    ['enum'] = { link = '@type' },
    ['keyword'] = { link = '@keyword' },
    ['reference'] = { link = '@parameter.reference' },
    ['constant'] = { link = '@constant' },
    ['struct'] = { link = '@structure' },
    ['event'] = { link = '@variable' },
    ['operator'] = { link = '@operator' },
    ['namespace'] = { link = '@namespace' },
    ['package'] = { link = '@include' },
    ['string'] = { link = '@string' },
    ['number'] = { link = '@number' },
    ['boolean'] = { link = '@boolean' },
    ['array'] = { link = '@repeat' },
    ['object'] = { link = '@type' },
    ['key'] = { link = '@field' },
    ['null'] = { link = '@symbol' },
    ['enumMember'] = { link = '@field' },
    ['class'] = { link = '@lsp.type.class' },
    ['interface'] = { link = '@lsp.type.interface' },
    ['typeParameter'] = { link = '@lsp.type.parameter' },
  }
end

---@param bg Theme
---@return horizon.HighlightDef
local function get_highlights(bg)
  ---@module 'horizon.palette-dark'
  local theme = require(('horizon.palette-%s'):format(bg))
  return {
    -- Editor
    ['Normal'] = { fg = theme.fg, bg = theme.bg },
    ['NormalNC'] = { fg = theme.fg, bg = theme.bg },
    ['SignColumn'] = {},
    ['MsgArea'] = { fg = theme.fg, bg = theme.bg },
    ['ModeMsg'] = { fg = theme.fg, bg = c.alt_bg },
    ['MsgSeparator'] = { fg = theme.winseparator_fg, bg = theme.bg },
    ['SpellBad'] = { sp = c.red, undercurl = true },
    ['SpellCap'] = { sp = c.yellow, undercurl = true },
    ['SpellLocal'] = { sp = c.yelloworange, underline = true },
    ['SpellRare'] = { sp = c.purple, underline = true },
    ['Pmenu'] = { fg = theme.fg, bg = theme.pmenu_bg },
    ['PmenuSel'] = { bg = c.ui2_blue },
    ['PmenuSbar'] = { bg = theme.pmenu_thumb_bg },
    ['PmenuThumb'] = { bg = theme.pmenu_thumb_fg },
    ['WildMenu'] = { fg = theme.fg, bg = c.ui2_blue },
    ['CursorLineNr'] = { fg = theme.active_line_number_fg, bold = true },
    ['Folded'] = { fg = c.gray, bg = c.alt_bg },
    ['FoldColumn'] = { fg = c.gray, bg = c.alt_bg },
    ['LineNr'] = { fg = theme.inactive_line_number_fg },
    ['NormalFloat'] = { bg = theme.float_bg },
    ['FloatBorder'] = { fg = theme.float_border, bg = theme.float_bg },
    ['Whitespace'] = { fg = c.pale_grey },
    ['VertSplit'] = { fg = theme.winseparator_fg, bg = theme.bg },
    ['CursorLine'] = { bg = theme.cursorline_bg },
    ['CursorColumn'] = { bg = c.alt_bg },
    ['ColorColumn'] = { bg = c.alt_bg },
    ['Visual'] = { bg = c.ui_blue },
    ['VisualNOS'] = { bg = c.alt_bg },
    ['WarningMsg'] = { fg = c.error, bg = theme.bg },
    ['DiffAdd'] = { bg = theme.diff_added_bg },
    ['DiffDelete'] = { bg = theme.diff_deleted_bg },
    ['DiffChange'] = { bg = c.diff_change },
    ['DiffText'] = { bg = c.diff_text },
    ['QuickFixLine'] = { bg = c.ui2_blue },
    ['MatchParen'] = { fg = theme.match_paren, underline = true },
    ['Cursor'] = { fg = theme.cursor_fg, bg = theme.cursor_bg },
    ['lCursor'] = { fg = theme.cursor_fg, bg = theme.cursor_bg },
    ['CursorIM'] = { fg = theme.cursor_fg, bg = theme.cursor_bg },
    ['TermCursor'] = { fg = theme.term_cursor_fg, bg = theme.term_cursor_bg },
    ['TermCursorNC'] = { fg = theme.term_cursor_fg, bg = theme.term_cursor_bg },
    ['Conceal'] = { fg = c.gray },
    ['Directory'] = { fg = c.blue },
    ['SpecialKey'] = { fg = c.red, bold = true },
    ['ErrorMsg'] = { fg = c.error, bg = theme.bg, bold = true },
    ['Search'] = { bg = c.ui2_blue },
    ['IncSearch'] = { bg = c.ui2_blue },
    ['Substitute'] = { bg = c.ui2_blue },
    ['MoreMsg'] = { fg = c.orange },
    ['Question'] = { fg = c.orange },
    ['EndOfBuffer'] = { fg = theme.bg },
    ['NonText'] = { fg = theme.bg },
    ['TabLine'] = { fg = c.light_gray, bg = c.alt_bg },
    ['TabLineSel'] = { fg = theme.fg, bg = c.alt_bg },
    ['TabLineFill'] = { fg = c.alt_bg, bg = c.alt_bg },

    -- Code
    ['Comment'] = theme.comment,
    ['Variable'] = { fg = c.red },
    ['String'] = theme.string,
    ['Character'] = { fg = c.yelloworange },
    ['Number'] = { fg = c.orange },
    ['Float'] = { fg = c.orange },
    ['Boolean'] = { fg = c.orange },
    ['Constant'] = theme.constant,
    ['Type'] = { fg = c.yellow },
    ['Function'] = theme.func,
    ['Keyword'] = theme.keyword,
    ['Conditional'] = { fg = c.purple },
    ['Repeat'] = { fg = c.purple },
    ['Operator'] = { link = 'Delimiter' },
    ['PreProc'] = { fg = c.purple },
    ['Include'] = { fg = c.purple },
    ['Exception'] = { fg = c.purple },
    ['StorageClass'] = { fg = c.yellow },
    ['Structure'] = { fg = c.yellow },
    ['Typedef'] = { fg = c.purple },
    ['Define'] = { fg = c.purple },
    ['Macro'] = { fg = c.purple },
    ['Debug'] = { fg = c.red },
    ['Title'] = { fg = c.yellow, bold = true },
    ['Label'] = { fg = c.red },
    ['SpecialChar'] = { fg = c.yelloworange },
    ['Delimiter'] = theme.delimiter,
    ['SpecialComment'] = { fg = theme.fg },
    ['Tag'] = { fg = c.red },
    ['Bold'] = { bold = true },
    ['Italic'] = { italic = true },
    ['Underlined'] = { underline = true },
    ['Ignore'] = { fg = c.hint, bold = true },
    ['Todo'] = { fg = c.info, bold = true },
    ['Error'] = { fg = c.error, bold = true },
    ['Statement'] = { fg = c.purple },
    ['Identifier'] = { fg = theme.fg },
    ['PreCondit'] = { fg = c.purple },
    ['Special'] = { fg = c.orange },

    -- Treesitter
    ['@comment'] = { link = 'Comment' },
    ['@variable'] = { link = 'Variable' },
    ['@string'] = { link = 'String' },
    ['@string.regex'] = { link = 'String' },
    ['@string.escape'] = { link = 'String' },
    ['@character'] = { link = 'String' },
    ['@character.special'] = { link = 'SpecialChar' },
    ['@number'] = { link = 'Number' },
    ['@float'] = { link = 'Float' },
    ['@boolean'] = { link = 'Boolean' },
    ['@constant'] = { link = 'Constant' },
    ['@constant.builtin'] = { link = 'Constant' },
    ['@constructor'] = { link = 'Type' },
    ['@type'] = { link = 'Type' },
    ['@include'] = { link = 'Include' },
    ['@exception'] = { link = 'Exception' },
    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.return'] = { link = 'Keyword' },
    ['@keyword.operator'] = { link = 'Keyword' },
    ['@keyword.function'] = { link = 'Keyword' },
    ['@function'] = { link = 'Function' },
    ['@function.builtin'] = { link = 'Function' },
    ['@method'] = { link = 'Function' },
    ['@function.macro'] = { link = 'Function' },
    ['@conditional'] = { link = 'Conditional' },
    ['@repeat'] = { link = 'Repeat' },
    ['@operator'] = { link = 'Operator' },
    ['@preproc'] = { link = 'PreProc' },
    ['@storageclass'] = { link = 'StorageClass' },
    ['@structure'] = { link = 'Structure' },
    ['@type.definition'] = { link = 'Typedef' },
    ['@define'] = { link = 'Define' },
    ['@note'] = { link = 'Comment' },
    ['@none'] = { fg = c.light_gray },
    ['@todo'] = { link = 'Todo' },
    ['@debug'] = { link = 'Debug' },
    ['@danger'] = { link = 'Error' },
    ['@title'] = { link = 'Title' },
    ['@label'] = { link = 'Label' },
    ['@tag.delimiter'] = { fg = c.red },
    ['@punctuation.delimiter'] = { link = 'Delimiter' },
    ['@punctuation.bracket'] = { link = 'Delimiter' },
    ['@punctuation.special'] = { link = 'Delimiter' },
    ['@tag'] = { link = 'Tag' },
    ['@strong'] = { link = 'Bold' },
    ['@emphasis'] = { link = 'Italic' },
    ['@underline'] = { link = 'Underline' },
    ['@strike'] = { strikethrough = true },
    ['@string.special'] = { fg = theme.fg },
    ['@environment.name'] = { fg = c.cyan },
    ['@variable.builtin'] = { fg = c.yellow },
    ['@const.macro'] = { fg = c.orange },
    ['@type.builtin'] = { fg = c.orange },
    ['@annotation'] = { fg = c.cyan },
    ['@namespace'] = { fg = c.cyan },
    ['@symbol'] = { fg = theme.fg },
    ['@field'] = { fg = c.red },
    ['@property'] = { fg = c.red },
    ['@parameter'] = { fg = c.red },
    ['@parameter.reference'] = theme.parameter,
    ['@attribute'] = { fg = c.red },
    ['@text'] = { fg = theme.text_link },
    ['@text.reference'] = { fg = theme.text_link_reference, bold = true },
    ['@tag.attribute'] = { fg = c.orange, italic = true },
    ['@error'] = { fg = theme.error },
    ['@warning'] = { fg = theme.warning },
    ['@query.linter.error'] = { fg = c.error },
    ['@uri'] = { fg = c.cyan, underline = true },
    ['@math'] = { fg = c.yellow },

    -- LspSemanticTokens
    ['@lsp.type.namespace'] = { link = '@namespace' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.struct'] = { link = '@structure' },
    ['@lsp.type.typeParameter'] = { link = 'TypeDef' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.method'] = { link = '@method' },
    ['@lsp.type.macro'] = { link = '@macro' },
    ['@lsp.type.decorator'] = { link = '@function' },
    ['@lsp.typemod.variable.readonly'] = { link = '@constant' },
    ['@lsp.typemod.method.defaultLibrary'] = { link = '@function.builtin' },
    ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
    ['@lsp.typemod.variable.defaultLibrary'] = { link = '@variable.builtin' },
    ['@lsp.mod.deprecated'] = { strikethrough = true },

    -- LSP
    ['DiagnosticHint'] = { fg = c.hint },
    ['DiagnosticInfo'] = { fg = c.info },
    ['DiagnosticWarn'] = { fg = c.warn },
    ['DiagnosticError'] = { fg = c.error },
    ['DiagnosticOther'] = { fg = c.ui_purple },
    ['DiagnosticSignHint'] = { link = 'DiagnosticHint' },
    ['DiagnosticSignInfo'] = { link = 'DiagnosticInfo' },
    ['DiagnosticSignWarn'] = { link = 'DiagnosticWarn' },
    ['DiagnosticSignError'] = { link = 'DiagnosticError' },
    ['DiagnosticSignOther'] = { link = 'DiagnosticOther' },
    ['DiagnosticSignWarning'] = { link = 'DiagnosticWarn' },
    ['DiagnosticFloatingHint'] = { link = 'DiagnosticHint' },
    ['DiagnosticFloatingInfo'] = { link = 'DiagnosticInfo' },
    ['DiagnosticFloatingWarn'] = { link = 'DiagnosticWarn' },
    ['DiagnosticFloatingError'] = { link = 'DiagnosticError' },
    ['DiagnosticUnderlineHint'] = { sp = c.hint, undercurl = true },
    ['DiagnosticUnderlineInfo'] = { sp = c.info, undercurl = true },
    ['DiagnosticUnderlineWarn'] = { sp = c.warn, undercurl = true },
    ['DiagnosticUnderlineError'] = { sp = c.error, undercurl = true },
    ['DiagnosticSignInformation'] = { link = 'DiagnosticInfo' },
    ['DiagnosticVirtualTextHint'] = { fg = c.hint, bg = c.hint_bg },
    ['DiagnosticVirtualTextInfo'] = { fg = c.info, bg = c.info_bg },
    ['DiagnosticVirtualTextWarn'] = { fg = c.warn, bg = c.warn_bg },
    ['DiagnosticVirtualTextError'] = { fg = c.error, bg = c.error_bg },
    ['LspDiagnosticsError'] = { fg = c.error },
    ['LspDiagnosticsWarning'] = { fg = c.warn },
    ['LspDiagnosticsInfo'] = { fg = c.info },
    ['LspDiagnosticsInformation'] = { link = 'LspDiagnosticsInfo' },
    ['LspDiagnosticsHint'] = { fg = c.hint },
    ['LspDiagnosticsDefaultError'] = { link = 'LspDiagnosticsError' },
    ['LspDiagnosticsDefaultWarning'] = { link = 'LspDiagnosticsWarning' },
    ['LspDiagnosticsDefaultInformation'] = { link = 'LspDiagnosticsInfo' },
    ['LspDiagnosticsDefaultInfo'] = { link = 'LspDiagnosticsInfo' },
    ['LspDiagnosticsDefaultHint'] = { link = 'LspDiagnosticsHint' },
    ['LspDiagnosticsVirtualTextError'] = { link = 'DiagnosticVirtualTextError' },
    ['LspDiagnosticsVirtualTextWarning'] = { link = 'DiagnosticVirtualTextWarn' },
    ['LspDiagnosticsVirtualTextInformation'] = { link = 'DiagnosticVirtualTextInfo' },
    ['LspDiagnosticsVirtualTextInfo'] = { link = 'DiagnosticVirtualTextInfo' },
    ['LspDiagnosticsVirtualTextHint'] = { link = 'DiagnosticVirtualTextHint' },
    ['LspDiagnosticsFloatingError'] = { link = 'LspDiagnosticsError' },
    ['LspDiagnosticsFloatingWarning'] = { link = 'LspDiagnosticsWarning' },
    ['LspDiagnosticsFloatingInformation'] = { link = 'LspDiagnosticsInfo' },
    ['LspDiagnosticsFloatingInfo'] = { link = 'LspDiagnosticsInfo' },
    ['LspDiagnosticsFloatingHint'] = { link = 'LspDiagnosticsHint' },
    ['LspDiagnosticsSignError'] = { link = 'LspDiagnosticsError' },
    ['LspDiagnosticsSignWarning'] = { link = 'LspDiagnosticsWarning' },
    ['LspDiagnosticsSignInformation'] = { link = 'LspDiagnosticsInfo' },
    ['LspDiagnosticsSignInfo'] = { link = 'LspDiagnosticsInfo' },
    ['LspDiagnosticsSignHint'] = { link = 'LspDiagnosticsHint' },
    ['NvimTreeLspDiagnosticsError'] = { link = 'LspDiagnosticsError' },
    ['NvimTreeLspDiagnosticsWarning'] = { link = 'LspDiagnosticsWarning' },
    ['NvimTreeLspDiagnosticsInformation'] = { link = 'LspDiagnosticsInfo' },
    ['NvimTreeLspDiagnosticsInfo'] = { link = 'LspDiagnosticsInfo' },
    ['NvimTreeLspDiagnosticsHint'] = { link = 'LspDiagnosticsHint' },
    ['LspDiagnosticsUnderlineError'] = { link = 'DiagnosticUnderlineError' },
    ['LspDiagnosticsUnderlineWarning'] = { link = 'DiagnosticUnderlineWarn' },
    ['LspDiagnosticsUnderlineInformation'] = { link = 'DiagnosticUnderlineInfo' },
    ['LspDiagnosticsUnderlineInfo'] = { link = 'DiagnosticUnderlineInfo' },
    ['LspDiagnosticsUnderlineHint'] = { link = 'DiagnosticUnderlineHint' },
    ['LspReferenceRead'] = { bg = c.reference },
    ['LspReferenceText'] = { bg = c.reference },
    ['LspReferenceWrite'] = { bg = c.reference },
    ['LspCodeLens'] = { fg = theme.codelens_fg, italic = true },
    ['LspCodeLensSeparator'] = { fg = theme.codelens_fg, italic = true },

    -- StatusLine
    ['StatusLine'] = { fg = theme.statusline_fg, bg = theme.statusline_bg },
    ['StatusLineNC'] = { fg = c.alt_bg, bg = theme.statusline_bg },
    ['StatusLineSeparator'] = { fg = theme.statusline_bg },
    ['StatusLineTerm'] = { fg = theme.statusline_bg },
    ['StatusLineTermNC'] = { fg = theme.statusline_bg },
  }
end

---@param bg Theme
---@return horizon.HighlightDef
local function get_plugin_highlights(bg)
  ---@module 'horizon.palette-dark'
  local theme = require(('horizon.palette-%s'):format(bg))
  local lsp_kinds = get_lsp_kind_highlights(theme)
  return {
    whichkey = {
      ['WhichKey'] = { fg = c.purple },
      ['WhichKeySeperator'] = { fg = c.yellow },
      ['WhichKeyGroup'] = { fg = c.red },
      ['WhichKeyDesc'] = { fg = theme.fg },
      ['WhichKeyFloat'] = { bg = c.alt_bg },
    },
    gitsigns = {
      ['SignAdd'] = { fg = theme.git_added_fg },
      ['SignChange'] = { fg = theme.git_modified_fg },
      ['SignDelete'] = { fg = theme.git_deleted_fg },
      ['GitSignsAdd'] = { fg = theme.git_added_fg },
      ['GitSignsChange'] = { fg = theme.git_modified_fg },
      ['GitSignsDelete'] = { fg = theme.git_deleted_fg },
      ['GitSignsUntracked'] = { fg = theme.git_untracked_fg },
      ['GitSignsAddInline'] = { link = 'DiffText' },
    },
    quickscope = {
      ['QuickScopePrimary'] = { fg = '#ff007c', underline = true },
      ['QuickScopeSecondary'] = { fg = '#00dfff', underline = true },
    },
    telescope = {
      ['TelescopeSelection'] = { bg = c.ui2_blue },
      ['TelescopeSelectionCaret'] = { fg = c.red, bg = c.ui2_blue },
      ['TelescopeMatching'] = { fg = c.yellow, bold = true, italic = true },
      ['TelescopeBorder'] = { fg = c.alt_fg },
      ['TelescopeNormal'] = { fg = c.light_gray, bg = c.alt_bg },
      ['TelescopePromptTitle'] = { fg = c.orange },
      ['TelescopePromptPrefix'] = { fg = c.cyan },
      ['TelescopeResultsTitle'] = { fg = c.orange },
      ['TelescopePreviewTitle'] = { fg = c.orange },
      ['TelescopePromptCounter'] = { fg = c.red },
      ['TelescopePreviewHyphen'] = { fg = c.red },
    },
    nvim_tree = {
      ['NvimTreeFolderIcon'] = { fg = c.gold },
      ['NvimTreeIndentMarker'] = { fg = c.gray },
      ['NvimTreeNormal'] = { fg = theme.sidebar_fg, bg = theme.sidebar_bg },
      ['NvimTreeVertSplit'] = { fg = theme.sidebar_bg, bg = theme.sidebar_bg },
      ['NvimTreeFolderName'] = { fg = theme.sidebar_fg },
      ['NvimTreeOpenedFolderName'] = { fg = theme.sidebar_fg, bold = true, italic = true },
      ['NvimTreeEmptyFolderName'] = { fg = c.gray, italic = true },
      ['NvimTreeGitIgnored'] = { fg = c.gray, italic = true },
      ['NvimTreeImageFile'] = { fg = c.light_gray },
      ['NvimTreeSpecialFile'] = { fg = c.orange },
      ['NvimTreeEndOfBuffer'] = { fg = theme.comment.fg },
      ['NvimTreeCursorLine'] = { bg = theme.cursorline_bg },
      ['NvimTreeGitStaged'] = { fg = c.sign_add_alt },
      ['NvimTreeGitNew'] = { fg = c.sign_add_alt },
      ['NvimTreeGitRenamed'] = { fg = c.sign_add_alt },
      ['NvimTreeGitDeleted'] = { fg = theme.git_deleted_fg },
      ['NvimTreeGitMerge'] = { fg = c.sign_change_alt },
      ['NvimTreeGitDirty'] = { fg = theme.git_untracked_fg },
      ['NvimTreeSymlink'] = { fg = c.cyan },
      ['NvimTreeRootFolder'] = { fg = theme.fg, bold = true },
      ['NvimTreeExecFile'] = { fg = '#9FBA89' },
    },
    neo_tree = {
      ['NeoTreeFolderIcon'] = { fg = c.gold },
      ['NeoTreeIndentMarker'] = { fg = c.gray },
      ['NeoTreeNormal'] = { fg = theme.sidebar_fg, bg = theme.sidebar_bg },
      ['NeoTreeFileName'] = { fg = theme.sidebar_fg },
      ['NeoTreeDirectoryName'] = { fg = theme.sidebar_fg },
      ['NeoTreeDirectoryIcon'] = { fg = theme.sidebar_fg },
      ['NeoTreeVertSplit'] = { fg = c.alt_bg, bg = c.alt_bg },
      ['NeoTreeWinSeparator'] = { fg = c.alt_bg, bg = c.alt_bg },
      ['NeoTreeOpenedFolderName'] = { fg = theme.fg, bold = true, italic = true },
      ['NeoTreeEmptyFolderName'] = { fg = theme.comment.fg, italic = true },
      ['NeoTreeGitIgnored'] = { fg = theme.comment.fg, italic = true },
      ['NeoTreeDotfile'] = { fg = theme.comment.fg, italic = true },
      ['NeoTreeHiddenByName'] = { fg = theme.comment.fg, italic = true },
      ['NeoTreeEndOfBuffer'] = { fg = theme.comment.fg },
      ['NeoTreeCursorLine'] = { bg = theme.cursorline_bg },
      ['NeoTreeGitStaged'] = { fg = theme.git_added_fg },
      ['NeoTreeGitUntracked'] = { fg = theme.git_untracked_fg },
      ['NeoTreeGitDeleted'] = { fg = theme.git_deleted_fg },
      ['NeoTreeGitModified'] = { fg = theme.git_modified_fg },
      ['NeoTreeSymbolicLinkTarget'] = { fg = c.cyan },
      ['NeoTreeRootName'] = { fg = theme.fg, bold = true },
      ['NeoTreeTitleBar'] = { fg = c.dark_gray, bg = theme.fg, bold = true },
    },
    barbar = {
      ['BufferCurrent'] = { fg = theme.fg, bg = theme.bg },
      ['BufferCurrentIndex'] = { fg = theme.fg, bg = theme.bg },
      ['BufferCurrentMod'] = { fg = c.info, bg = theme.bg },
      ['BufferCurrentSign'] = { fg = c.hint, bg = theme.bg },
      ['BufferCurrentTarget'] = { fg = c.red, bg = theme.bg, bold = true },
      ['BufferVisible'] = { fg = theme.fg, bg = theme.bg },
      ['BufferVisibleIndex'] = { fg = theme.fg, bg = theme.bg },
      ['BufferVisibleMod'] = { fg = c.info, bg = theme.bg },
      ['BufferVisibleSign'] = { fg = c.gray, bg = theme.bg },
      ['BufferVisibleTarget'] = { fg = c.red, bg = theme.bg, bold = true },
      ['BufferInactive'] = { fg = c.gray, bg = c.alt_bg },
      ['BufferInactiveIndex'] = { fg = c.gray, bg = c.alt_bg },
      ['BufferInactiveMod'] = { fg = c.info, bg = c.alt_bg },
      ['BufferInactiveSign'] = { fg = c.gray, bg = c.alt_bg },
      ['BufferInactiveTarget'] = { fg = c.red, bg = c.alt_bg, bold = true },
    },
    indent_blankline = {
      ['IndentBlanklineContextChar'] = { fg = theme.indent_guide_active_fg },
      ['IndentBlanklineContextStart'] = { sp = theme.indent_guide_active_fg, underline = true },
      ['IndentBlanklineChar'] = { fg = theme.indent_guide_fg },
    },
    cmp = {
      ['CmpItemAbbrMatch'] = { fg = theme.pmenu_item_sel_fg },
      ['CmpItemAbbrMatchFuzzy'] = { fg = theme.pmenu_item_sel_fg, italic = true },
      ['CmpItemAbbrDeprecated'] = { fg = c.gray, strikethrough = true },
      ['CmpItemKindVariable'] = lsp_kinds['variable'],
      ['CmpItemKindModule'] = lsp_kinds['module'],
      ['CmpItemKindSnippet'] = lsp_kinds['snippet'],
      ['CmpItemKindFolder'] = lsp_kinds['folder'],
      ['CmpItemKindColor'] = lsp_kinds['color'],
      ['CmpItemKindFile'] = lsp_kinds['file'],
      ['CmpItemKindText'] = lsp_kinds['text'],
      ['CmpItemKindMethod'] = lsp_kinds['method'],
      ['CmpItemKindFunction'] = lsp_kinds['function'],
      ['CmpItemKindConstructor'] = lsp_kinds['constructor'],
      ['CmpItemKindField'] = lsp_kinds['field'],
      ['CmpItemKindProperty'] = lsp_kinds['property'],
      ['CmpItemKindUnit'] = lsp_kinds['unit'],
      ['CmpItemKindValue'] = lsp_kinds['value'],
      ['CmpItemKindEnum'] = lsp_kinds['enum'],
      ['CmpItemKindKeyword'] = lsp_kinds['keyword'],
      ['CmpItemKindReference'] = lsp_kinds['reference'],
      ['CmpItemKindConstant'] = lsp_kinds['constant'],
      ['CmpItemKindStruct'] = lsp_kinds['struct'],
      ['CmpItemKindEvent'] = lsp_kinds['event'],
      ['CmpItemKindOperator'] = lsp_kinds['operator'],
      ['CmpItemKindNamespace'] = lsp_kinds['namespace'],
      ['CmpItemKindPackage'] = lsp_kinds['package'],
      ['CmpItemKindString'] = lsp_kinds['string'],
      ['CmpItemKindNumber'] = lsp_kinds['number'],
      ['CmpItemKindBoolean'] = lsp_kinds['boolean'],
      ['CmpItemKindArray'] = lsp_kinds['array'],
      ['CmpItemKindObject'] = lsp_kinds['object'],
      ['CmpItemKindKey'] = lsp_kinds['key'],
      ['CmpItemKindNull'] = lsp_kinds['null'],
      ['CmpItemKindEnumMember'] = lsp_kinds['enumMember'],
      ['CmpItemKindClass'] = lsp_kinds['class'],
      ['CmpItemKindInterface'] = lsp_kinds['interface'],
      ['CmpItemKindTypeParameter'] = lsp_kinds['typeParameter'],
    },
    navic = {
      ['NavicIconsFile'] = lsp_kinds['file'],
      ['NavicIconsModule'] = lsp_kinds['module'],
      ['NavicIconsNamespace'] = lsp_kinds['namespace'],
      ['NavicIconsPackage'] = lsp_kinds['package'],
      ['NavicIconsClass'] = lsp_kinds['class'],
      ['NavicIconsMethod'] = lsp_kinds['method'],
      ['NavicIconsProperty'] = lsp_kinds['property'],
      ['NavicIconsField'] = lsp_kinds['field'],
      ['NavicIconsConstructor'] = lsp_kinds['constructor'],
      ['NavicIconsEnum'] = lsp_kinds['enum'],
      ['NavicIconsInterface'] = lsp_kinds['interface'],
      ['NavicIconsFunction'] = lsp_kinds['function'],
      ['NavicIconsVariable'] = lsp_kinds['variable'],
      ['NavicIconsConstant'] = lsp_kinds['constant'],
      ['NavicIconsString'] = lsp_kinds['string'],
      ['NavicIconsNumber'] = lsp_kinds['number'],
      ['NavicIconsBoolean'] = lsp_kinds['boolean'],
      ['NavicIconsArray'] = lsp_kinds['array'],
      ['NavicIconsObject'] = lsp_kinds['object'],
      ['NavicIconsKey'] = lsp_kinds['key'],
      ['NavicIconsKeyword'] = lsp_kinds['keyword'],
      ['NavicIconsNull'] = lsp_kinds['null'],
      ['NavicIconsEnumMember'] = lsp_kinds['enumMember'],
      ['NavicIconsStruct'] = lsp_kinds['struct'],
      ['NavicIconsEvent'] = lsp_kinds['event'],
      ['NavicIconsOperator'] = lsp_kinds['operator'],
      ['NavicIconsTypeParameter'] = lsp_kinds['typeParameter'],
      ['NavicText'] = { fg = theme.fg },
      ['NavicSeparator'] = { fg = theme.fg },
    },
    packer = {
      ['packerString'] = { fg = c.gold },
      ['packerHash'] = { fg = c.ui4_blue },
      ['packerOutput'] = { fg = c.ui_purple },
      ['packerRelDate'] = { fg = c.gray },
      ['packerSuccess'] = { fg = c.success_green },
      ['packerStatusSuccess'] = { fg = c.ui4_blue },
    },
    symbols_outline = {
      ['SymbolsOutlineConnector'] = { fg = c.gray },
      ['FocusedSymbol'] = { bg = '#36383F' },
    },
    notify = {
      ['NotifyERRORBorder'] = { fg = '#8A1F1F' },
      ['NotifyWARNBorder'] = { fg = '#79491D' },
      ['NotifyINFOBorder'] = { fg = c.ui_blue },
      ['NotifyDEBUGBorder'] = { fg = c.gray },
      ['NotifyTRACEBorder'] = { fg = '#4F3552' },
      ['NotifyERRORIcon'] = { fg = c.error },
      ['NotifyWARNIcon'] = { fg = c.warn },
      ['NotifyINFOIcon'] = { fg = c.ui4_blue },
      ['NotifyDEBUGIcon'] = { fg = c.gray },
      ['NotifyTRACEIcon'] = { fg = c.ui_purple },
      ['NotifyERRORTitle'] = { fg = c.error },
      ['NotifyWARNTitle'] = { fg = c.warn },
      ['NotifyINFOTitle'] = { fg = c.ui4_blue },
      ['NotifyDEBUGTitle'] = { fg = c.gray },
      ['NotifyTRACETitle'] = { fg = c.ui_purple },
    },
    ts_rainbow = {
      -- ['TSRainbowRed'] = {},
      -- ['TSRainbowGreen'] = {},
      -- ['TSRainbowCyan'] = {},
      -- ['TSRainbowOrange'] = {},
      ['TSRainbowBlue'] = { fg = '#169FFF' },
      ['TSRainbowYellow'] = { fg = '#FFD602' },
      ['TSRainbowViolet'] = { fg = '#DA70D6' },
    },
    hop = {
      ['HopNextKey'] = { fg = '#4ae0ff' },
      ['HopNextKey1'] = { fg = '#d44eed' },
      ['HopNextKey2'] = { fg = '#b42ecd' },
      ['HopUnmatched'] = { fg = c.gray },
      ['HopPreview'] = { fg = '#c7ba7d' },
    },
    crates = {
      ['CratesNvimLoading'] = { fg = c.hint },
      ['CratesNvimVersion'] = { fg = c.hint },
    },
  }
end

---Add in any enabled plugin's custom highlighting
---@param config horizon.Config
---@param plugins {[string]: horizon.Opts}
---@param highlights {[string]: horizon.Opts}
local function integrate_plugins(config, plugins, highlights)
  for plugin, enabled in pairs(config.plugins) do
    if enabled and plugins[plugin] then
      for key, value in pairs(plugins[plugin]) do
        highlights[key] = value
      end
    end
  end
  return highlights
end

---@param config horizon.Config
function M.set_highlights(config)
  local bg = vim.o.background
  local highlights = integrate_plugins(config, get_plugin_highlights(bg), get_highlights(bg))
  for name, value in pairs(highlights) do
    api.nvim_set_hl(0, name, value)
  end
end

return M
