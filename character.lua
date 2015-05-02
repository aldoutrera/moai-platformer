module("Character", package.seeall)

local character_object = {
  position = { 0, 0 },
  animations = {
    idle = {
      startFrame = 8,
      frameCount = 1,
      time = 0.1,
      mode = MOAITimer.LOOP,
    },
    run = {
      startFrame = 1,
      frameCount = 3,
      time = 0.1,
      mode = MOAITimer.LOOP,
    },
    jump = {
      startFrame = 4,
      frameCount = 3,
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
