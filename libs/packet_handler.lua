local PacketHandler = {}
PacketHandler.__index = PacketHandler

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

function PacketHandler.new(socket)
  return setmetatable({
    socket = socket
  }, PacketHandler)
end

function PacketHandler:send(packet)
  for _, player in ipairs(PlayerHandler.player_ids) do
    self.socket:sendto(packet:serialize(), player.address.ip, player.address.port)
  end
end

function PacketHandler:handle_packet(player, packet)
  if packet.key_pressed == 'd' then
    player:set_position(
      Vector.new(
        player.position.x + .01,
        player.position.y,
      ))
    return
  end
  if packet.key_pressed == 'a' then
    player:set_position(
      Vector2.new(
        player.position.x - .01,
        player.position.y
      ))
    return
  end
end

local function compute_gravity(player)
  if player.position <= 10 then return end
  player.position -= .01
end

-- add other packet handling

return PacketHandler
