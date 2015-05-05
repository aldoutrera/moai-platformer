module("Character", package.seeall)

local character_object = {
  position = { 0, 0 },
  animations = {
    idle = {
      startFrame = 1,
      frameCount = 10,
      time = 0.1,
      mode = MOAITimer.LOOP,
    },
    run = {
      startFrame = 21,
      frameCount = 10,
      time = 0.1,
      mode = MOAITimer.LOOP,
    },
    jump = {
      startFrame = 27,
      frameCount = 1,
      time = 0.1,
      mode = MOAITimer.NORMAL
    },
  },
}

function Character:initialize(layer)
  self.remapper = MOAIDeckRemapper.new()
  self.remapper:reserve(1)

  self.deck = ResourceManager:get('character')
  self.prop = MOAIProp2D.new()
  self.prop:setDeck(self.deck)
  self.prop:setLoc(unpack(character_object.position))
  self.prop:setRemapper(self.remapper)
  layer:insertProp(self.prop)

  self.animations = {}

  for name, def in pairs(character_object.animations) do
    self:addAnimation(name, def.startFrame, def.frameCount, def.time, def.mode)
  end

  self:startAnimation('run')
  self.isMoving = false
  self.isMovingLeft = false
  self:initializePhysics()
end

function Character:addAnimation(name, startFrame, frameCount, time, mode)
  local curve = MOAIAnimCurve.new()
  curve:reserveKeys(2)
  curve:setKey(1, 0, startFrame, MOAIEaseType.LINEAR)
  curve:setKey(2, time * frameCount, startFrame + frameCount, MOAIEaseType.LINEAR)

  local anim = MOAIAnim.new()
  anim:reserveLinks(1)
  anim:setLink(1, curve, self.remapper, 1)
  anim:setMode(mode)

  self.animations[name] = anim
end

function Character:getAnimation(name)
  return self.animations[name]
end

function Character:stopCurrentAnimation()
  if self.currentAnimation then
    self.currentAnimation:stop()
  end
end

function Character:startAnimation(name)
  self:stopCurrentAnimation()
  self.currentAnimation = self:getAnimation(name)
  self.currentAnimation:start()
  return self.currentAnimation
end

function Character:initializePhysics()
  self.physics = {}
  self.physics.body = PhysicsManager.world:addBody(MOAIBox2DBody.DYNAMIC)
  self.physics.body:setTransform(unpack(character_object.position))
  self.physics.fixture = self.physics.body:addRect(-8, -16, 8, 16)
  self.prop:setParent(self.physics.body)

  self.physics.fixture:setCollisionHandler(
    onCollide,
    MOAIBox2DArbiter.BEGIN
  )
end

function Character:run(direction, keyDown)
  if keyDown then
    self.isMoving = true
    self.prop:setScl(direction, 1)
    velX, velY = self.physics.body:getLinearVelocity()
    self.physics.body:setLinearVelocity(direction * 100, velY / 4)

    if (self.currentAnimation ~= self:getAnimation('run')) and not self.jumping then
      self:startAnimation('run')
    end
  else
    self.isMoving = false
    self:stopRunning()
  end
end

function Character:stopRunning()
  if not self.jumping then
    self:startAnimation('idle')
    self.physics.body:setLinearVelocity(0, 0)
  end
end

function Character:moveLeft(keyDown)
  self.isMovingLeft = true
  self:run(-1, keyDown)
end

function Character:moveRight(keyDown)
  self.isMovingLeft = false
  self:run(1, keyDown)
end

function Character:jump(keyDown)
  if keyDown and not self.jumping then
    AudioManager:play('jump')
    self.physics.body:applyForce(0, 4000)
    self.jumping = true
    self:startAnimation('jump')
  end
end

function Character:stopJumping()
  self.jumping = false

  if not self.isMoving then
    self:stopRunning()
  else
    if self.isMovingLeft then
      self:moveLeft('down')
    else
      self:moveRight('down')
    end
  end
end

function onCollide(phase, fixtureA, fixtureB, arbiter)
  if Game:belongsToScene(fixtureB) then
    Character:stopJumping()
  end
  -- if fixtureB == PhysicsManager.floor.fixture then
  --   Character:stopJumping()
  -- end
end
