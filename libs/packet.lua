local types = require("libs.packet_types")
local Packet = {}
Packet.__index = Packet

--[[
-- CLIENT PACKETS:
--
--  INPUT PACKET : {
--    input_type: string,
--    input_key: string,
--    input_state: int,
--  }
--
--
--  SERVER AND CLIENT PACKETS:
-- packet formats :
--
-- PACKET STATE : {
--  owner : player,
--  state: state
-- }
-- PACKET CONNECT : {
-- owner: player,
-- }
--
-- PACKET  DISCONNECT: {
-- owner: player,
-- }
--
--]]

local function concat_table(t1, t2)
  for i, v in pairs(t2) do
    table.insert(t1, v)
  end
end

function Packet.new(type, data)
  assert(type, "[x] ERROR: INVALID PACKET TYPE !")
  return setmetatable({
    type = type,
    data = data,
  }, Packet)
end

function Packet.deserialize(payload)
  local bytes = payload
  if type(payload) == 'string'
  then
    bytes = { string.byte(payload, 1, -1) }
  end
  local type = bytes[1]
  if not type then return end
  if type == types.DEMAND_CON then
    return Packet.new(types.DEMAND_CON)
  end
  return Packet.new(types.CLIENT_INPUT, {
    key_pressed = (bytes[1] == 0x8f and 'mb2') or (bytes[1] == 0x8e and 'mb1')
        or string.lower(string.char(bytes[1])),
    key_state = bytes[2] == 0 and 'pressed' or 'released'
  })
end

function Packet:print()
  if self.type == types.CLIENT_INPUT then
    print("PACKET PRINT : CLIENT INPUT\n" .. "\tkey:" .. self.data.key_pressed
      .. "\n\tstate:" .. self.data.key_state)
  end
end

function Packet:get_name()
  if self.type == types.DEMAND_CON then return 'DEMAND_CON' end
  if self.type == types.ALLOW_CON then return 'ALLOW_CON' end
  if self.type == types.CONNECT then return 'CONNECT' end
  if self.type == types.DISCONNECT then return 'DISCONNECT' end
  if self.type == types.STATE then return 'STATE' end
  return 'unimplemented'
end

function Packet:serialize()
  local bytes = {}
  table.insert(bytes, self.type)
  if self.type == types.CONNECT or self.type == types.ALLOW_CON then
    table.insert(bytes, self.data.id)
    return bytes
  end
  if self.type == types.STATE then
    assert(self.data.owner, "[x] ERROR: INVALID PACKET FORMAT SERIALIZATION !")
    concat_table(bytes, self.data.owner:serialize())
    --concat_table(bytes, self.data.owner.position)
    return bytes
  end
  return bytes
end

return Packet
