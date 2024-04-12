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

function Packet:serialize()
	local bytes = {}
	if self.type == types.P_STATE then
		assert(self.data.owner, "[x] ERROR: INVALID PACKET FORMAT SERIALIZATION !")
		assert(self.data.state, "[x] ERROR: INVALID PACKET FORMAT SERIALIZATION !")
		assert(self.data.state, "[x] ERROR: INVALID PACKET FORMAT SERIALIZATION !")
		table.insert(bytes, self.type)
		concat_table(bytes, self.data.owner:serialize())
		concat_table(bytes, self.data.owner.position.serialize(self.data.owner.position))
		return bytes
	end
	if self.type == types.P_CONNECT then
		return bytes
	end
end

local function dump_table(table)
	local s = "TABLE DUMP:\n"
	for i, item in pairs(table) do
		if type(item) == "table" then
			dump_table(item)
		end
		s = s .. "[" .. i .. "]: " .. item .. "\n"
	end
	print(s)
end
