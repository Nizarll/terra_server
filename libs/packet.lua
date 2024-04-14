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


local key_pressed = 0
local key_state = 0

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
  local bytes = { string.byte(data, 1, -1) }
  local type = bytes[1]

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
  --print
  if self.type == types.CLIENT_INPUT then
    print("PACKET PRINT : CLIENT INPUT\n" .. "\tkey:" .. string.char(self.data.key_pressed)
      .. "\n\tstate:" .. self.data.key_state)
  end
end

function Packet:serialize()
  local bytes = {}
  if self.type == types.P_STATE or self.type == types.P_CONNECT or self.type == types.P_DISCONNECT then
    assert(self.data.owner, "[x] ERROR: INVALID PACKET FORMAT SERIALIZATION !")
    assert(self.data.state, "[x] ERROR: INVALID PACKET FORMAT SERIALIZATION !")
    table.insert(bytes, self.type)
    concat_table(bytes, self.data.owner:serialize())
    --concat_table(bytes, self.data.owner.position)
    return bytes
  end
end

return Packet
