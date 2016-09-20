local bib_base = {}

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

bib_base.get_one     = get_one
bib_base.get_authors = get_authors
return bib_base
