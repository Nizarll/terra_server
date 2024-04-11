local Player = {}
local Vector2 = {}
local player_handler = {}

function Player.new(position, size)
  return setmetatable({
    id = math.random(0, 1000),
    size = size,
    position = position
  }, Player)
end

function Player:set_size(size)
  assert(position.x, "[x] ERROR: size needs to have x and y fields")
  assert(position.y, "[x] ERROR: size needs to have x and y fields")
  self.position = size
end

function Player:set_position(position)
  assert(position.x, "[x] ERROR: Player position needs to have x and y fields")
  assert(position.y, "[x] ERROR: Player position needs to have x and y fields")
  self.position = position
end

function player_handler.find_player(player_id)
  return player_handler[playerid]
end

function player_handler.register_player(player)
  assert(player_handler.id, "[x] ERROR: given player to register",
    "does not have an id")
  assert(not player_handler, "[x] ERROR: Player with id: ", player.id, "is already registered")
  player_handler[player.id] = player
end

return player_handler
