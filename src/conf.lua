function love.conf(t)
  t.window.title = "LD48"
  t.window.icon = nil

  t.window.width = 30 * 20
  t.window.height = 30 * 25
  t.modules.joystick = false

  --Uncommon
  t.accelerometerjoystick = false
  t.audio.mic = false
end
