require 'resource_definitions'
require 'resource_manager'
require 'input_manager'

module("Game", package.seeall)

local resource_definitions = {
  background = {
    type =  RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-bg.png',
    width = 272, height = 160
  },
  farAway = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-montain-far.png',
    width = 272, height = 160
  },
  main = {
    type = RESOURCE_TYPE_IMAGE,
    fileName = 'images/parallax-mountain-foreground-trees.png',
    width = 544, height = 160
  },
}

local background_objects = {
  background = {
    position = { 0, 0 },
    parallax = { 0.05, 0.05 }
  },
  farAway = {
    position = { 0, 0 },
    parallax = { 0.1, 0.1 }
  },
  main = {
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
  self.layers.farAway = MOAILayer2D.new()
  self.layers.main = MOAILayer2D.new()

  for key, layer in pairs(self.layers) do
    layer:setViewport(viewport)
    layer:setCamera(self.camera)
  end

  local renderTable = {
    self.layers.background,
    self.layers.farAway,
    self.layers.main
  }

  MOAIRenderMgr.setRenderTable(renderTable)
end
