local States = require 'libs.state'
local Vector2 = require 'libsvector2'
local WalkState, IdleState, AttackState = States.WalkState, States.IdleState, States.AttackState
local Player = {}
Player.__index = Player


local function get_random_id()
  local id = math.random(0, 255)
  if player_handler[id] then
    return get_random_id()
  end
  return id
end

function Player.new(ip, port, position)
  assert(position, "player constructor needs to be assigned a position")
  assert(position.x, "player constructor needs to be assigned a position")
  assert(position.y, "player constructor needs to be assigned a position")
  return setmetatable({
    id = get_random_id(),
    position = position,
    state = IdleState.new(self, "left")
    self.address = {ip = ip, port = port}
  }, Player)
end

function Player:set_size(size)
  assert(size.x, "[x] ERROR: size needs to have x and y fields")
  assert(size.y, "[x] ERROR: size needs to have x and y fields")
  self.position = size
end

function Player:set_position(position)
  assert(position.x, "[x] ERROR: Player position needs to have x and y fields")
  assert(position.y, "[x] ERROR: Player position needs to have x and y fields")
  self.position = position
end

function Player:serialize()
  -- serialize
  local bytes = {}
  table.insert(bytes, self.id)
  table.insert(bytes, self.state.type or states.INVALID_STATE)
  concat_table(bytes, self.position:serialize())
  return bytes
end

return Player
