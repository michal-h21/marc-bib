local parseris = {}

function parseris.detect(text)
  return text:match("FN%s*[^\n]+")
end

function parseris.parse(text)
  local records = {}
  for line in text:gmatch("([^\n]+)") do
    print(" *'",line)
  end
  return records
end
return parseris
