local Socket = require 'socket'
local Packet = require 'libs.packet'
local Player = require 'libs.player'
local PacketHandler = require 'libs.packet_handler'
local PlayerHandler = require 'libs.player_handler'
local Vector2 = require 'libs.vector2'
local types = require 'libs.packet_types'
local _ = require 'libs.ansi'

local udp = Socket.udp()

local port = 8080

assert(udp:setsockname('172.24.22.138', port),
  "Failed binding to host 127.0.0.1 to port" .. port)
udp:settimeout(1)

local packet_handler = PacketHandler.new(udp)

local players = {}

local function handle_login(ip, port)
  local player = Player.new(ip, port, Vector2.new(10, 10))
  players[ip .. port] = player
  PlayerHandler.register_player(player)
  udp:sendto(
    string.char(table.unpack(Packet.new(types.ALLOW_CON, {
      id = player.id
    }):serialize())),
    ip,
    port
  )
  packet_handler:send(
    Packet.new(types.CONNECT, { id = player.id }),
    { [player.id] = true }
  )
  print(ANSI_COLOR_BRIGHT_GREEN .. 'Player joined the server with ip : ' ..
    ANSI_STYLE_UNDERLINE .. ip .. ':'
    .. port .. ANSI_COLOR_RESET)
end

while true do
  local data, ip, port = udp:receivefrom()
  if data then
    local recv_packet = Packet.deserialize(data)
    if recv_packet.type == types.DEMAND_CON then
      handle_login(ip, port)
      goto continue
    end
    packet_handler:handle_packet(players[ip .. port], recv_packet)
  end
  Socket.select(nil, nil, .01)
  ::continue::
end

udp:close()
