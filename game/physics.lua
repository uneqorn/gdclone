require "global"

physics = {}

function physics.fall(dt, x, y, w, h)
  if #Blocks == 0 then Blocks = {{x=0,y=0,img=love.graphics.newImage("assets/block.png")}} end
  for k,v in pairs(Blocks) do --Fall if not touching floor or block
    if v.x == nil then v.x = 0 end
    if v.y == nil then v.y = 0 end
    if physics.collision(x,y,w,h, v.x,v.y,48,1) or y > 100 then
      --print("stay")
      onGround = true
      return y
    end
  end
  --print(y)
  --print("fall")
  onGround = false
  return y+500*dt
end

function physics.collision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

return physics
