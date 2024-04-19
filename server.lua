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
  local did_send = nil
  repeat
    did_send = udp:sendto(
      string.char(table.unpack(Packet.new(types.ALLOW_CON, {
        id = player.id
      }):serialize())),
      ip,
      port
    )
  until did_send
  packet_handler:send(
    Packet.new(types.CONNECT, { id = player.id }),
    { [player.id] = true }
  )
  print(ANSI_COLOR_BRIGHT_GREEN .. 'Player joined the server with ip : ' ..
    ANSI_STYLE_UNDERLINE .. ANSI_COLOR_WHITE .. ANSI_COLOR_GREEN .. ip .. ':'
    .. port .. ANSI_COLOR_RESET)
end

local function handle_logout(ip, port)
  if not players[ip .. port] then
    return
  end
  PlayerHandler.unregister_player(players[ip .. port])
  print(ANSI_COLOR_BRIGHT_RED .. 'Player with id: '
    .. ANSI_STYLE_UNDERLINE .. players[ip .. port].id
    .. ANSI_COLOR_WHITE .. ANSI_COLOR_RESET .. ANSI_COLOR_BRIGHT_RED .. ' left the server ! '
    .. ANSI_COLOR_RESET)
  players[ip .. port] = nil
end

while true do
  local data, ip, port = udp:receivefrom()
  if data then
    local recv_packet = Packet.deserialize(data)
    if recv_packet.type == types.DEMAND_CON then
      handle_login(ip, port)
      goto continue
    end
    if recv_packet.type == types.DEMAND_DISCON then
      handle_logout(ip, port)
      goto continue
    end
    packet_handler:handle_packet(players[ip .. port], recv_packet)
  end
  Socket.select(nil, nil, .01)
  ::continue::
end

udp:close()
