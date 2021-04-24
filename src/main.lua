local bump = require "external/bump"
local world = bump.newWorld()

function love.load()
  astring = "Game"
end

function love.draw()
  love.graphics.setBackgroundColor(.5, 1, .5, 255)
end
