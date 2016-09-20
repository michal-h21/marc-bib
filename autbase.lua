local autbase = {}

base = {}


local lower = unicode.utf8.lower
local memo = {}

local function normalize(name)
  if memo[name] then return memo[name] end
  memo[name] = lower(name:gsub(" ",""):gsub("-",""):gsub(",",""))
  return memo[name]
end
function autbase.load(filename) 
  for line in io.lines(filename) do
    local name = normalize(line)
    base[name] = 1
  end
end

function autbase.filter(authors)
  local count = 0
  for _, aut in ipairs(authors) do
    local name = normalize(aut.name or "")
    count = count + (base[name]  or 0)
  end
  return count
end


return autbase
