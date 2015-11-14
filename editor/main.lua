--Get all modules
require "camera"
require "block"
require "math"
require "global"
require "readlevel"
require "spike"
require "writelevel"
require "utf8"

--Define constants
LEVELDIR = love.filesystem.getSourceBaseDirectory().."/levels"
levels = global.scandir(LEVELDIR)
selectedLevel = 1
mode = "menu"
local lg = love.graphics
local width = lg.getWidth()
local height = lg.getHeight()
local font = lg.newFont("assets/font.ttf", 20)
local banner = lg.newImage("assets/banner.png")
local arrow = lg.newImage("assets/arrow.png")
local arrow2 = lg.newImage("assets/arrow2.png")
local arroww = arrow:getWidth()
local arrow2h = arrow2:getHeight()
--Some other things
local line = {x=50} --Create line object
local Blocks = {} --Table that holds block objects
local Spikes = {} --Table that holds spike opjects
local mouse = {} --Create mouse object
camera.x, camera.y = 0, 0
local selectedBlock = {img = lg.newImage("assets/block.png"), name = "cube"}
local typing, typingText = false, ""

function love.load()
  print("LEVELDIR: ", LEVELDIR)
  lg.setFont(font) --Set default font
  lg.setBackgroundColor(255,50,50) --Set backgroundColor to blue
  math.randomseed(os.time()) --Set random seed
  love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
  -- print(#Blocks, #Spikes)
  if mode == "edit" then --If not in menu
    mouse.x, mouse.y = love.mouse.getX(), love.mouse.getY()
    line.x = mouse.x
  end
end

function love.draw()
  camera:set()

  if mode == "edit" then
    line.x = camera.x --Move line

    --Draw floor and floor line
    lg.setColor(0,0,75)
    lg.rectangle("fill", line.x-500,148 ,line.x+width,300)
    lg.setColor(255,255,255)
    lg.line(line.x-500,148, line.x+width, 148)

    -- Draw starting line
    lg.setColor(100,255,100)
    lg.line(200, camera.y-height, 200, camera.y+height)

    lg.setColor(255,255,255)
    --Draw spikes
    for k,v in pairs(Spikes) do
      lg.draw(v.img, v.x, v.y)
    end

    --Draw blocks
    for k,v in pairs(Blocks) do
      lg.draw(v.img, v.x, v.y)
    end

    --DRAW ARROWS
    lg.draw(arrow, camera.x-width/2+arroww,camera.y-height/2,0, -1, 1) --RIGHT
    lg.draw(arrow, camera.x+width/2-arroww,camera.y-height/2) --LEFT
    lg.draw(arrow2, camera.x-width/2+arroww,camera.y-height/2+arrow2h, 0, 1, -1) --UP
    lg.draw(arrow2, camera.x-width/2+arroww,camera.y+height/2-arrow2h) --DOWN

    --Print selected block + its image
    lg.print("Selected Block: "..selectedBlock.name, camera.x + width/6, camera.y - height/2+50)
    lg.draw(selectedBlock.img, camera.x+width/3, camera.y-height/3-20, 0, 1.1, 1.1)

  elseif mode == "menu" then
    lg.setColor(255,255,255)
    lg.draw(banner, width/2-250, height/2-250)
    lg.setColor(0,0,0)
    lg.print("<  SELECT LEVEL  >", width/2-150, height/2-75)
    lg.print(levels[selectedLevel], width/2-75, height/2-25)
    lg.print("[PRESS ENTER]", width/2-130, height/2+25)
    if typing then
      lg.setColor(255,255,255)
      lg.print("Type the name of the new file: ", width/4, height/2-30)
      lg.rectangle("fill", width/4, height/2, #typingText*18, 30)
      lg.setColor(0,0,0)
      lg.printf(typingText, width/4+5, height/2+5, width)
    end
    -- print(levels[selectedLevel])
  end
  camera:unset()
end

function love.textinput(ch)
  if not typingN then
    typingN = true
    return
  elseif typing and ch ~= " " and ch ~= ";" then
    typingText = typingText..ch
    return
  end
end

function love.keypressed(k)
  if mode == "menu" then
    local level = levels[selectedLevel]
    if typing then
      if k == "backspace" then
        typingText = typingText:sub(1, #typingText-1)
      elseif k == "escape" then --exit
        typing = false
        typingText = ""
      elseif k == "return" then
        typing = false
        os.execute("mkdir '"..LEVELDIR.."'/"..typingText)
        print("creating dir "..LEVELDIR.."/"..typingText)
        levels = global.scandir(LEVELDIR)
      end
    elseif k == "n" then
      typingN = false
      typing = true
    elseif k == "right" and levels[selectedLevel+1] ~= nil then
      selectedLevel = selectedLevel + 1
    elseif k == "left" and levels[selectedLevel-1] ~= nil then
      selectedLevel = selectedLevel - 1
    elseif k == "return" or k == " " then
      lg.setBackgroundColor(100,100,200)
      mode = "edit"
      camera:setPosition(-width/2,-height/2)
      Blocks = {} --Delete blocks and spikes
      Spikes = {}
      createBlocks(readlevel(LEVELDIR.."/"..level.."/blocks.txt")) --Get them from the file again
      createSpikes(readlevel(LEVELDIR.."/"..level.."/spikes.txt"))
    elseif k == "escape" then
      love.event.quit()
    end
  elseif mode == "edit" then
    if k == "s" then --Save level
      writelevel(Blocks, Spikes)
    elseif k == "escape" then --Quit
      lg.setBackgroundColor(255,50,50)
      selectedLevel = 1
      camera:setPosition(0,0)
      line.x = 50
      mode = "menu"
    end
  end
end

function love.mousepressed(x,y,button)
  if mode == "edit" then
    if button == "l" and x > width-50 then --PRESS RIGHT
      camera.x = camera.x+100
      camera:setPosition(camera.x - width / 2, camera.y - height/2)
    elseif button == "l" and x < 50 then --PRESS LEFT
      if camera.x >= 200 then
        camera.x = camera.x-100
      end
      -- print(camera.x)
      camera:setPosition(camera.x - width / 2, camera.y - height/2)
    elseif button == "l" and y < 50 then --PRESS UP
      camera.y = camera.y-100
      -- print(camera.y)
      camera:setPosition(camera.x - width / 2, camera.y - height/2)
    elseif button == "l" and y > height-50 then --PRESS DOWN
      camera.y = camera.y+100
      -- print(camera.y)
      camera:setPosition(camera.x - width / 2, camera.y - height/2)

    elseif button == "wu" then --Scroll up
      selectedBlock.img = lg.newImage("assets/spike.png")
      selectedBlock.name = "spike"
    elseif button == "wd" then --Scroll down
      selectedBlock.img = lg.newImage("assets/block.png")
      selectedBlock.name = "cube"
    else
      if button == "l" then --Build
        if selectedBlock.name == "cube" then
          Blocks[#Blocks+1] = block.new({x=camera.x-width/2+x-24, y=camera.y-height/2+y-24})
        elseif selectedBlock.name == "spike" then
          Spikes[#Spikes+1] = spike.new({x=camera.x-width/2+x-24, y=camera.y-height/2+y-24})
        end
      elseif button == "r" then --Destroy
        for key, block in pairs(Blocks) do --Destroy blocks colliding with mouse
          if collision(camera.x-width/2+x,camera.y-height/2+y,1,1, block.x,block.y,block.img:getWidth(),block.img:getHeight()) then
            Blocks[key] = nil
            return
          end
        end

        for key, spike in pairs(Spikes) do --Destroy spikes colliding with mouse
          if collision(camera.x-width/2+x,camera.y-height/2+y,1,1, spike.x, spike.y, spike.img:getWidth(), spike.img:getHeight()) then
            Spikes[key] = nil
            return
          end
        end
      end
    end
  end

end

function createBlocks(blocks) --Create a table of block objects
  for k,v in pairs(blocks) do
    Blocks[k] = block.new(v)
  end
end

function createSpikes(spikes) --Create a table of spike objects
  for k,v in pairs(spikes) do
    Spikes[k] = spike.new(v)
  end
end

function collision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
