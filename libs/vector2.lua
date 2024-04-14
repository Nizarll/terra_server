local Vector2 = {}
Vector2.__index = Vector2
Vector2.__mul = function(a, b)
  return setmetatable({
    x = a.x * b.x,
    y = a.y * b.y
  }, Vector2)
end
Vector2.__add = function(a, b)
  return setmetatable({
    x = a.x + b.x,
    y = a.y + b.y
  }, Vector2)
end

function Vector2.new(x, y)
  return setmetatable({
    x = x,
    y = y,
  }, Vector2)
end

function Vector2:tostring()
  return 'Vector2: {x: ' .. self.x .. ' , ' .. 'y: ' .. self.y .. '}'
end

function Vector2:add(vector)
  assert(vector.x, "Vector does not have an x field")
  assert(vector.y, "Vector does not have a y field")
  self.x = self.x + vector.x
  self.y = self.y + vector.y
end

function Vector2:sub(vector)
  assert(vector.x, "Vector does not have an x field")
  assert(vector.y, "Vector does not have a y field")
  self.x = self.x - vector.x
  self.y = self.y - vector.y
end

function Vector2:dot(vector)
  assert(vector.x, "Vector does not have an x field")
  assert(vector.y, "Vector does not have a y field")
  self.x = self.x * vector.x
  self.y = self.y * vector.y
end

function Vector2:serialize()
  local bytes = {}
  table.insert(bytes, math.floor(self.x) & 0xff)
  table.insert(bytes, math.floor(self.x) & 0xff00)
  table.insert(bytes, math.floor(self.y) & 0xff)
  table.insert(bytes, math.floor(self.y) & 0xff00)
  return bytes
end

return Vector2
