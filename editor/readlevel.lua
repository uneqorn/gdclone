readlevel = function(file) --Function that reads a file and returns the info of a level
  local file = io.open(file, "r")
  if file == nil then return {} end
  local table = {} --File lines to table
  for line in file:lines() do
    table[#table+1] = line
  end

  for key,value in pairs(table) do --Separate each line by spaces
    local words = {}
    local pattern = string.format("([^%s]+)", " ")
    value:gsub(pattern, function(c) words[#words+1] = c end)
    -- print(words[2]:sub(1,1))
    words[1], words[2] = tonumber(words[1]), tonumber(words[2])
    words.x, words.y = words[1], words[2]
    words[1], words[2] = nil
    table[key] = words
  end

  return table
end

return readlevel
