function love.conf(t)
  t.window.title = "LD47"
  t.window.icon = nil

  t.window.width = 30 * 32
  t.window.height = 30 * 16
  t.modules.joystick = false

  --Uncommon
  t.accelerometerjoystick = false
  t.audio.mic = false
end
