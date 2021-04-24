function love.conf(t)
  t.window.title = "New Babel"
  t.window.icon = nil

  t.window.width = 32 * 20
  t.window.height = 32 * 25
  t.modules.joystick = false

  --Uncommon
  t.accelerometerjoystick = false
  t.audio.mic = false
end
