-- Copyright 2006-2011 Mitchell mitchell<att>caladbolg.net. See LICENSE.
-- Modified by Robert Gieseke.
-- LaTeX LPeg lexer.

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

local tex = require('tex')

module(...)

-- Comments.
local line_comment = '%' * l.nonnewline^0
local block_comment = '\\begin{comment}' * (l.any - '\\end{comment}')^0 *
                      P('\\end{comment}')^-1
local comment = token(l.COMMENT, line_comment + block_comment)

-- parts
local section_keywords = word_match { 'part', 'chapter', 'section',
                                      'subsection', 'subsubsection',
                                      'paragraph', 'subparagraph' }
local parts = token('parts', '\\' * section_keywords * P('*')^-1)

-- LaTeX environments.
local environment = token('environment', '\\' * (P('begin') + 'end'))

_rules = {
  { 'whitespace', tex.ws },
  { 'comment', comment },
  { 'parts', parts },
  { 'environment', environment },
  { 'keyword', tex.command },
  { 'operator', tex.operator },
  { 'any_char', l.any_char },
}

_tokenstyles = {
  { 'parts', l.style_class },
  { 'environment', l.style_tag },
}

_foldsymbols = {
  _patterns = { '\\[a-z]+', '[{}]' },
  [l.COMMENT] = { ['\\begin'] = 1, ['\\end'] = -1 },
  ['environment'] = { ['\\begin'] = 1, ['\\end'] = -1 },
  [l.OPERATOR] = { ['{'] = 1, ['}'] = -1 }
}
