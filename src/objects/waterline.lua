local WaterLine = {}
WaterLine.__index = WaterLine
WaterLine.isWaterLine = true
WaterLine.x = 0
WaterLine.y = 0
WaterLine.dy = 0

function WaterLine:new(o)
  local o = o or {}
  return setmetatable(o, WaterLine)
end

return setmetatable(WaterLine, {__call = WaterLine.new})
