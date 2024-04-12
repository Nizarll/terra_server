local types = require("packet_types")
local Packet = {}
Packet.__index = Packet

function Packet.new(type, data)
  assert(type, "[x] ERROR: INVALID PACKET TYPE !")
  return setmetatable({
    type = type,
    data = data,
  }, Packet)
end

local packet = {
  types.P_STATE,
  state = 0x01,
  direction = 0x01,
  owner = 0x0000,
  position = 0x00000000,
}

function Packet:serialize()
  local bytes = {}
  if self.type == types.P_STATE then
    table.insert(bytes self.type)
    table.insert(bytes, self.data.state.type)
    table.insert(bytes, self.data.state.direction == 'left' and 0x00 or 0x01)
    table.insert(bytes, self.data.owner.id)
    local members = self.data.owner.position.serialize(self.data.owner.position)
    for i = 1, #members do
      table.insert(bytes, members[i])
    end
    return bytes
  end
  if self.type == types.P_CONNECT then
    return
  end
end

local function dump_table(table)
  s = "TABLE DUMP:\n"
  for i, item in pairs(table) do
    if type(item) == 'table' then dump_table(item) end
    s = s .. "[" .. i .. "]: " .. item .. "\n"
  end
  print(s)
end

dump_table(player_state_packet:serialize())
