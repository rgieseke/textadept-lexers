-- Copyright 2006-2011 Mitchell mitchell<att>caladbolg.net. See LICENSE.
-- Modified by Robert Gieseke.
-- ConTeXt LPeg lexer.

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S
local table = _G.table

module(...)

-- Whitespace.
local ws = token(l.WHITESPACE, l.space^1)

-- Comments.
local comment = token(l.COMMENT, '%' * l.nonnewline^0)

-- Commands.
local escapes = S('#$&~_^%{}')
local command = token(l.KEYWORD, '\\' * (l.alpha^1 + escapes))

-- Sections.
local section_keywords = word_match { 'part', 'chapter', 'section',
                                      'subsection', 'subsubsection', 'title',
                                      'subject', 'subsubject',
                                      'subsubsubject' }
local parts = token('parts', '\\' * section_keywords)

-- ConTeXt environments.
local environment = token('environment', '\\' * (P('start') + 'stop') * l.word)

-- Operators.
local operator = token(l.OPERATOR, S('$&#{}[]'))

_rules = {
  { 'whitespace', ws },
  { 'comment', comment },
  { 'environment', environment },
  { 'parts', parts},
  { 'keyword', command },
  { 'operator', operator },
  { 'any_char', l.any_char },
}

_tokenstyles = {
  { 'environment', l.style_tag },
  { 'parts', l.style_class },
}

_foldsymbols = {
  _patterns = { '\\start', '\\stop', '[{}]' },
  ['environment'] = { ['\\start'] = 1, ['\\stop'] = -1 },
  [l.OPERATOR] = { ['{'] = 1, ['}'] = -1 }
}

-- Embedded Lua.
local luatex = l.load('lua')
local luatex_start_rule = #P('\\startluacode') * environment
local luatex_end_rule = #P('\\stopluacode') * environment
l.embed_lexer(_M, luatex, luatex_start_rule, luatex_end_rule)

