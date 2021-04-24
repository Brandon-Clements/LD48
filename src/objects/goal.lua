local Goal = {}
Goal.__index = Goal
Goal.isGoal = true

function Goal:new(o)
  local o = o or {}
  return setmetatable(o, Goal)
end

return setmetatable(Goal, {__call = Goal.new})
