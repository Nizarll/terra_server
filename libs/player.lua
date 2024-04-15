local States = require 'libs.state'
local PlayerHandler = require 'libs.player_handler'
local Vector2 = require 'libs.vector2'
local WalkState, IdleState, AttackState = States.WalkState, States.IdleState, States.AttackState
local Player = {}
Player.__index = Player



function Player.new(ip, port, position)
  assert(position, "player constructor needs to be assigned a position")
  assert(position.x, "player constructor needs to be assigned a position")
  assert(position.y, "player constructor needs to be assigned a position")
  return setmetatable({
    id = PlayerHandler.get_random_id(),
    position = position,
    state = IdleState.new(self, "left"),
    address = {
      ["ip"] = ip,
      ["port"] = port,
    },
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

function Player:set_state(state)
  assert(state.owner, "[x] ERROR: Player state needs to have an owner field")
  assert(state.type, "[x] ERROR: Player position needs to have a type field")
  assert(state.direction, "[x] ERROR: Player position needs to have a direction field")
  self.state = state
end

function Player:serialize()
  local bytes = {}
  table.insert(bytes, self.state.type or states.INVALID_STATE)
  table.insert(bytes, self.id)
  table.insert(bytes, self.state.direction == 'left' and 0x00 or 0x01)
  concat_table(bytes, self.position:serialize())
  return bytes
end

return Player
