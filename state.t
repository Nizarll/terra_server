local player_handler
local State = {}
State.__index = State

local WalkState = {}
WalkState.__index = function(_, index)
  return WalkState[index] or State[index]
end
local IdleState = {}
IdleState.__index = function(_, index)
  return IdleState[index] or State[index]
end
local AttackState = {}
AttackState.__index = function(_, index)
  print("tried to index", _, index)
  return AttackState[index] or State[index]
end

do
  setmetatable(IdleState, State)
  setmetatable(WalkState, State)
  setmetatable(AttackState, State)
end

function State.new(owner, direction)
  player_handler = player_handler or require('player_handler').handler
  --assert(player_handler.find_player(owner), "[x] ERROR: NO PLAYER ASSIGNED TO STATE CONSTRUCTOR")
  owner.state = setmetatable({
    direction = direction,
    owner = owner,
  }, State)
  return owner.state
end

function WalkState:handle_input()
  assert(self.owner.input, "[x] ERROR: CANNOT HANDLE PLAYER INPUT")
  local input = self.owner.input
  if input.iskey_pressed("mouse1") then return AttackState.new(self.owner, self.direction) end
  if input.iskey_pressed("d") and self.direction == not "right" then return WalkState.new(self.owner, "right") end
  if input.iskey_pressed("a") and self.direction == not "left" then return WalkState.new(self.owner, "left") end
  return nil
end

function IdleState:handle_input()
  assert(self.owner.input, "[x] ERROR: CANNOT HANDLE PLAYER INPUT")
  local input = self.owner.input
  if input.iskey_pressed("mouse1") then return AttackState.new(self.owner, self.direction) end
  if input.iskey_pressed("d") then return WalkState.new(self.owner, "right") end
  if input.iskey_pressed("a") then return WalkState.new(self.owner, "left") end
  return nil
end

local state = AttackState.new({ name = "nizar" }, "left")
print(state, state.direction)
print(state:handle_input())

return {
  WalkState,
  IdleState,
  AttackState,
}
