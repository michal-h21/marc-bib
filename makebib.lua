#!/usr/bin/env texlua
local marc_parser = require "parsemarc"
local ris_parser  = require "parseris"

local bib_base    = require "bibbase"
local aut_base    = require "autbase"

-- databáze 
aut_base.load("autori.txt")
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


local formats = {}
local authors = {}
local used    = {}
for _, rec in ipairs(records) do
  local id = bib_base.get_one(rec, "001")
  if not used[id] then
    local rec_aut = bib_base.get_authors(rec)
    local count = aut_base.filter(rec_aut)
    if count > 0 then
      print(bib_base.get_one(rec, "245"), count) 
      local t = bib_base.get_one(rec, "FMT") or "unknown"
      formats[t] = (formats[t] or 0) + 1
      for _, aut in ipairs(rec_aut) do
        local name = aut.name
        authors[name] = (authors[name] or 0) + 1
      end
    end
  end
  used[id] = true 
  -- print(get_one(rec, "245", "a"))
end

for k, v in pairs(authors) do 
  -- print(k, v)
end

for k, v in pairs(formats) do
  if v > 1 then print(k,v) end
  -- print(k,v)
end
-- for k,v in pairs(records[#records]["FMT"][1]) do print(k,v) end
-- print(get_one(records[#records], "FMT"))

