-- Copyright 2006-2011 Mitchell mitchell<att>caladbolg.net. See LICENSE.
-- Modified by Robert Gieseke.
-- ConTeXt LPeg lexer.

local l = lexer
local token, style, color, word_match = l.token, l.style, l.color, l.word_match
local P, R, S = l.lpeg.P, l.lpeg.R, l.lpeg.S

local tex = require('tex')

module(...)

-- parts
local section_keywords = word_match { 'part', 'chapter', 'section',
                                      'subsection', 'subsubsection', 'title',
                                      'subject', 'subsubject',
                                      'subsubsubject' }
local parts = token('parts', '\\' * section_keywords)

-- ConTeXt environments.
local environment = token('environment', '\\' * (P('start') + 'stop') * l.word)

_rules = {
  { 'whitespace', tex.ws },
  { 'comment', tex.comment },
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
