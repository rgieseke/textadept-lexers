-- Markdown LPeg lexer
-- April 2010 Robert Gieseke
-- freely distributable under the same license as Textadept

-- TODO links, images?
-- TODO embed HTML?

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

module(...)

local ws = token('whitespace', l.space^1)

-- header
local setext = P('=')^2 + P('-')^2 * l.newline
local atx = l.starts_line('#' * l.nonnewline^0)
local header = token('header', setext + atx)

-- not styled
local list = token('list', '*' * l.space^1 * l.nonnewline^0)
local literal = token('literal', '\\' * S('\\`*_{}[]()#+-.!'))

local code = token('code', l.delimited_range("`"))
-- TODO indented blocks?

-- emphasis
local emph = token('emph', l.delimited_range("*") + l.delimited_range("_"))

-- strong
local underscores = '__' * (l.any - '_')^1 * '__'
local stars = '**' * (l.any - '*')^1 * '**'
local strong = token('strong', underscores + stars)

_rules = {
  { 'whitespace', ws },
  { 'header', header },
  { 'literal', literal },
  { 'list', list },
  { 'strong', strong },
  { 'emph', emph},
  { 'code', code},
  { 'any_char', l.any_char},
}

local style_bold = l.style { bold = true }
local style_italic = l.style { italic = true }

_tokenstyles = {
  { 'header', style_bold },
  { 'list', l.style_none },
  { 'literal', l.style_none },
  { 'strong', style_bold },
  { 'emph', style_italic },
  { 'code', l.style_constant },
}
