local socket = require 'socket'
local packet = require 'libs.packet'
local udp = socket.udp()
local port = 3000
assert(udp:setsockname('127.0.0.1', port),
  "Failed binding to host 127.0.0.1 to port" .. port)
udp:settimeout(1)

while true do
  local data, ip, port = udp:receivefrom()
  if data then
    local recv_packet = packet.deserialize(data)
    if recv_packet then
     local reply_packet = packet.deserialize()
      udp:sendto(p:serialize)
    end
  end
  socket.select(nil, nil, .01)
end
