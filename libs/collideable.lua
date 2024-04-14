local Collideable = {}

--@params : Vector2 position, Vector2 size
function Collideable.new(position, size)
  return setmetatable({
    position = position,
    size = size
  }, Collideable)
end

-- add apply texture

return Collideable
