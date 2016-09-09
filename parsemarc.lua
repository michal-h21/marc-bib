local parsemarc = {}

parsemarc.delimiter = "Číslo záznamu"

local function parse_fields(line)
  -- new record
  local delimiter = parsemarc.delimiter
  if line:match(delimiter) then return "", "", true end
  local fields = {}
  local tag, xx, rest = line:match("%s*(...)(..)%s*(.*)")
  fields.xx = xx
  fields.full = rest
  rest = rest:gsub("|(.) ([^|]+)", function(a, b) 
    fields[a] = b 
    return ""
  end)
  -- záznamy bez podpolí
  fields.line = rest
  return tag, fields
end



function parsemarc.parse(text)
  local records = {}
  local current = nil
  local function insert_fields(tag, fields)
    local current = current or {}
    local field = current[tag] or {}
    table.insert(field, fields)
    current[tag] = field
    return current
  end
  local function insert_record(curr)
    if curr then 
      local copy = {}
      for k,v in pairs(curr) do copy[k] = v end
      table.insert(records, copy)
    end
    return {}
  end
  -- current record
  for line in text:gmatch("([^\n]+)") do 
    -- if new is true, close the current record 
    local tag, fields, new = parse_fields(line)
    if new == true then
      current = insert_record(current)
    else
      current = insert_fields(tag, fields)
    end
  end
  insert_record(current)
  return records
end

return parsemarc
