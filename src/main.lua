local bump = require "external/bump"
local world = {}--bump.newWorld()
local levels = require "levels/levels"
local level = {}--require "levels/1"
local timer = love.timer.getTime
local Wall = require "objects/wall"
local Goal = require "objects/goal"

player = {}
player.x = 5
player.y = 5
player.w = 32
player.h = 32
player.dy = 0
player.onFloor = flase
player.recentlyOnFloor = false
player.lastOnFloor = 0.1

function love.load()
  playerImage = love.graphics.newImage("res/Player.png")
  loadLevel(1)
end

function loadLevel(levelNum)
  level = levels[levelNum]
  world = bump.newWorld()
  player.x = level.startX
  player.y = level.startY
  world:add(player, player.x, player.y, player.w, player.h)

  for k,v in ipairs(level.tilemap) do
    if v == 1 then
      local o = Wall()
      world:add(o, ((k - 1) % 20) * 32, math.floor((k - 1) / 20) * 32, 32, 32)
    elseif v == 2 then
      local o = Goal()
      world:add(o, ((k - 1) % 20) * 32, math.floor((k - 1) / 20) * 32, 32, 32)
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(0, 0, 0, 1)
  love.graphics.draw(playerImage, player.x, player.y)
  for k, v in ipairs(level.tilemap) do
    if v == 1 then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.rectangle("fill", ((k-1) % 20) * 32, math.floor((k-1)/20) * 32, 32, 32)
    elseif v == 2 then
      love.graphics.setColor(0, 0, .5, 1)
      love.graphics.rectangle("fill", ((k-1) % 20) * 32, math.floor((k-1)/20) * 32, 32, 32)
    end
  end
end


function love.update(dt)
  checkFloor()
  if player.dy < 10 then
    player.dy = player.dy + 1
  end

  if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
    if player.onFloor then
      print("Floor")
      player.dy =  -10
    elseif player.recentlyOnFloor then
      print("Recently2")
      player.dy = -10
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
  for i=1,len do
    if cols[i].other.isGoal then
      loadLevel(level.next)
    end
  end
end

function checkFloor()
  local cx, cy = world:check(player, player.x, player.y+1)
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
  elseif other.isGoal then
     return 'cross'
  end
end
