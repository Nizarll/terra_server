local player_handler
local WalkState = {}
WalkState.__index = WalkState
local IdleState = {}
IdleState.__index = IdleState
local AttackState = {}
AttackState.__index = AttackState

local state_enum = {
  S_INVALID = 0x00,
  S_WALK = 0x01,
  S_ATTACK = 0x02,
}

function AttackState.new(owner, direction)
  return setmetatable({
    type = state_enum.S_ATTACK,
    owner = owner,
    direction = direction,
  }, AttackState)
end

function WalkState.new(owner, direction)
  return setmetatable({
    type = state_enum.S_WALK,
    owner = owner,
    direction = direction,
  }, WalkState)
end

function IdleState.new(owner, direction)
  return setmetatable({
    type = state_enum.S_IDLE,
    owner = owner,
    direction = direction
  }, IdleState)
end

function WalkState:handle_input()
  assert(self.owner.input, "[x] ERROR: CANNOT HANDLE PLAYER INPUT")
  local input = self.owner.input
  if input.iskey_pressed("mouse1") then
    return AttackState.new(self.owner, self.direction)
  end
  if input.iskey_pressed("d") and self.direction == not "right" then
    return WalkState.new(self.owner, "right")
  end
  if input.iskey_pressed("a") and self.direction == not "left" then
    return WalkState.new(self.owner, "left")
  end
  return nil
end

function IdleState:handle_input()
  assert(self.owner.input, "[x] ERROR: CANNOT HANDLE PLAYER INPUT")
  local input = self.owner.input
  if input.iskey_pressed("mouse1") then
    return AttackState.new(self.owner, self.direction)
  end
  if input.iskey_pressed("d") then
    return WalkState.new(self.owner, "right")
  end
  if input.iskey_pressed("a") then
    return WalkState.new(self.owner, "left")
  end
  return nil
end

local return_result = { WalkState, IdleState, AttackState }

for estate, value in pairs(state_enum) do
  return_result[estate] = value
end

return return_result
