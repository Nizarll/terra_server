local utils = terralib.includec("./utils.h")
local definitions = require("defs")
local Packet = {}
Packet.__index = Packet

function Packet.new(data)
  local self = setmetatable({
    is_client_packet = false,
    data = data,
  }, Packet)
  return self
end

local GameStatePacket = {}
local PlayerStatePacket = {}
local PlayerPositionPacket = {}
local VfxPacket = {}

local function serialize_data(field)
  --serialize field
end

function GameStatePacket.new(State)
  return Packet.new(State)
end

--@Vfx.new
--@Params {Vector2, String type | VfxType : struct}
function VfxPacket.new(Position, Type)
  return Packet.new(false, {
    position = Position,
    type = Type,
  })
end

function VfxPacket:serialize()
  local bytes = {
    serialize_data("VfxPacket"),
    serialize_data(self.position.x),
    serialize_data(self.position.y),
    serialize_data(self.type),
  }
end

return {
  ["Packet"] = Packet,
  ["GameStatePacket"] = GameStatePacket,
  ["PlayerStatePacket"] = PlayerStatePacket,
  ["PlayerPositionPacket"] = PlayerPositionPacket,
  ["VfxPacket"] = VfxPacket,
}
