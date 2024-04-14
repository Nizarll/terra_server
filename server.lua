local Socket = require 'socket'
local Packet = require 'libs.packet'
local PacketHandler = require 'libs.packet_handler'
local PlayerHandler = require 'libs.player_handler'
local types = require 'libs.packet_types'

local udp = Socket.udp()

local port = 3000

assert(udp:setsockname('127.0.0.1', port),
  "Failed binding to host 127.0.0.1 to port" .. port)
udp:settimeout(1)

local packet_handler = PacketHandler.new(udp)

while true do
  local data, ip, port = udp:receivefrom()
  if data then
    local recv_packet = packet.deserialize(data)
    if recv_packet.type == types.DEMAND_CON then
      PlayerHandler.register_player(Player.new(data,))
    end
  end
  socket.select(nil, nil, .01)
end
