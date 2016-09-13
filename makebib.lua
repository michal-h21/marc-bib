#!/usr/bin/env texlua
local marc_parser = require "parsemarc"
local ris_parser  = require "parseris"

local buff = {}
for line in io.lines() do
  buff[#buff + 1] = line
end

local text = table.concat(buff, "\n") 

print("je to marc", marc_parser.detect(text))
local records = {}
if marc_parser.detect(text) then
  records = marc_parser.parse(text)
end
-- print(#records)
for _, rec in ipairs(records) do
  print((rec["245"] or {{}})[1].a)
end

