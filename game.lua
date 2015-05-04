require 'resource_definitions'
require 'resource_manager'
require 'input_manager'
require 'character'
require 'physics_manager'
require 'hud'
require 'audio_manager'

module("Game", package.seeall)

local resource_definitions = {
  background = {
    type =  RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-bg.png',
    width = 272, height = 160,
  },
  mountain_far_away = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-montain-far.png',
    width = 272, height = 160,
  },
  mountains = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-mountains.png',
    width = 272, height = 160,
  },
  mountain_trees = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-trees.png',
    width = 544, height = 160,
  },
  foreground_trees = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-foreground-trees.png',
    width = 544, height = 160,
  },
  character = {
    type = RESOURCE_TYPE_TILED_IMAGE,
    fileName = 'character/warrior.png',
    tileMapSize = { 10, 10 },
    width = 32, height = 32,
  },
  hudFont = {
    type = RESOURCE_TYPE_FONT,
    fileName = 'fonts/arialbd.ttf',
    glyphs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.?!",
    fontSize = 26,
    dpi = 160,
  },
}

local background_objects = {
  background = {
    position = { 0, 0 },
    parallax = { 0, 0 }
  },
  mountain_far_away = {
    position = { 0, 0 },
    parallax = { 0.0005, 0.0005 }
  },
  mountains = {
    position = { 0, 0 },
    parallax = { 0.1, 0.1}
  },
  mountain_trees = {
    position = { 0, 0 },
    parallax = { 0.5, 0.5}
  },
  foreground_trees = {
    position = { 0, 0 },
    parallax = { 1, 1}
  },
}

local scene_objects = {
  floor = {
    type = MOAIBox2DBody.STATIC,
    position = { 0, -WORLD_RESOLUTION_Y / 2 },
    friction = 0,
    size = { 2 * WORLD_RESOLUTION_X, 10 },
  },
  platform_1 = {
    type = MOAIBox2DBody.STATIC,
    position = { 50, -10 },
    friction = 0,
    size = { 100, 20 },
  },
}

function Game:start()
  self:initialize()

  while(true) do
    HUD:update()
    self:updateCamera()
    coroutine.yield()
  end
end

function Game:initialize()
  ResourceDefinitions:setDefinitions(resource_definitions)
  InputManager:initialize()

  self.camera = MOAICamera2D.new()
  self:setupLayers()
  self:loadBackground()

  PhysicsManager:initialize(self.layers.walkBehind)

  self:loadScene()

  Character:initialize(self.layers.foreground_trees)
  HUD:initialize()
  AudioManager:initialize()
end

function Game:loadBackground()
  self.background = {}

  for name, attributes in pairs(background_objects) do
    local b = {}
    b.deck = ResourceManager:get(name)
    b.prop = MOAIProp2D.new()
    b.prop:setDeck(b.deck)
    b.prop:setLoc(unpack(attributes.position))

    self.layers[name]:insertProp(b.prop)
    self.layers[name]:setParallax(unpack(attributes.parallax))

    self.background[name] = b
  end

end

--function Game:processInput()
--  local x, y = InputManager:deltaPosition()

--  self.camera:moveLoc(x, 0, 0.5, MOAIEaseType.LINEAR)
--end

function Game:setupLayers()
  self.layers = {}
  self.layers.background = MOAILayer2D.new()
  self.layers.mountain_far_away = MOAILayer2D.new()
  self.layers.mountains = MOAILayer2D.new()
  self.layers.mountain_trees = MOAILayer2D.new()
  self.layers.foreground_trees = MOAILayer2D.new()
  self.layers.walkBehind = MOAILayer2D.new()

  for key, layer in pairs(self.layers) do
    layer:setViewport(viewport)
    layer:setCamera(self.camera)
  end

  local renderTable = {
    self.layers.background,
    self.layers.mountain_far_away,
    self.layers.mountains,
    self.layers.mountain_trees,
    self.layers.foreground_trees,
    self.layers.walkBehind,
  }

  MOAIRenderMgr.setRenderTable(renderTable)
end

function Game:keyPressed(key, down)
  print(key)
  if key == 'right' then Character:moveRight(down) end
  if key == 'left' then Character:moveLeft(down) end
  if key == 'up' then Character:jump(down) end
end

function Game:loadScene()
  self.objects = {}

  for key, attr in pairs(scene_objects) do
    local body = PhysicsManager.world:addBody(attr.type)
    x, y = unpack(attr.position)
    body:setTransform(unpack(attr.position))
    width, height = unpack(attr.size)

    local fixture = body:addRect(-width / 2, -height / 2, width / 2, height / 2)
    fixture:setFriction(attr.friction)

    self.objects[key] = { body = body, fixture = fixture }
  end
end

function Game:belongsToScene(fixture)
  for key, object in pairs(self.objects) do
    if object.fixture == fixture then
      return true
    end
  end

  return false
end

function Game:updateCamera()
  x, y = Character.physics.body:getPosition()
  Game.camera:setLoc(x, 0, 0.1, MOAIEaseType.LINEAR)
end
