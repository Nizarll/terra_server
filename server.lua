local Socket = require 'socket'
local Packet = require 'libs.packet'
local PacketHandler = require 'libs.packet_handler'
local PlayerHandler = require 'libs.player_handler'
local Vector2 = require 'libs.vector2'
local types = require 'libs.packet_types'

local udp = Socket.udp()

local port = 3000

assert(udp:setsockname('127.0.0.1', port),
  "Failed binding to host 127.0.0.1 to port" .. port)
udp:settimeout(1)

local packet_handler = PacketHandler.new(udp)

local players = {}

local function player_login(ip, port)
  local player = Player.new(ip, port, Vector2.new(10, 10))
  players[ip .. port] = player
  PlayerHandler.register_player(player)
  udp:sendto(
    Packet.new(types.ALLOW_CON, {}):deserialize(),
    ip,
    port
  )
  packet_handler:send(
    Packet.new(types.CONNECT, { id = player.id }),
    { [player.id] = true }
  )
end

while true do
  local data, ip, port = udp:receivefrom()
  if data then
    local recv_packet = packet.deserialize(data)
    if recv_packet.type == types.DEMAND_CON then
      register_player(ip, port)
    else
      packet_handler:handle_packet(players[ip .. port], recv_packet)
    end
  end
  Socket.select(nil, nil, .01)
end
