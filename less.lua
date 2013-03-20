-- Less CSS LPeg lexer.

local l = lexer
local token = l.token
local S = lpeg.S

local M = {_NAME = 'less'}

-- Line comments.
local line_comment = token(l.COMMENT, '//' * l.nonnewline^0)

-- Variables.
local variable = token(l.VARIABLE, '@' * (l.alnum + S('_-'))^1)

local css = l.load('css')
local _rules = css._rules
table.insert(_rules, 7, {'line_comment', line_comment})
table.insert(_rules, #_rules - 1, {'variable', variable})
M._rules = _rules
M._foldsymbols = css._foldsymbols

return M
