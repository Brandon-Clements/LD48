local bump = require "external/bump"
local world = {}--bump.newWorld()
local levels = require "levels/levels"
local level = {}--require "levels/1"
local timer = love.timer.getTime
local Wall = require "objects/wall"
local Goal = require "objects/goal"
local DeathBox = require "objects/deathbox"
local WaterLine = require "objects/waterline"

player = {}
player.x = 5
player.y = 5
player.w = 32
player.h = 32
player.dy = 0
player.onFloor = flase
player.recentlyOnFloor = false
player.lastOnFloor = 0.1

message = ""
messageKeep = false
messageTime = 0

function love.load()
  playerImage = love.graphics.newImage("res/Player.png")
  waterImage = love.graphics.newImage("res/water.png")
  belowWaterImage = love.graphics.newImage("res/below-water.png")
  loadLevel(1)
end

function loadLevel(levelNum)
  level = levels[levelNum]:new()
  world = bump.newWorld()
  player.x = level.startX
  player.y = level.startY
  world:add(player, player.x, player.y, player.w, player.h)

  for k,v in ipairs(level.tilemap) do
    local o = {}
    if v == 1 then
      o = Wall()
    elseif v == 2 then
      o = Goal()
    elseif v == DeathBox.ITEMNUM then
      o = DeathBox()
    end
    world:add(o, ((k - 1) % 20) * 32, math.floor((k - 1) / 20) * 32, 32, 32)
  end
  player.isDead = false
  if level.waterLine then
    world:add(level.waterLine, 0, level.waterLine.y, 640, 32)
  else
    --
  end

end

function love.draw()
  love.graphics.setBackgroundColor(0.02, 0.03, 0.04, 1)
  love.graphics.draw(playerImage, player.x, player.y)

  love.graphics.print(message, 100, 100)
  for k, v in ipairs(level.tilemap) do
    if v == 1 then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.rectangle("fill", ((k-1) % 20) * 32, math.floor((k-1)/20) * 32, 32, 32)
    elseif v == 2 then
      love.graphics.setColor(0, 0, .5, 1)
      love.graphics.rectangle("fill", ((k-1) % 20) * 32, math.floor((k-1)/20) * 32, 32, 32)
    end
  end
  if level.waterLine then
    love.graphics.draw(waterImage, 0, level.waterLine.y, 0, 3, 3)--, ox, oy, kx, ky)
    love.graphics.draw(belowWaterImage, 0, level.waterLine.y + 6)
  end

end


function love.update(dt)
  checkFloor()

  if timer() - messageTime > 2 and messageKeep == false then
    message = ""
    if player.isDead then
      print("Reloading world")
    end
  end

  if player.dy < 10 then
    player.dy = player.dy + 1
  end

  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    if player.onFloor then
      player.dy = - 10
    elseif player.recentlyOnFloor then
      player.dy = - 10
    end
  else
    player.recentlyOnFloor = false
  end

  player.y = player.y + player.dy

  if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
    player.x = player.x - 10
  elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
    player.x = player.x + 10
  end

  player.x, player.y, cols, len = world:move(player, player.x, player.y, collFilter)
  if level.waterLine then
    level.waterLine.x, level.waterLine.y = world:move(level.waterLine, 0, level.waterLine.y + level.waterLine.dy, noColl)
  end
  for i=1,len do
    if cols[i].other.isGoal then
      loadLevel(level.next)
    elseif cols[i].other.isDeathBox or cols[i].other.isWaterLine then
      player.isDead = true
      messageKeep = false
      message = "You Died"
      messageTime = timer()
      loadLevel(1)
    end
  end
end

function checkFloor()
  local cx, cy = world:check(player, player.x, player.y+1, collFilter)
  if cy == player.y then
    player.onFloor = true
    player.lastOnFloor = timer()
  else
    player.onFloor = false
  end

  if (timer() - player.lastOnFloor) < .1 then
    player.recentlyOnFloor = true
  else
    player.recentlyOnFloor = false
  end
end

function collFilter(this, other)
  if other.isWall then return 'slide'
  elseif other.isGoal then return 'cross'
  elseif other.isDeathBox then return 'cross'
  elseif other.isWaterLine then return 'cross'
  end
end

function noColl(this, other)
  return 'cross'
end
