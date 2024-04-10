local utils = terralib.includec("utils.h")
local definitions = require("defs.t")
local Packet = {}

function Packet.new(is_client_packet, data)
  return setmetatable(Packet, {
    is_client_packet = is_client_packet,
    payload = payload,
  })
end

function Packet:serialize()
  if self.data == null then
    return null
  end
  local bytes = {}
  for index, field in pairs(self.data) do
    bytes[index] = serialize_field(field)
  end
  return bytes
end

function serialize_field(field)
  field:gettobytes()
  -- serialize the field
  return null
end

function deserialize()

end

return Packet
