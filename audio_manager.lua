module("AudioManager", package.seeall)

sounds = {}

local audio_definitions = {
  backgroundMusic = {
    type = RESOURCE_TYPE_SOUND,
    fileName = 'sounds/music.mp3',
    loop = true,
    volume = 1,
  },
  jump = {
    type = RESOURCE_TYPE_SOUND,
    fileName = 'sounds/jump.wav',
    loop = false,
    volume = 1,
  },
}

function AudioManager:initialize()
  ResourceDefinitions:setDefinitions(audio_definitions)
  MOAIUntzSystem.initialize()

  self:play('backgroundMusic')
end

function AudioManager:get(name)
  local audio = self.sounds[name]

  if not audio then
    audio = ResourceManager:get(name)
    self.sounds[name] = audio
  end

  return audio
end

function AudioManager:play(name, loop)
  local audio = AudioManager:get(name)

  if loop ~= nil then
    audio:setLooping(loop)
  end

  audio:play()
end

function AudioManager:stop(name)
  local audio = AudioManager:get(name)
  audio:stop()
end
