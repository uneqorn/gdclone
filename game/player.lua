player = {}

function player.die(a)
  player.x = 200
  player.y = 50
  player.speed = 600
  player.attempts = player.attempts + a
end

return player
