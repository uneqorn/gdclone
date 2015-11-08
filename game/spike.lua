spike = {}
function spike.new(t)
  local self = setmetatable(t, spike)
  self.img = love.graphics.newImage("assets/spike.png")
  return self
end
return spike
