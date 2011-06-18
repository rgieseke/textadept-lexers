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

-- Sections.
local section_keywords = word_match { 'part', 'chapter', 'section',
                                      'subsection', 'subsubsection', 'title',
                                      'subject', 'subsubject',
                                      'subsubsubject' }
local parts = token('parts', '\\' * section_keywords)

-- ConTeXt environments.
local environment = token('environment', '\\' * (P('start') + 'stop') * l.word)

local tex = l.load('tex')
_rules = tex._rules
_rules[1] = { 'whitespace', ws }
_rules[3] = { 'environment', environment }
table.insert(_rules, 4, { 'parts', parts })

_tokenstyles = {
  { 'parts', l.style_class },
  { 'environment', l.style_tag },
}

-- Embedded Lua.
local luatex = l.load('lua')
local luatex_start_rule = #P('\\startluacode') * environment
local luatex_end_rule = #P('\\stopluacode') * environment
l.embed_lexer(_M, luatex, luatex_start_rule, luatex_end_rule)

_foldsymbols = {
  _patterns = { '\\[a-z]+', '[{}]' },
  ['environment'] = { ['\\start'] = 1, ['\\stop'] = -1 },
  [l.OPERATOR] = { ['{'] = 1, ['}'] = -1 }
}
