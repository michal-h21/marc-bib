#!/usr/bin/env texlua
local marc_parser = require "parsemarc"

local buff = {}
for line in io.lines() do
  buff[#buff + 1] = line
end

local records = marc_parser.parse(table.concat(buff, "\n"))
-- print(#records)
for _, rec in ipairs(records) do
  print(rec["245"][1].a)
end

