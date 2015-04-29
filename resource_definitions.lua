module("ResourceDefinitions", package.seeall)

local definitions = {}

function ResourceDefinitions:set(name, definition)
  definitions[name] = definition
end

function ResourceDefinitions:get(name)
  return definitions[name]
end

function ResourceDefinitions:remove(name)
  definitions[name] = nil
end
