block = {}
function block.new(t)
  local self = setmetatable(t, block)
  self.img = love.graphics.newImage("assets/block.png")
  return self
end
return block
