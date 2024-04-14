local socket = require 'socket'
local packet = require 'libs.packet'
local udp = socket.udp()
local port = 3000
assert(udp:setsockname('127.0.0.1', port),
  "Failed binding to host 127.0.0.1 to port" .. port)
udp:settimeout(1)

local function print_p(p)
  print("key is :" .. p[1] .. "\n" .. "state is:" .. p[2])
end
while true do
  local data, ip, port = udp:receivefrom()
  if data then
    local recv_bytes = packet.deserialize(data)
    packet.print_p(recv_packet)
  end
  socket.select(nil, nil, .01)
end
