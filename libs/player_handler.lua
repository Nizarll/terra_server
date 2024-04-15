local player_handler = {}
local player_ids = {}

function player_handler.get_random_id()
  local id = math.random(0, 255)
  if player_ids[id] then
    return get_random_id()
  end
  return id
end

local function concat_table(t1, t2)
  for i, v in pairs(t2) do
    table.insert(t1, v)
  end
end

function player_handler.get_player_by_id(id)
  return player_ids[player.id]
end

function player_handler.get_player_ids()
  return player_ids
end

function player_handler.register_player(player)
  assert(player.id, "[x] ERROR: given player to register does not have an id")
  assert(not player_ids[player.id], "[x] ERROR: Player with id: " .. player.id .. "is already registered")
  player_ids[player.id] = player
end

return player_handler
