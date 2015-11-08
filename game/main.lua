--Get all modules
require "camera"
require "player"
require "block"
require "math"
require "global"
require "physics"
require "readlevel"
require "spike"

--Define constants
local LEVELDIR = love.filesystem.getSourceBaseDirectory().."/levels"
local lg = love.graphics
local width = lg.getWidth()
local height = lg.getHeight()
local font = lg.newFont("assets/font.ttf", 20)
local banner = lg.newImage("assets/banner.png")
--Some other things
local line = {x=50}
local jumpstate = 0
local rotation = 0
local showFps = false

function love.load()
  love.mouse.setVisible(false)
  print("LEVELDIR:", LEVELDIR)
  global.levels = global.scandir(LEVELDIR)
  lg.setFont(font) --Set default font
  global.Blocks = {} --Create table that holds block objects
  lg.setBackgroundColor(100,100,255) --Set backgroundColor to blue
  math.randomseed(os.time()) --Set random seed
  player.x = 200 --Set player attributes
  player.y = 100
  player.attempts = 1
  player.speed = 600
  player.img = lg.newImage("assets/player.png")
end

function love.update(dt)
  if global.mode == "play" then --If not in menu
    player.x = player.x + player.speed * dt --Move player
    player.y = player.y - jumpstate --Jumping animation
    jumpstate = jumpstate / 1.5
    line.x = line.x+player.speed*dt --Move line

    if love.keyboard.isDown(" ") or love.mouse.isDown("l") then --Handle jumping
      if global.onGround then
        jumpstate = 50
      end
    end

    if global.onGround then --Rotate player when it isn't touching the ground
      rotate = false
      rotation = 0
    else
      rotate = true
    end
    if rotate then
      rotation = rotation+0.13
      if rotation > 100 then rotation = 0 end --To avoid overflowing
    end

    player.y = physics.fall(dt, player.x, player.y, 48, 48) --Fall
    for k,v in pairs(global.Blocks) do --Check collision with blocks
      if physics.collision(player.x,player.y,player.img:getWidth()/2,player.img:getHeight(), v.x,v.y+20,v.img:getWidth(),v.img:getHeight()-20) then
        player.die(1)
        line.x = 50
      end
    end

    for k,v in pairs(global.Spikes) do --Check collision with spikes
      if physics.collision(player.x,player.y,player.img:getWidth()/2,player.img:getHeight(), v.x+15,v.y+10,v.img:getWidth()-15,v.img:getHeight()-20) then
        player.die(1)
        line.x = 50
      end
    end
  camera:setPosition(player.x+350 - width / 2, player.y - height / 2) --Scroll
  end
end

function love.draw()
  camera:set()

  if global.mode == "play" then
    lg.print(string.format("ATTEMPTS:   %i", player.attempts), 500, 0) --Show number of attempts
    lg.setColor(255,0,0) --Draw player
    lg.draw(player.img, player.x, player.y+25, rotation, 1, 1, player.img:getWidth()/2, player.img:getHeight()/2)
    lg.setColor(255,255,255)
    for k,v in pairs(global.Blocks) do --Draw blocks
      lg.draw(v.img, v.x, v.y)
    end

    for k,v in pairs(global.Spikes) do --Draw spikes
      lg.draw(v.img, v.x, v.y)
    end

    lg.setColor(0,0,75) --Draw line
    lg.rectangle("fill", line.x,148 ,line.x+width,300)
    lg.setColor(200,200,255)
    lg.rectangle("fill", line.x,148,line.x+width,1)


    if showFps then --Show frames per second if user has pressed 'f'
      lg.print(string.format("FPS: %i", love.timer.getFPS()), player.x-100, player.y-290)
    end

  elseif global.mode == "menu" then
    lg.setColor(255,255,255)
    lg.draw(banner, width/2-250, height/2-250)
    lg.setColor(0,0,0)
    lg.print("<  SELECT LEVEL  >", width/2-150, height/2-75)
    lg.print(global.levels[global.selectedLevel], width/2-75, height/2-25)
    lg.print("[PRESS ENTER]", width/2-130, height/2+25)
    -- print(global.levels[global.selectedLevel])
  end
  camera:unset()
end

function love.keypressed(k)
  if global.mode == "menu" then
    local level = global.levels[global.selectedLevel]
    if k == "right" and global.levels[global.selectedLevel+1] ~= nil then
      global.selectedLevel = global.selectedLevel + 1
    elseif k == "left" and global.levels[global.selectedLevel-1] ~= nil then
      global.selectedLevel = global.selectedLevel - 1
    elseif k == "return" or k == " " then
      -- print("play")
      lg.setBackgroundColor(100,100,200)
      global.mode = "play"
      createBlocks(readlevel(LEVELDIR.."/"..level.."/blocks.txt"))
      createSpikes(readlevel(LEVELDIR.."/"..level.."/spikes.txt"))
    end
  end
  if k == "escape" then --Quit game
    if global.mode == "play" then
      player.die(-player.attempts+1)
      global.mode = "menu"
      lg.setBackgroundColor(100,100,255)
      global.selectedLevel = 1
      camera:setPosition(0,0)
      line.x = 50
      return
    end
    love.event.quit()
  elseif k == "f" then --Show fps
    showFps = not showFps
  end
end

function createBlocks(blocks) --Create a table of block objects
  for k,v in pairs(blocks) do
    global.Blocks[k] = block.new(v)
  end
end

function createSpikes(spikes) --Create a table of spike objects
  for k,v in pairs(spikes) do
    global.Spikes[k] = spike.new(v)
  end
end
