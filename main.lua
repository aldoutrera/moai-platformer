require 'configuration'
require 'game'

MOAISim.openWindow("Platformer", SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)

viewport = MOAIViewport.new()
viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
viewport:setScale(WORLD_RESOLUTION_X, WORLD_RESOLUTION_Y)

function mainLoop()
  Game:start()
end

gameThread = MOAICoroutine.new()
gameThread:run(mainLoop)
