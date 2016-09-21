local bib_base = {}

local upper = unicode.utf8.upper
local lower = unicode.utf8.lower

local function get_one(record, key, field)
  local record = record or {}
  local entry  = record[key] or {}
  local first  = entry[1] or {}
  local field  = field or "full"
  return first[field] 
end

local function get_oneauthor(entry)
  local entry = entry or {}
  local name = entry.a 
  if not name then return nil end
  name = name:gsub(",%s*$","")
  return {name = name, relation = entry["4"]}
end

local function get_authors(record)
  local authors = {}
  -- autor muze byt v poli 100 nebo 700
  for _, field in ipairs{"100", "700"} do
    for _, rec in ipairs(record[field] or {}) do
      local aut = get_oneauthor(rec)
      table.insert(authors, aut)
    end
  end
  return authors
end

local function get_title(record)
  local last
  local main = get_one(record, "245", "a"):gsub("%s*/%s*$","")--:gsub("(.)%s*$", function(a) last = a end)
  local sub  = get_one(record, "245", "b")
  local number =get_one(record, "245", "n") 
  local add = get_one(record, "245", "p")
  local out = {}
  out[#out + 1] = main
  out[#out + 1] = sub
  out[#out + 1] = number
  out[#out + 1] = addd
  -- if last == ":" then
  return  out
end

local function get_pubinfo(record, output)
  local field = "260"
  -- nakladatelské údaje jsou buď v poli 260 nebo 264
  if record[field] == nil then field = "264" end
  output.publisher = get_one(record, field, "b")
  output.location  = get_one(record, field, "a")
  output.year      = get_one(record, field, "c")
  return output
end

local function get_record(record)
  local output = {}
  output.authors = get_authors(record)
  output.title   = get_title(record)
  local fmt      = get_one(record, "FMT")
  output.format  = fmt
  if fmt == "BK" then
    -- for k,v in pairs(record["264"][1]) do print(k,v)end
    output = get_pubinfo(record, output)
    output.isbn =  get_one(record, "020", "a")
    output.vol = get_one(record, "901", "f") or ""
    output.pages = get_one(record, "300", "a")
  elseif fmt == "RM" then
    output.pub_title = get_one(record, "773","t")
    output.pub_info  = get_one(record, "773","d")
    output.pages     = get_one(record, "773","g")
    output.isbn      = get_one(record, "773","z")
  end
  -- for k,v in pairs(record) do print(k,v) end
  return output
end


local function get_citation(record)
  local authors = record.authors or {}
  local aut_table = {}
  local ed_table  = {}
  for _, aut in ipairs(authors) do
    local name = aut.name:gsub("^([^%,]+)", function(a) return upper(a) end)
    local rel  = aut.relation
    if relation == "aut" or relation == nil then
      aut_table[#aut_table + 1] = name
    else
      ed_table[#ed_table + 1] = name
    end
  end
  local aut_block = table.concat(aut_table, " - ")
  local ed_block  = table.concat(ed_table, " - ").. " (ed.)"
  local title_block = table.concat(record.title, "")
  local pub_block = (record.location or "") .. (record.publisher or "") .. (record.year or "")
  local output = title_block 
  local isbn = record.isbn and ("ISBN "..record.isbn:gsub(" .*$",""))
  if record.format == "BK" then
    -- nepoužívat pro 1. vydání
    local vol = record.vol
    if vol and vol:find("1") then vol = "" end
    local pages = (record.pages and record.pages:gsub("%s%;%s*",""))
    output = table.concat({aut_block, title_block, vol, pub_block, pages, isbn }, ". ") .. "."
  elseif record.format == "RM" then
    -- for k, v in pairs(record["773"][1]) do print(k,v) end
    local pub_title = "In: " .. record.pub_title
    local pub_block = table.concat({record.pub_info, (record.pages and lower(record.pages)) }, ", ")
    output = table.concat({aut_block, title_block, pub_title, pub_block, isbn}, ". ") .. "."
  end
  output = output:gsub("[%s]+", " "):gsub(" ([%:%,%.%/%;])", "%1"):gsub("[%.%,%/%;]+%.",".")
  return output
end
  

bib_base.get_one     = get_one
bib_base.get_authors = get_authors
bib_base.get_record  = get_record
bib_base.get_citation= get_citation
return bib_base
