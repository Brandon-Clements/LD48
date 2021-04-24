local bump = require "external/bump"
local world = bump.newWorld()
local level = require "levels/1"

player = {}
player.x = 5
player.y = 5
player.w = 32
player.h = 32
player.dy = 0

function love.load()
  playerImage = love.graphics.newImage("res/Player.png")
  player.x = level.startX
  player.y = level.startY
  world:add(player, player.x, player.y, player.w, player.h)

  for k,v in ipairs(level.tilemap) do
    if v == 1 then
      local l = v
      world:add(k, ((k - 1) % 30) * 32, math.floor((k - 1) / 30) * 32, 32, 32)
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(0, 0, 0, 255)
  love.graphics.draw(playerImage, player.x, player.y)
  for k, v in ipairs(level.tilemap) do
    if v == 1 then
      love.graphics.rectangle("fill", ((k-1) % 30) * 32, math.floor((k-1)/30) * 32, 32, 32)
    end
  end
end


function love.update(dt)
  if player.dy < 10 then
    player.dy = player.dy + 1
  end

  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    local cx, cy = world:check(player, player.x, player.y+1)
    if cy == player.y then
      player.dy = - 17
    end
  end

  player.y = player.y + player.dy

  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    player.x = player.x - 10
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    player.x = player.x + 10
  end

  player.x, player.y, cols, len = world:move(player, player.x, player.y)
end
