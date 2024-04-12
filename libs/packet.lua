local utils = terralib.includec("./utils.h")
local types = require("packet_types")
local Packet = {}
Packet.__index = Packet

function Packet.new(type, data)
  assert(types[type], "[x] ERROR: INVALID PACKET TYPE !")
  return setmetatable({
    type = type,
    data = data,
  }, Packet)
end

function Packet:serialize()
end
