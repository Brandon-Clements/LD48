local DeathBox = {}
DeathBox.__index = DeathBox
DeathBox.isDeathBox = true
DeathBox.ITEMNUM = 9

function DeathBox:new(o)
  local o = o or {}
  return setmetatable(o, DeathBox)
end

return setmetatable(DeathBox, {__call = DeathBox.new})
