local Wall = {}
Wall.__index = Wall
Wall.isWall = true

function Wall:new(o)
  local o = o or {}
  return setmetatable(o, Wall)
end

return setmetatable(Wall, {__call = Wall.new})
