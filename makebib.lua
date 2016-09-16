#!/usr/bin/env texlua
local marc_parser = require "parsemarc"
local ris_parser  = require "parseris"

local bib_base    = require "bibbase"

local buff = {}
for line in io.lines() do
  buff[#buff + 1] = line
end

local text = table.concat(buff, "\n") 

local records = {}
if marc_parser.detect(text) then
  records = marc_parser.parse(text)
elseif ris_parser.detect(text) then
  records = ris_parser.parse(text)
else
  print("Can't detect format")
  print("Usage: ./makebib.lua < bibfile")
end
-- print(#records)
for _, rec in ipairs(records) do
  -- print((rec["245"] or {{}})[1].a)
end

