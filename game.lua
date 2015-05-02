require 'resource_definitions'
require 'resource_manager'
require 'input_manager'
require 'character'
require 'physics_manager'

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
    fileName = 'character/hero.png',
    tileMapSize = { 3, 4 },
    width = 48, height = 64,
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

function Game:start()
  self:initialize()

  while(true) do
    self:processInput()
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
  Character:initialize(self.layers.foreground_trees)
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

function Game:processInput()
  local x, y = InputManager:deltaPosition()

  self.camera:moveLoc(x, 0, 0.5, MOAIEaseType.LINEAR)
end

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
