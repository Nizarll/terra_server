local PacketHandler = {}
PacketHandler.__index = PacketHandler

local _ = require 'libs.ansi'
local Packet = require 'libs.packet'
local State = require 'libs.state'
local PlayerHandler = require 'libs.player_handler'
local Vector2 = require 'libs.vector2'
local Collideable = require 'libs.collideable'
local types = require 'libs.packet_types'

local Flags = {
  GROUND = 0x00,
}
local objects = {
  Ground = Collideable.new(Vector2.new(0, 0), Vector2.new(0, 10), Flags.GROUND),
}

local function log_packet(packet, ignore)
  if ignore and #ignore > 0 then
    print('[x] - sent packet to all players: but: ' .. ANSI_COLOR_BRIGHT_YELLOW)
    for id, _ in ipairs(ignore) do
      print(id .. ' ')
    end
    print(ANSI_COLOR_RESET .. ANSI_STYLE_UNDERLINE
      .. packet:get_name() .. ANSI_COLOR_RESET)
    return
  end
  print('[x] - sent packet to all players: ' .. ANSI_STYLE_UNDERLINE
    .. packet:get_name() .. ANSI_COLOR_RESET)
end

function PacketHandler.new(socket)
  return setmetatable({
    socket = socket
  }, PacketHandler)
end

function PacketHandler:send(packet, ignore)
  log_packet(packet, ignore)
  for id, player in ipairs(PlayerHandler.get_player_ids()) do
    if not ignore or (ignore and not ignore[id]) then
      self.socket:sendto(string.char(table.unpack(packet:serialize())), player.address.ip, player.address.port)
    end
  end
end

function PacketHandler:handle_packet(player, packet)
  if player and packet.data.key_pressed and packet.data.key_pressed == 'd' or packet.data.key_pressed == 'a' then
    player:set_state(State["WalkState"].new(
      player,
      packet.data.key_pressed == 'd' and 'right' or 'left'
    ))
    self:send(Packet.new(types.STATE, { owner = player }))
    return
  end
end

local function compute_gravity(player)
  if player.position <= 10 then return end
  player.position.y = player.position.y - 0.1
end

-- add other packet handling

return PacketHandler
