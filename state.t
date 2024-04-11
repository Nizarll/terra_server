local 
local State = {}
State.__index = State

State.states = {
  IDLE,
  JUMP,
  BLOCK,
  PARRY,
  WALK,
  WALK_ATTACK,
  WALK_ATTACK_JUMP,
}

function State.new(type, owner, )

end

return State
