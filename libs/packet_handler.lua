local Vector2 = require('libs.vector2')
local PacketHandler = {}

function PacketHandler.handle_packet(player, packet)
  if packet.key_pressed == 'd' then
    player:set_position(
      player.position.x + .01,
      player.position.y,
    )
    return
  end
  if packet.key_pressed == 'a' then
    player:set_position(
      player.position.x - .01,
      player.position.y
    )
    return
  end
end

return PacketHandler
