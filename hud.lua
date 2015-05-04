module("HUD", package.seeall)

function HUD:initialize()
  self.viewport = MOAIViewport.new()

  viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
  viewport:setScale(SCREEN_RESOLUTION_X, -SCREEN_RESOLUTION_Y)
  viewport:setOffset(-1, 1)

  self.layer = MOAILayer2D.new()
  self.layer:setViewport(self.viewport)

  local renderTable = MOAIRenderMgr.getRenderTable()
  table.insert(renderTable, self.layer)

  MOAIRenderMgr.setRenderTable(renderTable)

  self:initializeDebugHud()
end

function HUD:initializeDebugHud()
  self.font = MOAIFont.new()
  self.font = ResourceManager:get('hudFont')
  self.leftRightIndicator = self:newDebugTextBox(30, { 10, 10, 100, 50 })
  self.positionIndicator = self:newDebugTextBox(30, { 10, 50, 200, 100 })
end

function HUD:newDebugTextBox(size, rectangle)
  local textBox = MOAITextBox.new()
  textBox:setFont(self.font)
  textBox:setTextSize(size)
  textBox:setRect(unpack(rectangle))

  layer:insertProp(textBox)

  return textBox
end

function HUD:update()
  local x, y = Character.prop:getScl()

  if x > 0 then
    self.leftRightIndicator:setString("Left")
  else
    self.leftRightIndicator:setString("Right")
  end

  x, y = Character.physics.body:getPosition()
  self.positionIndicator:setString("(" .. math.floor(x) .. ", " .. math.floor(y) .. ")")
end
