module("PhysicsManager", package.seeall)

function PhysicsManager:initialize(layer)
  self.world = MOAIBox2DWorld.new()
  self.world:setUnitsToMeters(1/38)
  self.world:setGravity(0, -10)
  self.world:start()

  if layer then
--    layer:setBox2DWorld(self.world)
    layer:setUnderlayTable({world})
  end

  self.floor = {}
  self.floor.body = self.world:addBody(MOAIBox2DBody.STATIC)
  self.floor.body:setTransform(0, (-WORLD_RESOLUTION_Y/2) + 10)
  self.floor.fixture = self.floor.body:addRect(-WORLD_RESOLUTION_X / 2 + 10, -5, WORLD_RESOLUTION_X / 2 - 10, 5)
  self.floor.fixture:setFriction(0)
end
