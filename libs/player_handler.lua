local Tools = require 'libs.tools'
local player_handler = {}
local player_ids = {}

function player_handler.get_random_id()
  local id = math.random(0, 255)
  if player_ids[id] then
    return get_random_id()
  end
  return id
end

function player_handler.get_player_by_id(id)
  return player_ids[player.id]
end

function player_handler.get_player_ids()
  return player_ids
end

function player_handler.register_player(player)
  if not player.id then
    print('[x] ERROR: given player to register does not have an id')
    return
  end
  if player_ids[player.id] then
    print('[x] ERROR: Player with id: ' .. player.id .. 'is already registered')
    return
  end
  player_ids[player.id] = player
end

function player_handler.unregister_player(player)
  if not player.id then
    print('[x] ERROR: given player to register does not have an id')
    return
  end
  if not player_ids[player.id] then
    print('[x] ERROR: Player with id: ' .. player.id .. 'is not registered')
    return
  end
  player_ids[player.id] = nil
end

return player_handler
