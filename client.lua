local socket = require("socket.core")
local udp = socket.udp()
local host = "127.0.0.1" -- Replace with the server's IP address
local port = 3000

-- Connect to the server

-- Send data to the server
local message = "Hello, server!"
udp:sendto(message, host, port)

-- Close the connection
udp:close()
