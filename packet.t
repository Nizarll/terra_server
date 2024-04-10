local utils = terralib.includec("utils.h")

local Packet = {}

function Packet.new(is_client_packet, data)
  return setmetatable({
    is_client_packet = is_client_packet,
    payload = payload,
  }, Packet)
end

function Packet:encode()
  for index, field in pairs(self) do

  end
end
