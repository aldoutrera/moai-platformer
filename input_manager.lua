module("InputManager", package.seeall)

local pointerX, pointerY = 0, 0
local previousX, previousY = 0, 0

function InputManager:initialize()
  if MOAIInputMgr.device.pointer then
    local pointerCallback = function(x, y)
      previousX, previewY = pointerX, pointerY
      pointerX, pointerY = x, y

      if touchCallbackFunc then
        touchCallbackFunc(MOAITouchSensor.TOUCH_MOVE, 1, pointerX, pointerY, 1)
      end
    end

    MOAIInputMgr.device.pointer:setCallback(pointerCallback)
  end
end

function InputManager:position()
  return pointerX, pointerY
end

function InputManager:previousPosition()
  return previousX, previousY
end

function InputManager:deltaPosition()
  return pointerX - previousX, previousY - pointerY
end

function InputManager:isDown()
  if MOAIInputMgr.device.touch then
    return MOAIInputMgr.device.touch:isDown()
  elseif MOAIInputMgr.device.pointer then
    return (MOAIInputMgr.device.mouseLeft:isDown())
  end
end
