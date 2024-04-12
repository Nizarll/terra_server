local socket = require 'socket'

local udp = socket.udp()
local port = 3000
udp:setsockname('*', port)
udp:settimeout(1)

while true do

end
