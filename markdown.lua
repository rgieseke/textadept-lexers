-- Markdown LPeg lexer
-- April 2010 Robert Gieseke
-- freely distributable under the same license as Textadept

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

_rules = {
  { 'whitespace', ws },
  { 'header', header },
  { 'any_char', l.any_char},
}

local style_bold = l.style { bold = true }

_tokenstyles = {
  { 'header', style_bold },
}
