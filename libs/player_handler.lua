local States = require 'state'
local Vector2 = require 'vector2'
local WalkState, IdleState, AttackState = States.WalkState, States.IdleState, States.AttackState
local Player = {}
Player.__index = Player
local player_handler = {}

local function concat_table(t1, t2)
  for i, v in pairs(t2) do
    table.insert(t1, v)
  end
end

local function get_random_id()
  local id = math.random(0, 255)
  if player_handler[id] then
    return get_random_id()
  end
  return id
end

function Player.new(position)
  assert(position, "player constructor needs to be assigned a position")
  local self
  self = setmetatable({
    id = get_random_id(),
    position = position,
    state = IdleState.new(self, "left"),
  }, Player)
  return self
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
  table.insert(bytes, self.state.type or States.INVALID_STATE)
  concat_table(bytes, self.position:serialize())
  return bytes
end

function player_handler.find_player(player)
  return player_handler[player.id]
end

function player_handler.register_player(player)
  assert(player_handler.id, "[x] ERROR: given player to register", "does not have an id")
  assert(not player_handler, "[x] ERROR: Player with id: ", player.id, "is already registered")
  player_handler[player.id] = player
end

return { ["handler"] = player_handler, ["constructor"] = Player }
